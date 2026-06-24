/**
 * 时钟模块
 * 负责实时更新时间显示
 */

const ClockModule = {
    init() {
        this.update();
        setInterval(() => this.update(), 1000);
    },

    update() {
        const now = new Date();
        const time = this.formatTime(now);
        const date = this.formatDate(now);

        const clockTime = document.getElementById('clockTime');
        const clockDate = document.getElementById('clockDate');

        if (clockTime) clockTime.textContent = time;
        if (clockDate) clockDate.textContent = date;
    },

    formatTime(date) {
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
        return `${hours}:${minutes}:${seconds}`;
    },

    formatDate(date) {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}/${month}/${day}`;
    }
};

document.addEventListener('DOMContentLoaded', () => {
    ClockModule.init();
});
