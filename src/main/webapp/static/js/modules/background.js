/**
 * Background Settings Module
 */

var BackgroundModule = {
    API: {
        GET: contextPath + '/api/setting/background',
        SAVE: contextPath + '/api/setting/background',
        UPLOAD: contextPath + '/api/setting/background/upload',
        LIST: contextPath + '/api/setting/background/list'
    },

    currentBgUrl: null,

    init: function() {
        this.loadSettings();
        this.loadBackgroundList();
        this.bindEvents();
    },

    bindEvents: function() {
        var items = document.querySelectorAll('.preview-item[data-bg]');
        for (var i = 0; i < items.length; i++) {
            var self = this;
            items[i].addEventListener('click', function() {
                self.applyTheme(this.dataset.bg);
                self.saveSettings(this.dataset.bg);
            });
        }
    },

    applyTheme: function(theme) {
        var bgContainer = document.getElementById('bgContainer');
        if (!bgContainer) return;

        bgContainer.className = 'bg-container';
        bgContainer.style.backgroundImage = '';
        this.removeVideo(bgContainer);
        this.currentBgUrl = null;

        if (theme && theme !== 'default') {
            bgContainer.classList.add('bg-' + theme);
        }

        this.updateActiveState(theme);
    },

    removeVideo: function(container) {
        var video = container.querySelector('video');
        if (video) {
            video.pause();
            video.src = '';
            video.load();
            video.remove();
        }
    },

    isVideo: function(url) {
        if (!url) return false;
        var lower = url.toLowerCase();
        return lower.endsWith('.mp4') || lower.endsWith('.webm') || lower.endsWith('.mov');
    },

    uploadFile: function(file) {
        if (!file) return;
        if (file.size > 20 * 1024 * 1024) {
            alert('文件大小不能超过 20MB');
            return;
        }

        var formData = new FormData();
        formData.append('file', file);

        var self = this;
        fetch(this.API.UPLOAD, {
            method: 'POST',
            body: formData
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (data.code === 200) {
                self.applyCustomImage(data.data, true);
                self.loadBackgroundList();
            } else {
                alert('上传失败：' + data.message);
            }
        })
        .catch(function(err) {
            console.error('上传失败:', err);
            alert('上传失败');
        });
    },

    applyCustomImage: function(url, save) {
        var bgContainer = document.getElementById('bgContainer');
        if (!bgContainer) return;

        bgContainer.className = 'bg-container';
        bgContainer.style.backgroundImage = '';
        this.removeVideo(bgContainer);

        var fullUrl = url;
        if (url && !url.startsWith('http') && !url.startsWith(contextPath)) {
            fullUrl = contextPath + url;
        }
        this.currentBgUrl = fullUrl;

        if (this.isVideo(fullUrl)) {
            var video = document.createElement('video');
            video.src = fullUrl;
            video.autoplay = true;
            video.loop = true;
            video.muted = true;
            video.playsInline = true;
            video.setAttribute('playsinline', '');
            video.style.width = '100%';
            video.style.height = '100%';
            video.style.objectFit = 'cover';
            video.style.position = 'absolute';
            video.style.top = '0';
            video.style.left = '0';
            bgContainer.appendChild(video);
        } else {
            bgContainer.style.backgroundImage = "url('" + fullUrl + "')";
            bgContainer.style.backgroundSize = 'cover';
            bgContainer.style.backgroundPosition = 'center';
        }

        this.updateActiveState(null);
        this.updateActiveByUrl(fullUrl);
        if (save) {
            this.saveSettings(url);
        }
    },

    loadBackgroundList: function() {
        var self = this;
        fetch(this.API.LIST)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200 && data.data) {
                    self.renderBackgroundList(data.data);
                }
            })
            .catch(function(err) { console.error('加载背景列表失败:', err); });
    },

    renderBackgroundList: function(list) {
        var systemGrid = document.getElementById('systemBgGrid');
        var localGrid = document.getElementById('localBgGrid');

        var systemList = [];
        var uploadList = [];
        for (var i = 0; i < list.length; i++) {
            if (list[i].source === 'builtin') {
                systemList.push(list[i]);
            } else {
                uploadList.push(list[i]);
            }
        }

        if (systemGrid) {
            systemGrid.innerHTML = '';
            for (var j = 0; j < systemList.length; j++) {
                systemGrid.appendChild(this.createBgItem(systemList[j]));
            }
        }

        if (localGrid) {
            var uploadBtn = localGrid.querySelector('.preview-item[onclick]');
            localGrid.innerHTML = '';
            if (uploadBtn) {
                localGrid.appendChild(uploadBtn);
            }
            for (var k = 0; k < uploadList.length; k++) {
                localGrid.appendChild(this.createBgItem(uploadList[k]));
            }
        }

        if (this.currentBgUrl) {
            this.updateActiveByUrl(this.currentBgUrl);
        }
    },

    createBgItem: function(item) {
        var self = this;
        var div = document.createElement('div');
        div.className = 'preview-item';
        div.title = item.name;
        div.dataset.url = item.url;
        div.style.overflow = 'hidden';

        if (item.type === 'video') {
            self.loadVideoThumb(div, contextPath + item.url);
        } else {
            div.style.backgroundImage = "url('" + contextPath + item.url + "')";
            div.style.backgroundSize = 'cover';
            div.style.backgroundPosition = 'center';
        }

        (function(url) {
            div.addEventListener('click', function() {
                self.applyCustomImage(contextPath + url, true);
            });
        })(item.url);

        return div;
    },

    loadVideoThumb: function(div, videoUrl) {
        var video = document.createElement('video');
        video.src = videoUrl;
        video.muted = true;
        video.playsInline = true;
        video.preload = 'metadata';
        video.style.width = '100%';
        video.style.height = '100%';
        video.style.objectFit = 'cover';
        video.style.position = 'absolute';
        video.style.top = '0';
        video.style.left = '0';
        video.style.pointerEvents = 'none';
        div.appendChild(video);

        video.addEventListener('loadeddata', function() {
            try {
                video.currentTime = 0.5;
            } catch (e) {}
        });
    },

    updateActiveByUrl: function(url) {
        if (!url) return;
        var allItems = document.querySelectorAll('#systemBgGrid .preview-item, #localBgGrid .preview-item');
        for (var i = 0; i < allItems.length; i++) {
            var itemUrl = allItems[i].dataset.url;
            if (itemUrl) {
                var fullItemUrl = contextPath + itemUrl;
                if (url === itemUrl || url === fullItemUrl
                    || url.indexOf(itemUrl) !== -1 || itemUrl.indexOf(url) !== -1
                    || fullItemUrl.indexOf(url) !== -1 || url.indexOf(fullItemUrl) !== -1) {
                    allItems[i].classList.add('active');
                } else {
                    allItems[i].classList.remove('active');
                }
            }
        }
    },

    updateActiveState: function(theme) {
        var allItems = document.querySelectorAll('#systemBgGrid .preview-item, #localBgGrid .preview-item');
        for (var i = 0; i < allItems.length; i++) {
            allItems[i].classList.remove('active');
        }
    },

    loadSettings: function() {
        var self = this;
        fetch(this.API.GET)
            .then(function(res) { return res.json(); })
            .then(function(data) {
                if (data.code === 200 && data.data) {
                    self.applyLoadedSettings(data.data);
                }
            })
            .catch(function(err) { console.error('加载背景设置失败:', err); });
    },

    applyLoadedSettings: function(value) {
        if (value && value !== 'default') {
            this.applyCustomImage(value, false);
        } else {
            this.applyTheme('default');
        }
    },

    saveSettings: function(background) {
        fetch(this.API.SAVE, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ background: background })
        }).catch(function(err) { console.error('保存背景设置失败:', err); });
    }
};

function uploadBackground(input) {
    if (input.files && input.files[0]) {
        BackgroundModule.uploadFile(input.files[0]);
    }
}

document.addEventListener('DOMContentLoaded', function() {
    BackgroundModule.init();
});
