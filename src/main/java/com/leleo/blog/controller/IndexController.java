package com.leleo.blog.controller;

import com.leleo.blog.common.Result;
import com.leleo.blog.entity.*;
import com.leleo.blog.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.util.List;
import java.util.Map;

/**
 * 前台首页控制器
 */
@Controller
public class IndexController {

    @Autowired
    private ArticleService articleService;

    @Autowired
    private CategoryService categoryService;

    @Autowired
    private TagService tagService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private MusicService musicService;

    @Autowired
    private SettingService settingService;

    @Autowired
    private UserService userService;

    /**
     * 首页
     */
    @GetMapping({"/", "/index"})
    public String index(Model model) {
        // 获取文章列表
        List<Article> articles = articleService.selectLatestArticles(20);
        model.addAttribute("articles", articles);

        // 获取分类列表
        List<Category> categories = categoryService.selectAllWithCount();
        model.addAttribute("categories", categories);

        // 获取标签列表
        List<Tag> tags = tagService.selectAllWithCount();
        model.addAttribute("tags", tags);

        // 获取标签统计（饼图数据）
        List<Map<String, Object>> tagStatistics = tagService.selectTagStatistics();
        model.addAttribute("tagStatistics", tagStatistics);

        // 获取文章统计
        Map<String, Object> articleStats = (Map<String, Object>) articleService.selectStatistics();
        model.addAttribute("articleStats", articleStats);

        // 获取评论统计
        Map<String, Object> commentStats = commentService.selectStatistics();
        model.addAttribute("commentStats", commentStats);

        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);

        // 获取网站设置
        model.addAttribute("siteName", settingService.getValue("site_name"));
        model.addAttribute("siteDescription", settingService.getValue("site_description"));

        return "front/index";
    }

    /**
     * 文章详情页
     */
    @GetMapping("/article/{slug}")
    public String articleDetail(@PathVariable String slug, Model model) {
        Article article = articleService.selectBySlug(slug);
        if (article == null) {
            return "redirect:/";
        }

        // 更新浏览量
        articleService.updateViewCount(article.getId());
        article.setViewCount(article.getViewCount() + 1);

        // 获取评论
        List<Comment> comments = commentService.selectByArticleId(article.getId());

        // 获取分类
        Category category = categoryService.selectById(article.getCategoryId());

        model.addAttribute("article", article);
        model.addAttribute("comments", comments);
        model.addAttribute("category", category);

        return "front/article";
    }

    /**
     * 分类文章列表
     */
    @GetMapping("/category/{slug}")
    public String categoryArticles(@PathVariable String slug, Model model) {
        Category category = categoryService.selectBySlug(slug);
        if (category == null) {
            return "redirect:/";
        }

        List<Article> articles = articleService.selectPage(null, category.getId(), null, 1, 12).getList();
        List<Category> categories = categoryService.selectAllWithCount();

        model.addAttribute("category", category);
        model.addAttribute("articles", articles);
        model.addAttribute("categories", categories);

        return "front/index";
    }

    /**
     * 标签文章列表
     */
    @GetMapping("/tag/{id}")
    public String tagArticles(@PathVariable Long id, Model model) {
        Tag tag = tagService.selectById(id);
        if (tag == null) {
            return "redirect:/";
        }

        List<Article> articles = articleService.selectPage(null, null, id, 1, 12).getList();
        List<Tag> tags = tagService.selectAllWithCount();

        model.addAttribute("tag", tag);
        model.addAttribute("articles", articles);
        model.addAttribute("tags", tags);

        return "front/index";
    }

    /**
     * 登录页
     */
    @GetMapping("/login")
    public String loginPage() {
        return "front/login";
    }

    /**
     * 登录处理
     */
    @PostMapping("/login")
    @ResponseBody
    public Result<User> login(@RequestParam String username,
                              @RequestParam String password,
                              HttpSession session) {
        User user = userService.login(username, password);
        if (user != null) {
            session.setAttribute("user", user);
            return Result.success(user);
        }
        return Result.error("用户名或密码错误");
    }

    /**
     * 注册页
     */
    @GetMapping("/register")
    public String registerPage() {
        return "front/register";
    }

    /**
     * 注册处理
     */
    @PostMapping("/register")
    @ResponseBody
    public Result<Long> register(@RequestParam String username,
                                 @RequestParam String password,
                                 @RequestParam String email) {
        // 检查用户名是否已存在
        if (userService.selectByUsername(username) != null) {
            return Result.error("用户名已存在");
        }

        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setEmail(email);
        user.setNickname(username);

        Long id = userService.insert(user);
        return Result.success(id);
    }

    /**
     * 登出
     */
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("user");
        return "redirect:/";
    }

    /**
     * 获取音乐列表API
     */
    @GetMapping("/api/music")
    @ResponseBody
    public Result<List<Music>> getMusicList() {
        return Result.success(musicService.selectEnabledList());
    }

    /**
     * 获取网站背景设置API
     */
    @GetMapping("/api/setting/background")
    @ResponseBody
    public Result<String> getBackground() {
        String background = settingService.getValue("background_image");
        if (background == null || background.isEmpty()) {
            background = "default";
        }
        return Result.success(background);
    }

    /**
     * 保存网站背景设置API
     */
    @PostMapping("/api/setting/background")
    @ResponseBody
    public Result<String> saveBackground(@RequestBody Map<String, String> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !"admin".equals(user.getRole())) {
            return Result.unauthorized();
        }

        String background = data.get("background");
        if (background == null) {
            background = "default";
        }

        settingService.setValue("background_image", background);
        return Result.success(background);
    }

    /**
     * 上传背景图片API
     */
    @PostMapping("/api/setting/background/upload")
    @ResponseBody
    public Result<String> uploadBackground(@RequestParam("file") MultipartFile file) {
        try {
            // 检查文件类型
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.error("请上传图片文件");
            }

            // 检查文件大小（最大 20MB）
            if (file.getSize() > 20 * 1024 * 1024) {
                return Result.error("图片大小不能超过 20MB");
            }

            // 获取上传目录
            String uploadPath = System.getProperty("user.dir") + "/upload/backgrounds/";
            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            // 生成文件名
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";
            String filename = "bg_" + System.currentTimeMillis() + extension;

            // 保存文件
            File destFile = new File(uploadPath + filename);
            file.transferTo(destFile);

            // 保存设置
            String backgroundUrl = "/upload/backgrounds/" + filename;
            settingService.setValue("background_image", backgroundUrl);

            return Result.success(backgroundUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("上传失败: " + e.getMessage());
        }
    }

    /**
     * 添加评论API
     */
    @PostMapping("/api/comment")
    @ResponseBody
    public Result<Long> addComment(@RequestBody Comment comment, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.unauthorized();
        }

        comment.setUserId(user.getId());
        Long id = commentService.insert(comment);

        // 更新文章评论数
        articleService.selectById(comment.getArticleId());
        articleService.selectById(comment.getArticleId());

        return Result.success(id);
    }
}