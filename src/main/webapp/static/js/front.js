/**
 * 前端JavaScript主入口
 * 聚合所有功能模块
 */

// 按依赖顺序加载模块
(function() {
    'use strict';

    // 模块加载完成后的统一初始化
    const modules = [ClockModule, SettingsModule, BackgroundModule, CalendarModule, MusicModule, SearchModule, NavigationModule];

    // 检查所有模块是否已加载
    function checkModulesReady() {
        return modules.every(m => typeof m !== 'undefined' && m !== null);
    }

    // DOMContentLoaded 时初始化所有模块
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initModules);
    } else {
        initModules();
    }

    function initModules() {
        if (checkModulesReady()) {
            console.log('All modules loaded successfully');
        } else {
            console.warn('Some modules failed to load');
        }
    }
})();
