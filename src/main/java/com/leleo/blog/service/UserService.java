package com.leleo.blog.service;

import com.leleo.blog.entity.User;

import java.util.List;

/**
 * 用户服务接口
 */
public interface UserService {

    User selectById(Long id);

    User selectByUsername(String username);

    User login(String username, String password);

    Long insert(User user);

    boolean update(User user);

    boolean deleteById(Long id);

    boolean updatePassword(Long id, String oldPassword, String newPassword);

    List<User> selectByRole(String role);
}