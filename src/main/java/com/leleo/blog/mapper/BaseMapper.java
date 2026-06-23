package com.leleo.blog.mapper;

import com.leleo.blog.entity.BaseEntity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 通用Mapper接口
 */
public interface BaseMapper<T extends BaseEntity> {

    /**
     * 根据ID查询
     */
    T selectById(@Param("id") Long id);

    /**
     * 查询所有
     */
    List<T> selectAll();

    /**
     * 插入数据
     */
    int insert(T entity);

    /**
     * 更新数据
     */
    int update(T entity);

    /**
     * 删除数据（逻辑删除）
     */
    int deleteById(@Param("id") Long id);

    /**
     * 根据ID物理删除
     */
    int physicalDeleteById(@Param("id") Long id);

    /**
     * 批量插入
     */
    int batchInsert(@Param("list") List<T> list);

    /**
     * 批量更新
     */
    int batchUpdate(@Param("list") List<T> list);

    /**
     * 批量删除
     */
    int batchDelete(@Param("ids") List<Long> ids);
}