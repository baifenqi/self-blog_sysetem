package com.leleo.blog.exception;

import com.leleo.blog.common.Result;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * 全局异常处理器
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 处理业务异常
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public Result<Object> handleBusinessException(BusinessException e, HttpServletRequest request) {
        return Result.error(e.getCode(), e.getMessage());
    }

    /**
     * 处理运行时异常
     */
    @ExceptionHandler(RuntimeException.class)
    @ResponseBody
    public Result<Object> handleRuntimeException(RuntimeException e, HttpServletRequest request) {
        e.printStackTrace();
        return Result.error("系统繁忙，请稍后重试");
    }

    /**
     * 处理所有未捕获的异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public Result<Object> handleException(Exception e, HttpServletRequest request) {
        e.printStackTrace();
        return Result.error("系统繁忙，请稍后重试");
    }

    /**
     * 处理404错误
     */
    @ExceptionHandler(org.springframework.web.servlet.NoHandlerFoundException.class)
    public String handleNoHandlerFoundException(NoHandlerFoundException e, HttpServletRequest request, HttpServletResponse response) {
        return "redirect:/error/404";
    }
}

class NoHandlerFoundException extends Exception {
    public NoHandlerFoundException(String message) {
        super(message);
    }
}