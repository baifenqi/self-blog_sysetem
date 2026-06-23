package com.leleo.blog.service.impl;

import com.leleo.blog.mapper.CategoryMapper;
import com.leleo.blog.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.leleo.blog.entity.Category;
import java.util.List;

/**
 * 分类服务实现类
 */
@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public Category selectById(Long id) {
        return categoryMapper.selectById(id);
    }

    @Override
    public Category selectBySlug(String slug) {
        return categoryMapper.selectBySlug(slug);
    }

    @Override
    public List<Category> selectAll() {
        return categoryMapper.selectAll();
    }

    @Override
    public List<Category> selectAllWithCount() {
        return categoryMapper.selectAllWithCount();
    }

    @Override
    public List<Category> selectPage(String name, Integer pageNum, Integer pageSize) {
        return categoryMapper.selectPage(name);
    }

    @Override
    public Long insert(Category category) {
        if (category.getSort() == null) category.setSort(0);
        categoryMapper.insert(category);
        return category.getId();
    }

    @Override
    public boolean update(Category category) {
        return categoryMapper.update(category) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return categoryMapper.deleteById(id) > 0;
    }

    @Override
    public boolean updateSort(Long id, Integer sort) {
        return categoryMapper.updateSort(id, sort) > 0;
    }
}