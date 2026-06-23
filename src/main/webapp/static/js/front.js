// 创建星星背景
function createStars() {
    const starsContainer = document.getElementById('stars');
    if (!starsContainer) return;
    
    for (let i = 0; i < 60; i++) {
        const star = document.createElement('div');
        star.className = 'star';
        star.style.left = Math.random() * 100 + '%';
        star.style.top = Math.random() * 100 + '%';
        star.style.animationDelay = Math.random() * 3 + 's';
        star.style.width = (Math.random() * 2 + 1) + 'px';
        star.style.height = star.style.width;
        starsContainer.appendChild(star);
    }
}
createStars();

// 更新时钟
function updateClock() {
    const now = new Date();
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    const seconds = now.getSeconds().toString().padStart(2, '0');
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const weekDays = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'];
    const weekDay = weekDays[now.getDay()];
    
    const clockTime = document.getElementById('clockTime');
    const clockDate = document.getElementById('clockDate');
    
    if (clockTime) clockTime.textContent = `${hours}:${minutes}:${seconds}`;
    if (clockDate) clockDate.textContent = `${year}年${month}月${day}日 ${weekDay}`;
}
updateClock();
setInterval(updateClock, 1000);

// 设置弹窗
const settingsBtn = document.getElementById('settingsBtn');
const settingsModal = document.getElementById('settingsModal');
const modalOverlay = document.getElementById('modalOverlay');
const modalClose = document.getElementById('modalClose');

if (settingsBtn && settingsModal && modalOverlay) {
    settingsBtn.addEventListener('click', () => {
        settingsModal.classList.add('active');
        modalOverlay.classList.add('active');
    });

    if (modalClose) {
        modalClose.addEventListener('click', () => {
            settingsModal.classList.remove('active');
            modalOverlay.classList.remove('active');
        });
    }

    modalOverlay.addEventListener('click', () => {
        settingsModal.classList.remove('active');
        modalOverlay.classList.remove('active');
    });
}

// Tab切换
const tabs = document.querySelectorAll('.tab');
const sections = document.querySelectorAll('.setting-section');

tabs.forEach(tab => {
    tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        
        sections.forEach(s => s.classList.remove('active'));
        const targetSection = document.getElementById(tab.dataset.tab);
        if (targetSection) {
            targetSection.classList.add('active');
        }
    });
});

// 音乐播放器
const playBtn = document.getElementById('playBtn');
const musicCover = document.getElementById('musicCover');

if (playBtn && musicCover) {
    playBtn.addEventListener('click', (e) => {
        e.stopPropagation();
        if (playBtn.textContent === '▶') {
            playBtn.textContent = '❚❚';
            musicCover.classList.remove('paused');
        } else {
            playBtn.textContent = '▶';
            musicCover.classList.add('paused');
        }
    });
}

// 搜索功能
const searchInput = document.getElementById('searchInput');
if (searchInput) {
    searchInput.addEventListener('keypress', (e) => {
        if (e.key === 'Enter') {
            const keyword = searchInput.value.trim();
            if (keyword) {
                window.location.href = '/?keyword=' + encodeURIComponent(keyword);
            }
        }
    });
}

// 预览项点击
const previewItems = document.querySelectorAll('.preview-item');
previewItems.forEach(item => {
    item.addEventListener('click', () => {
        previewItems.forEach(i => i.classList.remove('active'));
        item.classList.add('active');
    });
});

// 音乐列表项点击
const musicItems = document.querySelectorAll('.music-popup .music-item');
musicItems.forEach(item => {
    item.addEventListener('click', (e) => {
        e.stopPropagation();
        musicItems.forEach(i => i.classList.remove('active'));
        item.classList.add('active');
        
        const title = item.dataset.title;
        const musicTitle = document.getElementById('musicTitle');
        if (musicTitle) {
            musicTitle.textContent = title;
        }
    });
});

function prevMusic() {
    console.log('上一曲');
}

function nextMusic() {
    console.log('下一曲');
}