package com.leleo.blog.service;

import com.leleo.blog.entity.Comment;
import java.util.List;
import java.util.Map;

/**
 * 评论服务接口
 */
public interface CommentService {
    Comment selectById(Long id);
    List<Comment> selectByArticleId(Long articleId);
    List<Comment> selectRecentComments(int limit);
    Map<String, Object> selectStatistics();
    Long insert(Comment comment);
    boolean update(Comment comment);
    boolean deleteById(Long id);
}