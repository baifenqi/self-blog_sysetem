/**
 * Music Player Module
 */

var MusicModule = {
    audio: null,
    currentIndex: 0,
    musicList: [],

    init: function() {
        this.audio = document.createElement('audio');
        this.audio.loop = false;
        this.audio.preload = 'metadata';
        document.body.appendChild(this.audio);

        this.loadMusicList();
        this.bindEvents();
        this.setupAudioEvents();
        this.restorePlaybackState();
    },

    savePlaybackState: function() {
        var state = {
            currentIndex: this.currentIndex,
            currentTime: this.audio.currentTime,
            isPlaying: !this.audio.paused,
            src: this.audio.src
        };
        localStorage.setItem('blogMusicState', JSON.stringify(state));
    },

    restorePlaybackState: function() {
        var savedState = localStorage.getItem('blogMusicState');
        if (savedState) {
            try {
                var state = JSON.parse(savedState);
                if (state.src && state.src !== this.audio.src) {
                    this.audio.src = state.src;
                    this.currentIndex = state.currentIndex;

                    var musicTitle = document.getElementById('musicTitle');
                    var musicCover = document.getElementById('musicCover');
                    if (this.musicList[this.currentIndex]) {
                        var music = this.musicList[this.currentIndex];
                        if (musicTitle) musicTitle.textContent = music.title;
                        if (music.cover && musicCover) {
                            musicCover.style.backgroundImage = 'url(' + music.cover + ')';
                            musicCover.style.backgroundSize = 'cover';
                            musicCover.style.backgroundPosition = 'center';
                        }
                    }

                    var self = this;
                    document.querySelectorAll('.music-popup .music-item').forEach(function(item, i) {
                        item.classList.toggle('active', i === self.currentIndex);
                    });
                }

                if (state.currentTime) {
                    this.audio.currentTime = state.currentTime;
                }

                var self = this;
                if (state.isPlaying) {
                    this.audio.play().then(function() {
                        self.updatePlayButton(true);
                        var musicCover = document.getElementById('musicCover');
                        if (musicCover) musicCover.classList.remove('paused');
                    }).catch(function(err) {
                        console.log('Autoplay blocked');
                        self.updatePlayButton(false);
                    });
                } else {
                    this.updatePlayButton(false);
                    var musicCover = document.getElementById('musicCover');
                    if (musicCover) musicCover.classList.add('paused');
                }
            } catch (e) {
                console.error('Failed to restore playback state:', e);
            }
        }
    },

    loadMusicList: function() {
        var items = document.querySelectorAll('.music-popup .music-item');
        if (items.length === 0) {
            return;
        }
        var self = this;
        items.forEach(function(item, index) {
            self.musicList.push({
                url: item.dataset.url,
                title: item.dataset.title,
                cover: item.dataset.cover,
                artist: item.querySelector('.music-item-artist') ? item.querySelector('.music-item-artist').textContent : ''
            });
            item.dataset.index = index;
        });
    },

    bindEvents: function() {
        var playBtn = document.getElementById('playBtn');
        var musicCover = document.getElementById('musicCover');
        var self = this;

        if (playBtn && musicCover) {
            playBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                self.togglePlay();
            });
        }

        document.querySelectorAll('.music-popup .music-item').forEach(function(item) {
            item.addEventListener('click', function(e) {
                e.stopPropagation();
                self.selectMusic(parseInt(item.dataset.index));
            });
        });
    },

    setupAudioEvents: function() {
        var progressBar = document.getElementById('musicProgressBar');
        var currentTime = document.getElementById('musicCurrentTime');
        var duration = document.getElementById('musicDuration');
        var self = this;

        this.audio.addEventListener('loadedmetadata', function() {
            if (duration) {
                duration.textContent = self.formatTime(self.audio.duration);
            }
        });

        this.audio.addEventListener('timeupdate', function() {
            if (progressBar && self.audio.duration) {
                var percent = (self.audio.currentTime / self.audio.duration) * 100;
                progressBar.style.width = percent + '%';
            }
            if (currentTime) {
                currentTime.textContent = self.formatTime(self.audio.currentTime);
            }
            if (!self.audio.paused) {
                self.savePlaybackState();
            }
        });

        this.audio.addEventListener('ended', function() {
            self.next();
        });

        this.audio.addEventListener('error', function(e) {
            console.error('Audio error:', e);
            self.next();
        });
    },

    togglePlay: function() {
        var playBtn = document.getElementById('playBtn');
        var musicCover = document.getElementById('musicCover');

        if (!playBtn || !musicCover) return;

        if (this.audio.paused) {
            if (!this.audio.src) {
                if (this.musicList.length > 0) {
                    this.selectMusic(0);
                }
                return;
            }
            var self = this;
            this.audio.play().then(function() {
                self.updatePlayButton(true);
                musicCover.classList.remove('paused');
                self.savePlaybackState();
            }).catch(function(err) {
                console.error('Play failed:', err);
            });
        } else {
            this.audio.pause();
            this.updatePlayButton(false);
            musicCover.classList.add('paused');
            this.savePlaybackState();
        }
    },

    updatePlayButton: function(isPlaying) {
        var playBtn = document.getElementById('playBtn');
        if (!playBtn) return;
        var iconPlay = playBtn.querySelector('.icon-play');
        var iconPause = playBtn.querySelector('.icon-pause');
        if (iconPlay && iconPause) {
            iconPlay.style.display = isPlaying ? 'none' : 'block';
            iconPause.style.display = isPlaying ? 'block' : 'none';
        }
    },

    selectMusic: function(index) {
        if (index < 0 || index >= this.musicList.length) return;

        this.currentIndex = index;
        var music = this.musicList[index];

        document.querySelectorAll('.music-popup .music-item').forEach(function(item, i) {
            item.classList.toggle('active', i === index);
        });

        var musicTitle = document.getElementById('musicTitle');
        var musicCover = document.getElementById('musicCover');

        if (musicTitle) musicTitle.textContent = music.title;
        if (music.cover && musicCover) {
            musicCover.style.backgroundImage = 'url(' + music.cover + ')';
            musicCover.style.backgroundSize = 'cover';
            musicCover.style.backgroundPosition = 'center';
        }

        this.audio.src = music.url;

        this.updatePlayButton(true);
        if (musicCover) {
            musicCover.classList.remove('paused');
        }

        var self = this;
        this.audio.play().then(function() {
            self.savePlaybackState();
        }).catch(function(err) {
            console.error('Play failed:', err);
        });
    },

    prev: function() {
        var newIndex = this.currentIndex > 0 ? this.currentIndex - 1 : this.musicList.length - 1;
        this.selectMusic(newIndex);
    },

    next: function() {
        var newIndex = this.currentIndex < this.musicList.length - 1 ? this.currentIndex + 1 : 0;
        this.selectMusic(newIndex);
    },

    formatTime: function(seconds) {
        if (isNaN(seconds)) return '0:00';
        var mins = Math.floor(seconds / 60);
        var secs = Math.floor(seconds % 60);
        return mins + ':' + (secs.toString().padStart(2, '0'));
    }
};

function prevMusic() {
    MusicModule.prev();
}

function nextMusic() {
    MusicModule.next();
}

document.addEventListener('DOMContentLoaded', function() {
    MusicModule.init();
});