package com.leleo.blog.service.impl;

import com.leleo.blog.common.Constants;
import com.leleo.blog.mapper.CommentMapper;
import com.leleo.blog.service.CommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.leleo.blog.entity.Comment;
import java.util.List;
import java.util.Map;

/**
 * 评论服务实现类
 */
@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentMapper commentMapper;

    @Override
    public Comment selectById(Long id) {
        return commentMapper.selectById(id);
    }

    @Override
    public List<Comment> selectByArticleId(Long articleId) {
        List<Comment> comments = commentMapper.selectTopLevelComments(articleId);
        // 加载子评论
        for (Comment comment : comments) {
            List<Comment> children = commentMapper.selectByParentId(comment.getId());
            comment.setChildren(children);
        }
        return comments;
    }

    @Override
    public List<Comment> selectRecentComments(int limit) {
        return commentMapper.selectRecentComments(limit);
    }

    @Override
    public Map<String, Object> selectStatistics() {
        return commentMapper.selectStatistics();
    }

    @Override
    public Long insert(Comment comment) {
        if (comment.getIsDeleted() == null) comment.setIsDeleted(0);
        if (comment.getParentId() == null) comment.setParentId(0L);
        commentMapper.insert(comment);
        return comment.getId();
    }

    @Override
    public boolean update(Comment comment) {
        return commentMapper.update(comment) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return commentMapper.deleteById(id) > 0;
    }
}