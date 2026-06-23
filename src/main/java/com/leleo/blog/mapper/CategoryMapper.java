package com.leleo.blog.mapper;

import com.leleo.blog.entity.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 分类Mapper接口
 */
public interface CategoryMapper extends BaseMapper<Category> {

    /**
     * 根据slug查询
     */
    Category selectBySlug(@Param("slug") String slug);

    /**
     * 获取所有分类（带文章数量）
     */
    List<Category> selectAllWithCount();

    /**
     * 获取分类列表（分页）
     */
    List<Category> selectPage(@Param("name") String name);

    /**
     * 更新排序
     */
    int updateSort(@Param("id") Long id, @Param("sort") Integer sort);
}