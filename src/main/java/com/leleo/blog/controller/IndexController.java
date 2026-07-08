package com.leleo.blog.controller;

import com.leleo.blog.common.Result;
import com.leleo.blog.entity.*;
import com.leleo.blog.service.*;
import com.leleo.blog.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
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
    private UserMapper userMapper;

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
        List<Music> musicList = musicService.selectEnabledList();

        model.addAttribute("category", category);
        model.addAttribute("articles", articles);
        model.addAttribute("categories", categories);
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        model.addAttribute("siteDescription", settingService.getValue("site_description"));

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
        List<Music> musicList = musicService.selectEnabledList();

        model.addAttribute("tag", tag);
        model.addAttribute("articles", articles);
        model.addAttribute("tags", tags);
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        model.addAttribute("siteDescription", settingService.getValue("site_description"));

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
     * 获取背景文件列表API
     * 扫描内置背景目录和上传背景目录，返回所有可用的背景文件
     */
    @GetMapping("/api/setting/background/list")
    @ResponseBody
    public Result<List<Map<String, String>>> getBackgroundList() {
        List<Map<String, String>> list = new ArrayList<>();

        // 扫描内置背景目录
        String builtinPath = System.getProperty("user.dir") + "/src/main/webapp/static/images/backgrounds/";
        File builtinDir = new File(builtinPath);
        if (builtinDir.exists() && builtinDir.isDirectory()) {
            scanBackgroundDir(builtinDir, "/static/images/backgrounds/", "builtin", list);
        }

        // 扫描上传背景目录
        String uploadPath = System.getProperty("user.dir") + "/upload/backgrounds/";
        File uploadDir = new File(uploadPath);
        if (uploadDir.exists() && uploadDir.isDirectory()) {
            scanBackgroundDir(uploadDir, "/upload/backgrounds/", "upload", list);
        }

        return Result.success(list);
    }

    /**
     * 扫描背景目录，收集图片和视频文件
     */
    private void scanBackgroundDir(File dir, String urlPrefix, String source, List<Map<String, String>> list) {
        File[] files = dir.listFiles();
        if (files == null) return;

        for (File file : files) {
            if (file.isFile()) {
                String name = file.getName().toLowerCase();
                String type = null;
                if (name.endsWith(".jpg") || name.endsWith(".jpeg") || name.endsWith(".png")
                        || name.endsWith(".gif") || name.endsWith(".webp") || name.endsWith(".bmp")) {
                    type = "image";
                } else if (name.endsWith(".mp4") || name.endsWith(".webm") || name.endsWith(".mov")) {
                    type = "video";
                }
                if (type != null) {
                    Map<String, String> item = new HashMap<>();
                    item.put("name", file.getName());
                    item.put("url", urlPrefix + file.getName());
                    item.put("type", type);
                    item.put("source", source);
                    list.add(item);
                }
            }
        }
    }

    /**
     * 保存网站背景设置API
     */
    @PostMapping("/api/setting/background")
    @ResponseBody
    public Result<String> saveBackground(@RequestBody Map<String, String> data) {
        String background = data.get("background");
        if (background == null) {
            background = "default";
        }

        settingService.setValue("background_image", background);
        return Result.success(background);
    }

    /**
     * 上传背景图片/视频API
     */
    @PostMapping("/api/setting/background/upload")
    @ResponseBody
    public Result<String> uploadBackground(@RequestParam("file") MultipartFile file, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.unauthorized();
        }
        try {
            // 检查文件类型（支持图片和视频）
            String contentType = file.getContentType();
            if (contentType == null || (!contentType.startsWith("image/") && !contentType.startsWith("video/"))) {
                return Result.error("请上传图片或视频文件");
            }

            // 检查文件大小（最大 20MB）
            if (file.getSize() > 20 * 1024 * 1024) {
                return Result.error("文件大小不能超过 20MB");
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

    /**
     * 用户资料页面
     */
    @GetMapping("/user/profile")
    public String profile(HttpSession session) {
        return "front/profile";
    }

    /**
     * 账号安全页面
     */
    @GetMapping("/user/security")
    public String security(HttpSession session) {
        return "front/security";
    }

    /**
     * 更新用户昵称API
     */
    @PostMapping("/api/user/profile/nickname")
    @ResponseBody
    public Result<String> updateNickname(@RequestBody Map<String, String> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = new User();
        }

        String nickname = data.get("nickname");
        if (nickname == null || nickname.trim().isEmpty()) {
            return Result.error("昵称不能为空");
        }

        user.setNickname(nickname.trim());
        if (user.getId() != null) {
            userService.update(user);
        }
        session.setAttribute("user", user);

        return Result.success(nickname);
    }

    /**
     * 更新用户签名API
     */
    @PostMapping("/api/user/profile/signature")
    @ResponseBody
    public Result<String> updateSignature(@RequestBody Map<String, String> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = new User();
        }

        String signature = data.get("signature");
        user.setSignature(signature != null ? signature.trim() : null);
        if (user.getId() != null) {
            userService.update(user);
        }
        session.setAttribute("user", user);

        return Result.success(signature);
    }

    /**
     * 上传用户头像API
     */
    @PostMapping("/api/user/profile/avatar")
    @ResponseBody
    public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            user = new User();
        }

        try {
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.error("请上传图片文件");
            }

            if (file.getSize() > 5 * 1024 * 1024) {
                return Result.error("图片大小不能超过 5MB");
            }

            String uploadPath = System.getProperty("user.dir") + "/upload/avatars/";
            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".png";
            String filename = "avatar_" + (user.getId() != null ? user.getId() : "guest") + "_" + System.currentTimeMillis() + extension;

            File destFile = new File(uploadPath + filename);
            file.transferTo(destFile);

            String avatarUrl = "/upload/avatars/" + filename;
            user.setAvatar(avatarUrl);
            if (user.getId() != null) {
                userService.update(user);
            }
            session.setAttribute("user", user);

            return Result.success(avatarUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("上传失败: " + e.getMessage());
        }
    }

    /**
     * 修改密码API
     */
    @PostMapping("/api/user/profile/password")
    @ResponseBody
    public Result<String> changePassword(@RequestBody Map<String, String> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getId() == null) {
            return Result.error("请先登录");
        }

        String newPassword = data.get("newPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("请输入新密码");
        }
        if (newPassword.length() < 6) {
            return Result.error("新密码长度不能少于6位");
        }

        User dbUser = userService.selectById(user.getId());
        if (dbUser == null) {
            return Result.error("用户不存在");
        }

        if (dbUser.getPassword().equals(newPassword)) {
            return Result.error("新密码不能与旧密码相同");
        }

        user.setPassword(newPassword);
        userService.update(user);
        session.setAttribute("user", user);

        return Result.success("密码修改成功");
    }

    /**
     * 修改账号API
     */
    @PostMapping("/api/user/profile/username")
    @ResponseBody
    public Result<String> changeUsername(@RequestBody Map<String, String> data, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getId() == null) {
            return Result.error("请先登录");
        }

        String newUsername = data.get("newUsername");

        if (newUsername == null || newUsername.trim().isEmpty()) {
            return Result.error("请输入新账号");
        }
        if (newUsername.length() < 3) {
            return Result.error("新账号长度不能少于3位");
        }

        User dbUser = userService.selectById(user.getId());
        if (dbUser == null) {
            return Result.error("用户不存在");
        }

        User existingUser = userMapper.selectByUsername(newUsername);
        if (existingUser != null && !existingUser.getId().equals(user.getId())) {
            return Result.error("该账号已被使用");
        }

        user.setUsername(newUsername);
        userService.update(user);
        session.setAttribute("user", user);

        return Result.success("账号修改成功");
    }
}