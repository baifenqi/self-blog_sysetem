/**
 * 用户导航模块
 * 负责按钮跳转、用户操作等
 */

var NavigationModule = {
    init() {
        this.bindEvents();
    },

    bindEvents() {
        document.querySelectorAll('[data-action="write"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToWrite());
        });

        document.querySelectorAll('[data-action="drafts"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToDrafts());
        });

        document.querySelectorAll('[data-action="stats"]').forEach(btn => {
            btn.addEventListener('click', () => this.goToStats());
        });
    },

    goToWrite() {
        window.location.href = contextPath + '/write';
    },

    goToDrafts() {
        window.location.href = contextPath + '/drafts';
    },

    goToStats() {
        window.location.href = contextPath + '/stats';
    },

    goToProfile() {
        window.location.href = contextPath + '/user/profile';
    },

    goToSecurity() {
        window.location.href = contextPath + '/user/security';
    },

    goToLogin() {
        window.location.href = contextPath + '/login';
    },

    goToRegister() {
        window.location.href = contextPath + '/register';
    }
};

document.addEventListener('DOMContentLoaded', () => {
    NavigationModule.init();
});

function goToWrite() { NavigationModule.goToWrite(); }
function goToDrafts() { NavigationModule.goToDrafts(); }
function goToStats() { NavigationModule.goToStats(); }
function prevMusic() { MusicModule.prev(); }
function nextMusic() { MusicModule.next(); }