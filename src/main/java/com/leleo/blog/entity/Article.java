package com.leleo.blog.entity;

import java.util.List;

/**
 * 文章实体类
 */
public class Article extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 文章标题
     */
    private String title;

    /**
     * 文章别名
     */
    private String slug;

    /**
     * 文章摘要
     */
    private String summary;

    /**
     * 文章内容(Markdown)
     */
    private String content;

    /**
     * 封面图片
     */
    private String coverImage;

    /**
     * 分类ID
     */
    private Long categoryId;

    /**
     * 作者ID
     */
    private Long userId;

    /**
     * 浏览量
     */
    private Integer viewCount;

    /**
     * 评论数
     */
    private Integer commentCount;

    /**
     * 点赞数
     */
    private Integer likeCount;

    /**
     * 是否置顶：0-否，1-是
     */
    private Integer isTop;

    /**
     * 是否删除：0-否，1-是
     */
    private Integer isDeleted;

    /**
     * 分类名称（关联查询）
     */
    private String categoryName;

    /**
     * 作者名称（关联查询）
     */
    private String authorName;

    /**
     * 文章标签列表（关联查询）
     */
    private List<Tag> tags;

    // Getters and Setters
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public Long getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Long categoryId) {
        this.categoryId = categoryId;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Integer getCommentCount() {
        return commentCount;
    }

    public void setCommentCount(Integer commentCount) {
        this.commentCount = commentCount;
    }

    public Integer getLikeCount() {
        return likeCount;
    }

    public void setLikeCount(Integer likeCount) {
        this.likeCount = likeCount;
    }

    public Integer getIsTop() {
        return isTop;
    }

    public void setIsTop(Integer isTop) {
        this.isTop = isTop;
    }

    public Integer getIsDeleted() {
        return isDeleted;
    }

    public void setIsDeleted(Integer isDeleted) {
        this.isDeleted = isDeleted;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public List<Tag> getTags() {
        return tags;
    }

    public void setTags(List<Tag> tags) {
        this.tags = tags;
    }
}