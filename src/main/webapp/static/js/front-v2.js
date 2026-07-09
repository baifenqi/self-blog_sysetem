/**
 * 前端JavaScript主入口
 * 聚合所有功能模块
 */

(function() {
    'use strict';

    function initModules() {
        var modules = [
            window.ClockModule,
            window.SettingsModule,
            window.BackgroundModule,
            window.CalendarModule,
            window.MusicModule,
            window.SearchModule,
            window.NavigationModule
        ];

        modules.forEach(function(m) {
            if (m && typeof m.init === 'function') {
                try {
                    m.init();
                } catch (e) {
                    console.error('Module init failed:', e);
                }
            }
        });

        console.log('All modules initialized');
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initModules);
    } else {
        initModules();
    }
})();