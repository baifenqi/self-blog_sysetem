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
    if (clockDate) clockDate.textContent = `${year}/${month}/${day}`;
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

// 贡献图日历功能
function generateContributionGraph() {
    const graph = document.getElementById('contributionGraph');
    const months = document.getElementById('calendarMonths');
    const title = document.getElementById('calendarTitle');
    if (!graph || !title) return;

    const today = new Date();
    const oneYearAgo = new Date(today);
    oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);
    
    title.textContent = `${oneYearAgo.getFullYear()} - ${today.getFullYear()}`;

    generateMonthLabels(oneYearAgo, today, months);

    let html = '';
    
    const startDate = new Date(oneYearAgo);
    startDate.setDate(startDate.getDate() - startDate.getDay());
    
    for (let weekDay = 0; weekDay < 7; weekDay++) {
        let rowHtml = `<div class="graph-row">`;
        
        let currentDate = new Date(startDate);
        currentDate.setDate(currentDate.getDate() + weekDay);
        
        while (currentDate <= today) {
            const level = getRandomLevel();
            let classes = `graph-cell level-${level}`;
            
            if (isToday(currentDate)) {
                classes += ' today';
            }
            
            rowHtml += `<div class="${classes}" title="${formatDate(currentDate)}: ${getLevelText(level)}"></div>`;
            
            currentDate.setDate(currentDate.getDate() + 7);
        }
        
        rowHtml += `</div>`;
        html += rowHtml;
    }

    graph.innerHTML = html;
    
    setupSyncScroll();
}

function setupSyncScroll() {
    const graph = document.getElementById('contributionGraph');
    const months = document.getElementById('calendarMonths');
    
    if (!graph || !months) return;
    
    graph.addEventListener('scroll', function() {
        months.scrollLeft = graph.scrollLeft;
    });
    
    months.addEventListener('scroll', function() {
        graph.scrollLeft = months.scrollLeft;
    });
}

function generateMonthLabels(startDate, endDate, container) {
    if (!container) return;
    
    const monthNames = ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'];
    
    let html = '';
    let currentMonth = -1;
    const currentDate = new Date(startDate);
    
    while (currentDate <= endDate) {
        const month = currentDate.getMonth();
        const year = currentDate.getFullYear();
        
        if (month !== currentMonth) {
            html += `<span class="month-label">${year}年${monthNames[month]}</span>`;
            currentMonth = month;
        }
        
        currentDate.setDate(currentDate.getDate() + 7);
    }
    
    container.innerHTML = html;
}

function getWeeksInMonth(year, month, firstDayOffset) {
    const firstDay = new Date(year, month, 1).getDay();
    const lastDay = new Date(year, month + 1, 0).getDate();
    
    const adjustedFirstDay = (firstDay + (firstDayOffset > 0 ? (7 - firstDayOffset) : 0)) % 7;
    const totalDays = adjustedFirstDay + lastDay;
    
    return Math.ceil(totalDays / 7);
}

function getRandomLevel() {
    const rand = Math.random();
    if (rand > 0.7) return 0;
    if (rand > 0.5) return 1;
    if (rand > 0.3) return 2;
    if (rand > 0.1) return 3;
    return 4;
}

function isToday(date) {
    const today = new Date();
    return date.getDate() === today.getDate() &&
           date.getMonth() === today.getMonth() &&
           date.getFullYear() === today.getFullYear();
}

function formatDate(date) {
    return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
}

function getLevelText(level) {
    switch(level) {
        case 0: return '无提交';
        case 1: return '1-2 次提交';
        case 2: return '3-5 次提交';
        case 3: return '6-10 次提交';
        case 4: return '10+ 次提交';
        default: return '';
    }
}

generateContributionGraph();

// 按钮跳转事件
function goToWrite() {
    window.location.href = '/article/write';
}

function goToDrafts() {
    window.location.href = '/article/drafts';
}

function goToStats() {
    window.location.href = '/stats';
}