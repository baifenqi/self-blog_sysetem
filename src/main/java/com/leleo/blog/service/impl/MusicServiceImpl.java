package com.leleo.blog.service.impl;

import com.leleo.blog.common.Constants;
import com.leleo.blog.mapper.MusicMapper;
import com.leleo.blog.service.MusicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.leleo.blog.entity.Music;
import java.util.List;

/**
 * 音乐服务实现类
 */
@Service
public class MusicServiceImpl implements MusicService {

    @Autowired
    private MusicMapper musicMapper;

    @Override
    public Music selectById(Long id) {
        return musicMapper.selectById(id);
    }

    @Override
    public List<Music> selectAll() {
        return musicMapper.selectAllOrderBySort();
    }

    @Override
    public List<Music> selectEnabledList() {
        return musicMapper.selectEnabledList();
    }

    @Override
    public Long insert(Music music) {
        if (music.getSort() == null) music.setSort(0);
        if (music.getStatus() == null) music.setStatus(Constants.STATUS_ENABLED);
        musicMapper.insert(music);
        return music.getId();
    }

    @Override
    public boolean update(Music music) {
        return musicMapper.update(music) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return musicMapper.deleteById(id) > 0;
    }

    @Override
    public List<Music> selectByUrl(String url) {
        return musicMapper.selectByUrl(url);
    }

    @Override
    public int selectCount() {
        return musicMapper.selectCount();
    }
}