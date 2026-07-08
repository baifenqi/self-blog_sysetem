package com.leleo.blog.service;

import com.leleo.blog.entity.Tag;
import java.util.List;
import java.util.Map;

/**
 * 标签服务接口
 */
public interface TagService {
    Tag selectById(Long id);
    List<Tag> selectAll();
    List<Tag> selectAllWithCount();
    List<Tag> selectByArticleId(Long articleId);
    List<Tag> selectHotTags(int limit);
    List<Map<String, Object>> selectTagStatistics();
    Long insert(Tag tag);
    boolean update(Tag tag);
    boolean deleteById(Long id);
}