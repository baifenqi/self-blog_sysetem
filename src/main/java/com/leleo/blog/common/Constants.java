package com.leleo.blog.common;

/**
 * 系统常量类
 */
public class Constants {

    /**
     * 成功状态码
     */
    public static final Integer SUCCESS_CODE = 200;

    /**
     * 失败状态码
     */
    public static final Integer ERROR_CODE = 500;

    /**
     * 未授权状态码
     */
    public static final Integer UNAUTHORIZED_CODE = 401;

    /**
     * 禁止访问状态码
     */
    public static final Integer FORBIDDEN_CODE = 403;

    /**
     * 资源不存在状态码
     */
    public static final Integer NOT_FOUND_CODE = 404;

    /**
     * 管理员角色
     */
    public static final String ROLE_ADMIN = "admin";

    /**
     * 普通用户角色
     */
    public static final String ROLE_USER = "user";

    /**
     * 启用状态
     */
    public static final Integer STATUS_ENABLED = 1;

    /**
     * 禁用状态
     */
    public static final Integer STATUS_DISABLED = 0;

    /**
     * 是
     */
    public static final Integer YES = 1;

    /**
     * 否
     */
    public static final Integer NO = 0;

    /**
     * 置顶
     */
    public static final Integer IS_TOP = 1;

    /**
     * 未置顶
     */
    public static final Integer NOT_TOP = 0;

    /**
     * 已删除
     */
    public static final Integer DELETED = 1;

    /**
     * 未删除
     */
    public static final Integer NOT_DELETED = 0;

    /**
     * Session用户键
     */
    public static final String SESSION_USER = "loginUser";

    /**
     * 默认分页大小
     */
    public static final Integer DEFAULT_PAGE_SIZE = 10;

    /**
     * 最大分页大小
     */
    public static final Integer MAX_PAGE_SIZE = 100;
}