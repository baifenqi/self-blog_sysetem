package com.leleo.blog.mapper;

import com.leleo.blog.entity.Music;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 音乐Mapper接口
 */
public interface MusicMapper extends BaseMapper<Music> {

    /**
     * 获取启用的音乐列表
     */
    List<Music> selectEnabledList();

    /**
     * 获取所有音乐（带排序）
     */
    List<Music> selectAllOrderBySort();
}