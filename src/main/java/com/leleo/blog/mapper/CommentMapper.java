package com.leleo.blog.mapper;

import com.leleo.blog.entity.Comment;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 评论Mapper接口
 */
public interface CommentMapper extends BaseMapper<Comment> {

    /**
     * 根据文章ID查询评论列表
     */
    List<Comment> selectByArticleId(@Param("articleId") Long articleId);

    /**
     * 查询顶级评论（无父评论）
     */
    List<Comment> selectTopLevelComments(@Param("articleId") Long articleId);

    /**
     * 根据父ID查询子评论
     */
    List<Comment> selectByParentId(@Param("parentId") Long parentId);

    /**
     * 获取评论统计
     */
    java.util.Map<String, Object> selectStatistics();

    /**
     * 获取最近评论
     */
    List<Comment> selectRecentComments(@Param("limit") int limit);

    /**
     * 获取用户的评论列表
     */
    List<Comment> selectByUserId(@Param("userId") Long userId);
}