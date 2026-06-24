/**
 * 搜索模块
 * 负责处理搜索输入和导航
 */

const SearchModule = {
    init() {
        this.bindEvents();
    },

    bindEvents() {
        const searchInput = document.getElementById('searchInput');
        if (searchInput) {
            searchInput.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') this.search(searchInput);
            });
        }
    },

    search(input) {
        const keyword = input.value.trim();
        if (keyword) {
            window.location.href = `/?keyword=${encodeURIComponent(keyword)}`;
        }
    }
};

document.addEventListener('DOMContentLoaded', () => {
    SearchModule.init();
});
