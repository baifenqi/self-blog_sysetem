package com.leleo.blog.service;

import com.leleo.blog.entity.Category;
import java.util.List;

/**
 * 分类服务接口
 */
public interface CategoryService {
    Category selectById(Long id);
    Category selectBySlug(String slug);
    List<Category> selectAll();
    List<Category> selectAllWithCount();
    List<Category> selectPage(String name, Integer pageNum, Integer pageSize);
    Long insert(Category category);
    boolean update(Category category);
    boolean deleteById(Long id);
    boolean updateSort(Long id, Integer sort);
}