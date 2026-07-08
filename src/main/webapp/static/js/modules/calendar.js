/**
 * 日历贡献图模块
 * 负责生成GitHub风格的贡献热力图
 */

const CalendarModule = {
    MONTH_NAMES: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
    LEVEL_TEXTS: {
        0: '无提交',
        1: '1-2 次提交',
        2: '3-5 次提交',
        3: '6-10 次提交',
        4: '10+ 次提交'
    },

    init() {
        this.render();
    },

    render() {
        const graph = document.getElementById('contributionGraph');
        const months = document.getElementById('calendarMonths');
        const title = document.getElementById('calendarTitle');

        if (!graph || !title) return;

        const today = new Date();
        const oneYearAgo = new Date(today);
        oneYearAgo.setFullYear(oneYearAgo.getFullYear() - 1);

        title.textContent = `${oneYearAgo.getFullYear()} - ${today.getFullYear()}`;
        this.renderMonthLabels(oneYearAgo, today, months);
        this.renderCells(oneYearAgo, today, graph);
        this.setupSyncScroll();
    },

    renderMonthLabels(startDate, endDate, container) {
        if (!container) return;

        let html = '';
        let currentMonth = -1;
        const current = new Date(startDate);

        while (current <= endDate) {
            const month = current.getMonth();
            if (month !== currentMonth) {
                html += `<span class="month-label">${current.getFullYear()}年${this.MONTH_NAMES[month]}</span>`;
                currentMonth = month;
            }
            current.setDate(current.getDate() + 7);
        }

        container.innerHTML = html;
    },

    renderCells(startDate, endDate, container) {
        const start = new Date(startDate);
        start.setDate(start.getDate() - start.getDay());

        let html = '';
        for (let day = 0; day < 7; day++) {
            let rowHtml = '<div class="graph-row">';
            const current = new Date(start);
            current.setDate(current.getDate() + day);

            while (current <= endDate) {
                const level = this.getRandomLevel();
                let classes = `graph-cell level-${level}`;
                if (this.isToday(current)) classes += ' today';

                rowHtml += `<div class="${classes}" title="${this.formatDate(current)}: ${this.LEVEL_TEXTS[level]}"></div>`;
                current.setDate(current.getDate() + 7);
            }

            rowHtml += '</div>';
            html += rowHtml;
        }

        container.innerHTML = html;
    },

    setupSyncScroll() {
        const graph = document.getElementById('contributionGraph');
        const months = document.getElementById('calendarMonths');

        if (!graph || !months) return;

        graph.addEventListener('scroll', () => {
            months.scrollLeft = graph.scrollLeft;
        });
        months.addEventListener('scroll', () => {
            graph.scrollLeft = months.scrollLeft;
        });
    },

    getRandomLevel() {
        const rand = Math.random();
        if (rand > 0.7) return 0;
        if (rand > 0.5) return 1;
        if (rand > 0.3) return 2;
        if (rand > 0.1) return 3;
        return 4;
    },

    isToday(date) {
        const today = new Date();
        return date.getDate() === today.getDate() &&
               date.getMonth() === today.getMonth() &&
               date.getFullYear() === today.getFullYear();
    },

    formatDate(date) {
        return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
    }
};

document.addEventListener('DOMContentLoaded', () => {
    CalendarModule.init();
});
