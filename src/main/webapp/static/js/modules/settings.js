/**
 * 设置弹窗模块
 * 负责设置面板的打开、关闭和Tab切换
 */

const SettingsModule = {
    elements: {},

    init() {
        this.cacheElements();
        this.bindEvents();
    },

    cacheElements() {
        this.elements = {
            btn: document.getElementById('settingsBtn'),
            modal: document.getElementById('settingsModal'),
            overlay: document.getElementById('modalOverlay'),
            close: document.getElementById('modalClose'),
            tabs: document.querySelectorAll('.tab'),
            sections: document.querySelectorAll('.setting-section')
        };
    },

    bindEvents() {
        const { btn, modal, overlay, close, tabs, sections } = this.elements;

        if (btn && modal && overlay) {
            btn.addEventListener('click', () => this.open());
        }

        if (close) {
            close.addEventListener('click', () => this.close());
        }

        if (overlay) {
            overlay.addEventListener('click', () => this.close());
        }

        tabs.forEach(tab => {
            tab.addEventListener('click', () => {
                tabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');

                sections.forEach(s => s.classList.remove('active'));
                const target = document.getElementById(tab.dataset.tab);
                if (target) target.classList.add('active');
            });
        });
    },

    open() {
        this.elements.modal?.classList.add('active');
        this.elements.overlay?.classList.add('active');
    },

    close() {
        this.elements.modal?.classList.remove('active');
        this.elements.overlay?.classList.remove('active');
    }
};

document.addEventListener('DOMContentLoaded', () => {
    SettingsModule.init();
});
