package com.leleo.blog.service;

import com.leleo.blog.common.PageResult;
import com.leleo.blog.entity.Article;

import java.util.List;

/**
 * 文章服务接口
 */
public interface ArticleService {

    /**
     * 分页查询文章列表
     */
    PageResult<Article> selectPage(String keyword, Long categoryId, Long tagId, Integer pageNum, Integer pageSize);

    /**
     * 根据ID查询文章
     */
    Article selectById(Long id);

    /**
     * 根据slug查询文章
     */
    Article selectBySlug(String slug);

    /**
     * 创建文章
     */
    Long insert(Article article, Long[] tagIds);

    /**
     * 更新文章
     */
    boolean update(Article article, Long[] tagIds);

    /**
     * 删除文章（逻辑删除）
     */
    boolean deleteById(Long id);

    /**
     * 更新浏览量
     */
    boolean updateViewCount(Long id);

    /**
     * 更新点赞数
     */
    boolean updateLikeCount(Long id);

    /**
     * 获取热门文章
     */
    List<Article> selectHotArticles(int limit);

    /**
     * 获取最新文章
     */
    List<Article> selectLatestArticles(int limit);

    /**
     * 获取置顶文章
     */
    List<Article> selectTopArticles();

    /**
     * 获取文章统计信息
     */
    Object selectStatistics();

    /**
     * 获取所有文章列表
     */
    List<Article> selectAll();
}