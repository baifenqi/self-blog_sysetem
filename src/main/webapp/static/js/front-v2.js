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

        var allLoaded = modules.every(function(m) {
            return typeof m !== 'undefined' && m !== null;
        });

        if (allLoaded) {
            console.log('All modules loaded successfully');
        } else {
            console.warn('Some modules failed to load');
        }
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initModules);
    } else {
        initModules();
    }
})();