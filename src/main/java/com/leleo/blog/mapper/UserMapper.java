package com.leleo.blog.mapper;

import com.leleo.blog.entity.User;
import org.apache.ibatis.annotations.Param;

/**
 * 用户Mapper接口
 */
public interface UserMapper extends BaseMapper<User> {

    /**
     * 根据用户名查询
     */
    User selectByUsername(@Param("username") String username);

    /**
     * 登录验证
     */
    User login(@Param("username") String username, @Param("password") String password);

    /**
     * 修改密码
     */
    int updatePassword(@Param("id") Long id, @Param("password") String password);

    /**
     * 根据角色查询用户列表
     */
    java.util.List<User> selectByRole(@Param("role") String role);
}