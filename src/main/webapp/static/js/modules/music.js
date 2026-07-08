/**
 * 音乐播放模块
 * 负责音乐播放控制和列表交互
 */

const MusicModule = {
    audio: null,
    currentIndex: 0,
    musicList: [],

    init() {
        this.audio = document.createElement('audio');
        this.audio.loop = false;
        this.audio.preload = 'metadata';
        
        this.loadMusicList();
        this.bindEvents();
        this.setupAudioEvents();
    },

    loadMusicList() {
        const items = document.querySelectorAll('.music-popup .music-item');
        items.forEach((item, index) => {
            this.musicList.push({
                url: item.dataset.url,
                title: item.dataset.title,
                cover: item.dataset.cover,
                artist: item.querySelector('.music-item-artist')?.textContent || ''
            });
            item.dataset.index = index;
        });
    },

    bindEvents() {
        const playBtn = document.getElementById('playBtn');
        const musicCover = document.getElementById('musicCover');

        if (playBtn && musicCover) {
            playBtn.addEventListener('click', (e) => {
                e.stopPropagation();
                this.togglePlay();
            });
        }

        document.querySelectorAll('.music-popup .music-item').forEach(item => {
            item.addEventListener('click', (e) => {
                e.stopPropagation();
                this.selectMusic(parseInt(item.dataset.index));
            });
        });
    },

    setupAudioEvents() {
        const progressBar = document.getElementById('musicProgressBar');
        const currentTime = document.getElementById('musicCurrentTime');
        const duration = document.getElementById('musicDuration');

        this.audio.addEventListener('loadedmetadata', () => {
            if (duration) {
                duration.textContent = this.formatTime(this.audio.duration);
            }
        });

        this.audio.addEventListener('timeupdate', () => {
            if (progressBar && this.audio.duration) {
                const percent = (this.audio.currentTime / this.audio.duration) * 100;
                progressBar.style.width = percent + '%';
            }
            if (currentTime) {
                currentTime.textContent = this.formatTime(this.audio.currentTime);
            }
        });

        this.audio.addEventListener('ended', () => {
            this.next();
        });

        this.audio.addEventListener('error', (e) => {
            console.error('Audio error:', e);
            this.next();
        });
    },

    togglePlay() {
        const playBtn = document.getElementById('playBtn');
        const musicCover = document.getElementById('musicCover');

        if (!playBtn || !musicCover) return;

        if (this.audio.paused) {
            if (!this.audio.src) {
                if (this.musicList.length > 0) {
                    this.selectMusic(0);
                }
                return;
            }
            this.audio.play().then(() => {
                this.updatePlayButton(true);
                musicCover.classList.remove('paused');
            }).catch(err => {
                console.error('Play failed:', err);
            });
        } else {
            this.audio.pause();
            this.updatePlayButton(false);
            musicCover.classList.add('paused');
        }
    },

    updatePlayButton(isPlaying) {
        const playBtn = document.getElementById('playBtn');
        if (!playBtn) return;
        const iconPlay = playBtn.querySelector('.icon-play');
        const iconPause = playBtn.querySelector('.icon-pause');
        if (iconPlay && iconPause) {
            iconPlay.style.display = isPlaying ? 'none' : 'block';
            iconPause.style.display = isPlaying ? 'block' : 'none';
        }
    },

    selectMusic(index) {
        if (index < 0 || index >= this.musicList.length) return;

        this.currentIndex = index;
        const music = this.musicList[index];

        document.querySelectorAll('.music-popup .music-item').forEach((item, i) => {
            item.classList.toggle('active', i === index);
        });

        const musicTitle = document.getElementById('musicTitle');
        const musicCover = document.getElementById('musicCover');

        if (musicTitle) musicTitle.textContent = music.title;
        if (music.cover && musicCover) {
            musicCover.style.backgroundImage = `url('${music.cover}')`;
            musicCover.style.backgroundSize = 'cover';
            musicCover.style.backgroundPosition = 'center';
        }

        this.audio.src = music.url;
        
        this.updatePlayButton(true);
        if (musicCover) {
            musicCover.classList.remove('paused');
        }

        this.audio.play().catch(err => {
            console.error('Play failed:', err);
        });
    },

    prev() {
        const newIndex = this.currentIndex > 0 ? this.currentIndex - 1 : this.musicList.length - 1;
        this.selectMusic(newIndex);
    },

    next() {
        const newIndex = this.currentIndex < this.musicList.length - 1 ? this.currentIndex + 1 : 0;
        this.selectMusic(newIndex);
    },

    formatTime(seconds) {
        if (isNaN(seconds)) return '0:00';
        const mins = Math.floor(seconds / 60);
        const secs = Math.floor(seconds % 60);
        return `${mins}:${secs.toString().padStart(2, '0')}`;
    }
};

function prevMusic() {
    MusicModule.prev();
}

function nextMusic() {
    MusicModule.next();
}

document.addEventListener('DOMContentLoaded', () => {
    MusicModule.init();
});