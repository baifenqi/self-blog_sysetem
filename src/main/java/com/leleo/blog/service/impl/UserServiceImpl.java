package com.leleo.blog.service.impl;

import com.leleo.blog.common.Constants;
import com.leleo.blog.entity.User;
import com.leleo.blog.mapper.UserMapper;
import com.leleo.blog.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * 用户服务实现类
 */
@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public User selectById(Long id) {
        return userMapper.selectById(id);
    }

    @Override
    public User selectByUsername(String username) {
        return userMapper.selectByUsername(username);
    }

    @Override
    public User login(String username, String password) {
        String md5Password = md5(password);
        return userMapper.login(username, md5Password);
    }

    private String md5(String str) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("MD5");
            byte[] array = md.digest(str.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : array) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return str;
        }
    }

    @Override
    public Long insert(User user) {
        if (user.getStatus() == null) user.setStatus(Constants.STATUS_ENABLED);
        if (user.getRole() == null) user.setRole(Constants.ROLE_USER);
        userMapper.insert(user);
        return user.getId();
    }

    @Override
    public boolean update(User user) {
        return userMapper.update(user) > 0;
    }

    @Override
    public boolean deleteById(Long id) {
        return userMapper.deleteById(id) > 0;
    }

    @Override
    public boolean updatePassword(Long id, String oldPassword, String newPassword) {
        User user = userMapper.selectById(id);
        if (user != null && user.getPassword().equals(oldPassword)) {
            return userMapper.updatePassword(id, newPassword) > 0;
        }
        return false;
    }

    @Override
    public List<User> selectByRole(String role) {
        return userMapper.selectByRole(role);
    }
}