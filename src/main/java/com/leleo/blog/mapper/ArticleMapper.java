package com.leleo.blog.mapper;

import com.leleo.blog.entity.Article;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 文章Mapper接口
 */
public interface ArticleMapper extends BaseMapper<Article> {

    /**
     * 分页查询文章列表
     */
    List<Article> selectPage(@Param("keyword") String keyword,
                            @Param("categoryId") Long categoryId,
                            @Param("tagId") Long tagId);

    /**
     * 根据slug查询文章
     */
    Article selectBySlug(@Param("slug") String slug);

    /**
     * 更新浏览量
     */
    int updateViewCount(@Param("id") Long id);

    /**
     * 更新评论数
     */
    int updateCommentCount(@Param("id") Long id);

    /**
     * 更新点赞数
     */
    int updateLikeCount(@Param("id") Long id);

    /**
     * 获取热门文章
     */
    List<Article> selectHotArticles(@Param("limit") int limit);

    /**
     * 获取最新文章
     */
    List<Article> selectLatestArticles(@Param("limit") int limit);

    /**
     * 获取置顶文章
     */
    List<Article> selectTopArticles();

    /**
     * 获取文章统计信息
     */
    java.util.Map<String, Object> selectStatistics();
}