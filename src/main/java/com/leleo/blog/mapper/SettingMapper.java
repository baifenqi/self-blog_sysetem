package com.leleo.blog.mapper;

import com.leleo.blog.entity.Setting;
import org.apache.ibatis.annotations.Param;

/**
 * 设置Mapper接口
 */
public interface SettingMapper extends BaseMapper<Setting> {

    /**
     * 根据key查询
     */
    Setting selectByKey(@Param("settingKey") String settingKey);

    /**
     * 更新或插入设置
     */
    int upsert(Setting setting);
}