package com.leleo.blog.service.impl;

import com.leleo.blog.mapper.SettingMapper;
import com.leleo.blog.service.SettingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.leleo.blog.entity.Setting;
import java.util.List;

/**
 * 设置服务实现类
 */
@Service
public class SettingServiceImpl implements SettingService {

    @Autowired
    private SettingMapper settingMapper;

    @Override
    public Setting selectByKey(String key) {
        return settingMapper.selectByKey(key);
    }

    @Override
    public String getValue(String key) {
        Setting setting = settingMapper.selectByKey(key);
        return setting != null ? setting.getSettingValue() : null;
    }

    @Override
    public boolean setValue(String key, String value) {
        Setting setting = new Setting();
        setting.setSettingKey(key);
        setting.setSettingValue(value);
        return settingMapper.upsert(setting) > 0;
    }

    @Override
    public List<Setting> selectAll() {
        return settingMapper.selectAll();
    }

    @Override
    public Long insert(Setting setting) {
        settingMapper.insert(setting);
        return setting.getId();
    }

    @Override
    public boolean update(Setting setting) {
        return settingMapper.update(setting) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return settingMapper.deleteById(id) > 0;
    }
}