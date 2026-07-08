package com.leleo.blog.service;

import com.leleo.blog.entity.Music;
import java.util.List;

/**
 * 音乐服务接口
 */
public interface MusicService {
    Music selectById(Long id);
    List<Music> selectAll();
    List<Music> selectEnabledList();
    Long insert(Music music);
    boolean update(Music music);
    boolean deleteById(Long id);
}