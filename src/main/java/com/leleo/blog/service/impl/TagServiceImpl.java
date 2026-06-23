package com.leleo.blog.service.impl;

import com.leleo.blog.mapper.TagMapper;
import com.leleo.blog.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.leleo.blog.entity.Tag;
import java.util.List;
import java.util.Map;

/**
 * 标签服务实现类
 */
@Service
public class TagServiceImpl implements TagService {

    @Autowired
    private TagMapper tagMapper;

    @Override
    public Tag selectById(Long id) {
        return tagMapper.selectById(id);
    }

    @Override
    public List<Tag> selectAll() {
        return tagMapper.selectAll();
    }

    @Override
    public List<Tag> selectAllWithCount() {
        return tagMapper.selectAllWithCount();
    }

    @Override
    public List<Tag> selectByArticleId(Long articleId) {
        return tagMapper.selectByArticleId(articleId);
    }

    @Override
    public List<Tag> selectHotTags(int limit) {
        return tagMapper.selectHotTags(limit);
    }

    @Override
    public List<Map<String, Object>> selectTagStatistics() {
        return tagMapper.selectTagStatistics();
    }

    @Override
    public Long insert(Tag tag) {
        if (tag.getColor() == null) tag.setColor("#00d9ff");
        tagMapper.insert(tag);
        return tag.getId();
    }

    @Override
    public boolean update(Tag tag) {
        return tagMapper.update(tag) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return tagMapper.deleteById(id) > 0;
    }
}