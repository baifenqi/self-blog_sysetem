/**
 * 用户导航模块
 * 负责按钮跳转、用户操作等
 */

const NavigationModule = {
    init() {
        this.bindEvents();
    },

    bindEvents() {
        // 写博客按钮
        document.querySelectorAll('[data-action="write"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToWrite());
        });

        // 草稿箱按钮
        document.querySelectorAll('[data-action="drafts"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToDrafts());
        });

        // 统计按钮
        document.querySelectorAll('[data-action="stats"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToStats());
        });
    },

    goToWrite() {
        window.location.href = '/article/write';
    },

    goToDrafts() {
        window.location.href = '/article/drafts';
    },

    goToStats() {
        window.location.href = '/stats';
    },

    goToLogin() {
        window.location.href = '/login';
    },

    goToRegister() {
        window.location.href = '/register';
    }
};

document.addEventListener('DOMContentLoaded', () => {
    NavigationModule.init();
});

// 保留全局函数供内联调用
function goToWrite() { NavigationModule.goToWrite(); }
function goToDrafts() { NavigationModule.goToDrafts(); }
function goToStats() { NavigationModule.goToStats(); }
function prevMusic() { MusicModule.prev(); }
function nextMusic() { MusicModule.next(); }
