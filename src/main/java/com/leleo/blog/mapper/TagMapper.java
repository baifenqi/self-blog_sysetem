package com.leleo.blog.mapper;

import com.leleo.blog.entity.Tag;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 标签Mapper接口
 */
public interface TagMapper extends BaseMapper<Tag> {

    /**
     * 获取所有标签（带文章数量）
     */
    List<Tag> selectAllWithCount();

    /**
     * 获取标签列表（分页）
     */
    List<Tag> selectPage(@Param("name") String name);

    /**
     * 根据文章ID查询标签
     */
    List<Tag> selectByArticleId(@Param("articleId") Long articleId);

    /**
     * 为文章添加标签
     */
    int addTagToArticle(@Param("articleId") Long articleId, @Param("tagId") Long tagId);

    /**
     * 删除文章的所有标签
     */
    int deleteArticleTags(@Param("articleId") Long articleId);

    /**
     * 获取热门标签
     */
    List<Tag> selectHotTags(@Param("limit") int limit);

    /**
     * 获取标签统计数据（用于饼图）
     */
    List<java.util.Map<String, Object>> selectTagStatistics();
}