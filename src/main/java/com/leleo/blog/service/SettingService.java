package com.leleo.blog.service;

import com.leleo.blog.entity.Setting;
import java.util.List;

/**
 * 设置服务接口
 */
public interface SettingService {
    Setting selectByKey(String key);
    String getValue(String key);
    boolean setValue(String key, String value);
    List<Setting> selectAll();
    Long insert(Setting setting);
    boolean update(Setting setting);
    boolean deleteById(Long id);
}