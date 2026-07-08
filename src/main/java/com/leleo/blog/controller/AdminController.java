package com.leleo.blog.controller;

import com.leleo.blog.common.Constants;
import com.leleo.blog.common.PageResult;
import com.leleo.blog.common.Result;
import com.leleo.blog.entity.*;
import com.leleo.blog.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

/**
 * 后台管理控制器
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private ArticleService articleService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private TagService tagService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private UserService userService;

    @Autowired
    private MusicService musicService;

    @Autowired
    private SettingService settingService;

    /**
     * 后台首页
     */
    @GetMapping("/index")
    public String adminIndex(Model model) {
        // 获取统计数据
        Map<String, Object> articleStats = (Map<String, Object>) articleService.selectStatistics();
        Map<String, Object> commentStats = commentService.selectStatistics();
        List<Article> recentArticles = articleService.selectLatestArticles(5);
        List<Comment> recentComments = commentService.selectRecentComments(5);

        model.addAttribute("articleStats", articleStats);
        model.addAttribute("commentStats", commentStats);
        model.addAttribute("recentArticles", recentArticles);
        model.addAttribute("recentComments", recentComments);

        return "admin/index";
    }

    /**
     * 管理员登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "admin/login";
    }

    /**
     * 管理员登录处理
     */
    @PostMapping("/login")
    @ResponseBody
    public Result<User> login(@RequestParam String username,
                              @RequestParam String password,
                              HttpSession session) {
        User user = userService.login(username, password);
        if (user != null && Constants.ROLE_ADMIN.equals(user.getRole())) {
            session.setAttribute(Constants.SESSION_USER, user);
            return Result.success(user);
        }
        return Result.error("用户名或密码错误，或您没有管理员权限");
    }

    /**
     * 管理员登出
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute(Constants.SESSION_USER);
        return "redirect:/admin/login";
    }

    // ==================== 文章管理 ====================

    /**
     * 文章列表页
     */
    @GetMapping("/article/list")
    public String articleList() {
        return "admin/article/list";
    }

    /**
     * 获取文章列表数据
     */
    @GetMapping("/article/data")
    @ResponseBody
    public PageResult<Article> articleData(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize) {
        return articleService.selectPage(keyword, categoryId, null, pageNum, pageSize);
    }

    /**
     * 文章编辑页
     */
    @GetMapping("/article/edit")
    public String articleEdit(@RequestParam(required = false) Long id, Model model) {
        if (id != null) {
            Article article = articleService.selectById(id);
            model.addAttribute("article", article);
        }
        model.addAttribute("categories", categoryService.selectAll());
        model.addAttribute("tags", tagService.selectAll());
        return "admin/article/edit";
    }

    /**
     * 保存文章
     */
    @PostMapping("/article/save")
    @ResponseBody
    public Result<Long> saveArticle(@RequestBody Article article,
                                    @RequestParam(required = false) Long[] tagIds,
                                    HttpSession session) {
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        if (user == null) {
            return Result.unauthorized();
        }

        if (article.getId() == null) {
            article.setUserId(user.getId());
            Long id = articleService.insert(article, tagIds);
            return Result.success(id);
        } else {
            articleService.update(article, tagIds);
            return Result.success(article.getId());
        }
    }

    /**
     * 删除文章
     */
    @PostMapping("/article/delete")
    @ResponseBody
    public Result<Boolean> deleteArticle(@RequestParam Long id) {
        return Result.success(articleService.deleteById(id));
    }

    // ==================== 分类管理 ====================

    /**
     * 分类列表
     */
    @GetMapping("/category/list")
    @ResponseBody
    public List<Category> categoryList() {
        return categoryService.selectAllWithCount();
    }

    /**
     * 保存分类
     */
    @PostMapping("/category/save")
    @ResponseBody
    public Result<Long> saveCategory(@RequestBody Category category) {
        if (category.getId() == null) {
            Long id = categoryService.insert(category);
            return Result.success(id);
        } else {
            categoryService.update(category);
            return Result.success(category.getId());
        }
    }

    /**
     * 删除分类
     */
    @PostMapping("/category/delete")
    @ResponseBody
    public Result<Boolean> deleteCategory(@RequestParam Long id) {
        return Result.success(categoryService.deleteById(id));
    }

    // ==================== 标签管理 ====================

    /**
     * 标签列表
     */
    @GetMapping("/tag/list")
    @ResponseBody
    public List<Tag> tagList() {
        return tagService.selectAllWithCount();
    }

    /**
     * 保存标签
     */
    @PostMapping("/tag/save")
    @ResponseBody
    public Result<Long> saveTag(@RequestBody Tag tag) {
        if (tag.getId() == null) {
            Long id = tagService.insert(tag);
            return Result.success(id);
        } else {
            tagService.update(tag);
            return Result.success(tag.getId());
        }
    }

    /**
     * 删除标签
     */
    @PostMapping("/tag/delete")
    @ResponseBody
    public Result<Boolean> deleteTag(@RequestParam Long id) {
        return Result.success(tagService.deleteById(id));
    }

    // ==================== 音乐管理 ====================

    /**
     * 音乐列表
     */
    @GetMapping("/music/list")
    @ResponseBody
    public List<Music> musicList() {
        return musicService.selectAll();
    }

    /**
     * 保存音乐
     */
    @PostMapping("/music/save")
    @ResponseBody
    public Result<Long> saveMusic(@RequestBody Music music) {
        if (music.getId() == null) {
            Long id = musicService.insert(music);
            return Result.success(id);
        } else {
            musicService.update(music);
            return Result.success(music.getId());
        }
    }

    /**
     * 删除音乐
     */
    @PostMapping("/music/delete")
    @ResponseBody
    public Result<Boolean> deleteMusic(@RequestParam Long id) {
        return Result.success(musicService.deleteById(id));
    }

    // ==================== 评论管理 ====================

    /**
     * 评论列表
     */
    @GetMapping("/comment/list")
    @ResponseBody
    public List<Comment> commentList() {
        return commentService.selectRecentComments(100);
    }

    /**
     * 删除评论
     */
    @PostMapping("/comment/delete")
    @ResponseBody
    public Result<Boolean> deleteComment(@RequestParam Long id) {
        return Result.success(commentService.deleteById(id));
    }

    // ==================== 用户管理 ====================

    /**
     * 用户列表
     */
    @GetMapping("/user/list")
    @ResponseBody
    public List<User> userList() {
        return userService.selectByRole(null);
    }

    /**
     * 保存用户
     */
    @PostMapping("/user/save")
    @ResponseBody
    public Result<Long> saveUser(@RequestBody User user) {
        if (user.getId() == null) {
            Long id = userService.insert(user);
            return Result.success(id);
        } else {
            userService.update(user);
            return Result.success(user.getId());
        }
    }

    /**
     * 删除用户
     */
    @PostMapping("/user/delete")
    @ResponseBody
    public Result<Boolean> deleteUser(@RequestParam Long id) {
        return Result.success(userService.deleteById(id));
    }

    /**
     * 修改密码
     */
    @PostMapping("/user/password")
    @ResponseBody
    public Result<Boolean> changePassword(@RequestParam Long id,
                                          @RequestParam String oldPassword,
                                          @RequestParam String newPassword) {
        return Result.success(userService.updatePassword(id, oldPassword, newPassword));
    }

    // ==================== 系统设置 ====================

    /**
     * 设置页面
     */
    @GetMapping("/setting")
    public String settingPage(Model model) {
        List<Setting> settings = settingService.selectAll();
        model.addAttribute("settings", settings);
        return "admin/setting";
    }

    /**
     * 保存设置
     */
    @PostMapping("/setting/save")
    @ResponseBody
    public Result<Boolean> saveSetting(@RequestBody Setting setting) {
        return Result.success(settingService.setValue(setting.getSettingKey(), setting.getSettingValue()));
    }
}