package com.leleo.blog.entity;

/**
 * 文章分类实体类
 */
public class Category extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 分类名称
     */
    private String name;

    /**
     * 分类别名
     */
    private String slug;

    /**
     * 分类描述
     */
    private String description;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 该分类下的文章数量（关联查询）
     */
    private Integer articleCount;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getArticleCount() {
        return articleCount;
    }

    public void setArticleCount(Integer articleCount) {
        this.articleCount = articleCount;
    }
}