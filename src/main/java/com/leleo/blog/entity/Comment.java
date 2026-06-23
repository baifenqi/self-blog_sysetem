package com.leleo.blog.entity;

/**
 * 评论实体类
 */
public class Comment extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 文章ID
     */
    private Long articleId;

    /**
     * 评论用户ID
     */
    private Long userId;

    /**
     * 评论内容
     */
    private String content;

    /**
     * 父评论ID
     */
    private Long parentId;

    /**
     * 是否删除：0-否，1-是
     */
    private Integer isDeleted;

    /**
     * 评论用户名（关联查询）
     */
    private String username;

    /**
     * 评论用户头像（关联查询）
     */
    private String userAvatar;

    /**
     * 子评论列表（关联查询）
     */
    private java.util.List<Comment> children;

    public Long getArticleId() {
        return articleId;
    }

    public void setArticleId(Long articleId) {
        this.articleId = articleId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Long getParentId() {
        return parentId;
    }

    public void setParentId(Long parentId) {
        this.parentId = parentId;
    }

    public Integer getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Integer isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
    }

    public java.util.List<Comment> getChildren() {
        return children;
    }

    public void setChildren(java.util.List<Comment> children) {
        this.children = children;
    }
}