/**
 * 月历卡片模块
 * 科技感月历风格，显示当月日期和文章数量
 * 支持点击日期查看当天文章列表
 */

var CalendarModule = {
    WEEKDAYS: ['日', '一', '二', '三', '四', '五', '六'],
    currentDate: new Date(),
    articleCounts: {}, // 存储当月每天的文章数量 { 'YYYY-MM-DD': count }
    _initialized: false,
    _panelEl: null,

    // 获取 contextPath
    getContextPath() {
        return window._contextPath || window.contextPath || '/blog';
    },

    init() {
        if (this._initialized) return;
        this._initialized = true;
        this.createArticlesPanel();
        this.render();
        this.bindEvents();
    },

    render() {
        this.loadMonthData().then(() => {
            this.renderCalendar();
        });
    },

    // 加载当月文章统计数据
    loadMonthData() {
        var year = this.currentDate.getFullYear();
        var month = this.currentDate.getMonth() + 1;
        var url = this.getContextPath() + '/api/calendar/count?year=' + year + '&month=' + month;

        return fetch(url)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.code === 200 && data.data) {
                    CalendarModule.articleCounts = data.data;
                } else {
                    CalendarModule.articleCounts = {};
                }
            })
            .catch(function() {
                CalendarModule.articleCounts = {};
            });
    },

    // 根据文章数量获取等级
    getLevelByCount(count) {
        if (!count || count <= 0) return 0;
        if (count <= 2) return 1;
        if (count <= 5) return 2;
        if (count <= 10) return 3;
        return 4;
    },

    // 获取某天的文章数量
    getArticleCount(year, month, day) {
        var dateStr = year + '-' + String(month + 1).padStart(2, '0') + '-' + String(day).padStart(2, '0');
        return this.articleCounts[dateStr] || 0;
    },

    renderCalendar() {
        var weekdaysEl = document.getElementById('calendarWeekdays');
        var daysEl = document.getElementById('calendarDays');
        var titleEl = document.getElementById('calendarTitle');

        if (!weekdaysEl || !daysEl || !titleEl) return;

        var year = this.currentDate.getFullYear();
        var month = this.currentDate.getMonth();

        // 标题
        titleEl.textContent = '📅 ' + year + '年' + (month + 1) + '月';

        // 星期标题
        var weekdaysHtml = '';
        for (var i = 0; i < this.WEEKDAYS.length; i++) {
            var isWeekend = i === 0 || i === 6;
            weekdaysHtml += '<div class="weekday ' + (isWeekend ? 'weekend' : '') + '">' + this.WEEKDAYS[i] + '</div>';
        }
        weekdaysEl.innerHTML = weekdaysHtml;

        // 计算日期
        var firstDay = new Date(year, month, 1);
        var lastDay = new Date(year, month + 1, 0);
        var startWeekday = firstDay.getDay();
        var daysInMonth = lastDay.getDate();

        // 上个月的最后几天
        var prevMonthLastDay = new Date(year, month, 0).getDate();

        var daysHtml = '';

        // 上个月的日期
        for (var i = startWeekday - 1; i >= 0; i--) {
            var day = prevMonthLastDay - i;
            daysHtml += this.createDayElement(day, true, 0, false, year, month - 1);
        }

        // 当月日期
        var today = new Date();
        for (var d = 1; d <= daysInMonth; d++) {
            var isToday = d === today.getDate() &&
                           month === today.getMonth() &&
                           year === today.getFullYear();
            var count = this.getArticleCount(year, month, d);
            var level = this.getLevelByCount(count);
            daysHtml += this.createDayElement(d, false, level, isToday, year, month, count);
        }

        // 下个月的日期（补齐6行）
        var totalCells = startWeekday + daysInMonth;
        var remaining = totalCells % 7 === 0 ? 0 : 7 - (totalCells % 7);
        for (var nd = 1; nd <= remaining; nd++) {
            daysHtml += this.createDayElement(nd, true, 0, false, year, month + 1);
        }

        daysEl.innerHTML = daysHtml;
    },

    createDayElement(day, isOtherMonth, level, isToday, year, month, count) {
        var classes = 'calendar-day';
        if (isOtherMonth) classes += ' other-month';
        if (isToday) classes += ' today';
        if (level > 0) classes += ' level-' + level;

        // 构建日期字符串用于 data 属性
        var dateYear = year;
        var dateMonth = month;
        if (month < 0) {
            dateMonth = 11;
            dateYear = year - 1;
        } else if (month > 11) {
            dateMonth = 0;
            dateYear = year + 1;
        }
        var dateStr = dateYear + '-' + String(dateMonth + 1).padStart(2, '0') + '-' + String(day).padStart(2, '0');

        var countText = count && count > 0 ? count + '篇' : '';

        return '<div class="' + classes + '" data-date="' + dateStr + '" data-has-articles="' + (count > 0 ? 'true' : 'false') + '">' +
            '<span class="day-number">' + day + '</span>' +
            (countText ? '<span class="day-count">' + countText + '</span>' : '') +
            '</div>';
    },

    // 创建文章列表面板
    createArticlesPanel() {
        var panel = document.createElement('div');
        panel.className = 'date-articles-panel';
        panel.id = 'dateArticlesPanel';
        panel.style.display = 'none';
        panel.innerHTML =
            '<div class="date-articles-header">' +
                '<span class="date-articles-title" id="dateArticlesTitle">文章列表</span>' +
                '<button class="date-articles-close" id="dateArticlesClose">&times;</button>' +
            '</div>' +
            '<div class="date-articles-list" id="dateArticlesList"></div>';

        // 将面板添加到 calendar-section 中
        var calendarSection = document.querySelector('.calendar-section');
        if (calendarSection) {
            calendarSection.appendChild(panel);
        } else {
            document.body.appendChild(panel);
        }

        this._panelEl = panel;

        // 绑定关闭按钮事件
        var closeBtn = document.getElementById('dateArticlesClose');
        if (closeBtn) {
            closeBtn.addEventListener('click', function() {
                CalendarModule.hideArticlesPanel();
            });
        }
    },

    // 显示文章列表面板
    showArticlesPanel(dateStr, articles) {
        var panel = this._panelEl;
        if (!panel) return;

        var titleEl = document.getElementById('dateArticlesTitle');
        var listEl = document.getElementById('dateArticlesList');

        // 解析日期
        var parts = dateStr.split('-');
        var month = parseInt(parts[1], 10);
        var day = parseInt(parts[2], 10);
        var count = articles ? articles.length : 0;

        titleEl.textContent = month + '月' + day + '日 的文章 (' + count + '篇)';

        if (!articles || articles.length === 0) {
            listEl.innerHTML = '<div class="date-articles-empty">当天暂无文章</div>';
        } else {
            var html = '';
            for (var i = 0; i < articles.length; i++) {
                var article = articles[i];
                var articleUrl = this.getContextPath() + '/article/' + (article.slug || article.id);
                var categoryName = article.categoryName || '未分类';
                var createTime = article.createTime ? this.formatTime(article.createTime) : '';

                html +=
                    '<div class="date-article-item" onclick="location.href=\'' + articleUrl + '\'">' +
                        '<div class="date-article-title">' + this.escapeHtml(article.title) + '</div>' +
                        '<div class="date-article-meta">' +
                            '<span class="date-article-category">' + this.escapeHtml(categoryName) + '</span>' +
                            '<span class="date-article-time">' + createTime + '</span>' +
                        '</div>' +
                    '</div>';
            }
            listEl.innerHTML = html;
        }

        panel.style.display = 'block';
        // 添加显示动画
        panel.classList.add('visible');
    },

    // 隐藏文章列表面板
    hideArticlesPanel() {
        var panel = this._panelEl;
        if (!panel) return;
        panel.classList.remove('visible');
        setTimeout(function() {
            panel.style.display = 'none';
        }, 200);
    },

    // 加载某天的文章列表
    loadDayArticles(dateStr) {
        var url = this.getContextPath() + '/api/calendar/articles?date=' + dateStr;

        return fetch(url)
            .then(function(response) { return response.json(); })
            .then(function(data) {
                if (data.code === 200 && data.data) {
                    return data.data;
                }
                return [];
            })
            .catch(function() {
                return [];
            });
    },

    // 处理日期点击
    handleDayClick(dateStr) {
        var self = this;
        this.loadDayArticles(dateStr).then(function(articles) {
            self.showArticlesPanel(dateStr, articles);
        });
    },

    // 格式化时间
    formatTime(time) {
        if (!time) return '';
        var d = new Date(time);
        var h = String(d.getHours()).padStart(2, '0');
        var m = String(d.getMinutes()).padStart(2, '0');
        return h + ':' + m;
    },

    // HTML 转义
    escapeHtml(str) {
        if (!str) return '';
        return str.replace(/&/g, '&amp;')
                  .replace(/</g, '&lt;')
                  .replace(/>/g, '&gt;')
                  .replace(/"/g, '&quot;');
    },

    bindEvents() {
        var prevBtn = document.getElementById('prevMonth');
        var nextBtn = document.getElementById('nextMonth');
        var self = this;

        if (prevBtn) {
            prevBtn.addEventListener('click', function() {
                self.currentDate.setMonth(self.currentDate.getMonth() - 1);
                self.hideArticlesPanel();
                self.render();
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', function() {
                self.currentDate.setMonth(self.currentDate.getMonth() + 1);
                self.hideArticlesPanel();
                self.render();
            });
        }

        // 日期格子点击事件（事件委托）
        var daysEl = document.getElementById('calendarDays');
        if (daysEl) {
            daysEl.addEventListener('click', function(e) {
                var dayEl = e.target.closest('.calendar-day');
                if (!dayEl) return;
                if (dayEl.classList.contains('other-month')) return;

                var dateStr = dayEl.getAttribute('data-date');
                if (dateStr) {
                    self.handleDayClick(dateStr);
                }
            });
        }

        // 点击面板外部关闭
        document.addEventListener('click', function(e) {
            var panel = self._panelEl;
            if (!panel || panel.style.display === 'none') return;

            var isPanelClick = panel.contains(e.target);
            var isDayClick = e.target.closest('.calendar-day');

            if (!isPanelClick && !isDayClick) {
                self.hideArticlesPanel();
            }
        });
    }
};
