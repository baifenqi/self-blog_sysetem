package com.leleo.blog.interceptor;

import com.leleo.blog.common.Constants;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录拦截器
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession();
        Object user = session.getAttribute(Constants.SESSION_USER);

        if (user == null) {
            // 判断是否为AJAX请求
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"code\":401,\"message\":\"请先登录\"}");
            } else {
                response.sendRedirect("/admin/login");
            }
            return false;
        }

        return true;
    }
}