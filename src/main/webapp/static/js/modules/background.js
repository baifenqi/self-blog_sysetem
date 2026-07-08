/**
 * 背景设置模块
 * 负责处理背景预设主题选择和自定义图片上传
 */

const BackgroundModule = {
    API: {
        GET: contextPath + '/api/setting/background',
        SAVE: contextPath + '/api/setting/background',
        UPLOAD: contextPath + '/api/setting/background/upload'
    },

    init() {
        this.loadSettings();
        this.bindEvents();
    },

    bindEvents() {
        // 预设背景点击事件
        document.querySelectorAll('.preview-item[data-bg]').forEach(option => {
            option.addEventListener('click', () => {
                this.applyTheme(option.dataset.bg);
            });
        });
    },

    applyTheme(theme) {
        const bgContainer = document.getElementById('bgContainer');
        if (!bgContainer) return;

        // 移除所有主题类
        bgContainer.className = 'bg-container';

        // 添加新主题类
        if (theme && theme !== 'default') {
            bgContainer.classList.add(`bg-${theme}`);
        }

        // 更新选中状态
        document.querySelectorAll('.preview-item[data-bg]').forEach(opt => {
            opt.classList.toggle('active', opt.dataset.bg === theme);
        });

        // 保存到服务器
        this.saveSettings({ theme, customImage: null });
    },

    uploadFile(file) {
        if (!file) return;
        if (file.size > 20 * 1024 * 1024) {
            alert('文件大小不能超过 20MB');
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        fetch(this.API.UPLOAD, {
            method: 'POST',
            body: formData
        })
        .then(res => res.json())
        .then(data => {
            if (data.code === 200) {
                this.applyCustomImage(data.data);
            } else {
                alert('上传失败：' + data.message);
            }
        })
        .catch(err => {
            console.error('上传失败:', err);
            alert('上传失败');
        });
    },

    applyCustomImage(url) {
        const bgContainer = document.getElementById('bgContainer');
        if (!bgContainer) return;

        bgContainer.style.backgroundImage = `url('${url}')`;
        bgContainer.style.backgroundSize = 'cover';
        bgContainer.style.backgroundPosition = 'center';

        this.saveSettings({ theme: 'custom', customImage: url });
    },

    async loadSettings() {
        try {
            const res = await fetch(this.API.GET);
            const data = await res.json();
            if (data.code === 200 && data.data) {
                this.applyLoadedSettings(data.data);
            }
        } catch (err) {
            console.error('加载背景设置失败:', err);
        }
    },

    applyLoadedSettings(setting) {
        if (setting.customImage) {
            this.applyCustomImage(setting.customImage);
        } else if (setting.theme) {
            this.applyTheme(setting.theme);
        }
    },

    saveSettings(setting) {
        fetch(this.API.SAVE, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(setting)
        }).catch(err => console.error('保存背景设置失败:', err));
    }
};

function uploadBackground(input) {
    if (input.files && input.files[0]) {
        BackgroundModule.uploadFile(input.files[0]);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    BackgroundModule.init();
});
