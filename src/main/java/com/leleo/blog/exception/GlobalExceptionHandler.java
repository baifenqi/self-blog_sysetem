package com.leleo.blog.exception;

import com.leleo.blog.common.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.NoHandlerFoundException;

import javax.servlet.http.HttpServletRequest;

/**
 * 全局异常处理器
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    /**
     * 处理业务异常
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public Result<Object> handleBusinessException(BusinessException e, HttpServletRequest request) {
        logger.warn("业务异常: {}", e.getMessage());
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 处理运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseBody
    public Result<Object> handleRuntimeException(RuntimeException e, HttpServletRequest request) {
        logger.error("运行时异常: ", e);
        return Result.error("系统繁忙，请稍后重试");
    }

    /**
     * 处理所有未捕获的异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Result<Object> handleException(Exception e, HttpServletRequest request) {
        logger.error("系统异常: ", e);
        return Result.error("系统繁忙，请稍后重试");
    }

    /**
     * 处理404错误
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseBody
    public Result<Object> handleNoHandlerFoundException(NoHandlerFoundException e, HttpServletRequest request) {
        logger.warn("404 Not Found: {} {}", request.getMethod(), request.getRequestURI());
        return Result.error(404, "页面不存在");
    }
}
