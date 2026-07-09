package com.leleo.blog.controller;

import com.leleo.blog.common.Constants;
import com.leleo.blog.common.Result;
import com.leleo.blog.common.PageResult;
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

        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);

        model.addAttribute("article", article);
        model.addAttribute("comments", comments);
        model.addAttribute("category", category);
        model.addAttribute("siteName", settingService.getValue("site_name"));

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

        List<Article> articles = articleService.selectPage(null, category.getId(), null, null, Constants.ARTICLE_STATUS_PUBLISHED, 1, 12).getList();
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

        List<Article> articles = articleService.selectPage(null, null, id, null, Constants.ARTICLE_STATUS_PUBLISHED, 1, 12).getList();
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
     * AJAX获取文章列表（支持分类和标签筛选）
     */
    @GetMapping("/api/articles")
    @ResponseBody
    public Result<PageResult<Article>> apiArticles(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Long tagId,
            @RequestParam(required = false) String date,
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "12") Integer pageSize) {
        PageResult<Article> result = articleService.selectPage(keyword, categoryId, tagId, date, Constants.ARTICLE_STATUS_PUBLISHED, pageNum, pageSize);
        return Result.success(result);
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
        articleService.updateCommentCount(comment.getArticleId());

        return Result.success(id);
    }

    /**
     * 用户资料页面
     */
    @GetMapping("/user/profile")
    public String profile(Model model) {
        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        return "front/profile";
    }

    /**
     * 写文章页面
     */
    @GetMapping("/write")
    public String writePage(@RequestParam(required = false) Long edit, Model model, HttpSession session) {
        model.addAttribute("categories", categoryService.selectAll());
        model.addAttribute("tags", tagService.selectAll());

        // 如果是编辑模式，加载文章数据
        if (edit != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && user.getId() != null) {
                Article article = articleService.selectById(edit);
                if (article != null && article.getUserId().equals(user.getId())) {
                    model.addAttribute("article", article);
                }
            }
        }

        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        return "front/write";
    }

    /**
     * 保存文章API（前台写文章）
     */
    @PostMapping("/article/write/save")
    @ResponseBody
    public Result<Long> saveArticle(@RequestBody Article article,
                                    @RequestParam(required = false) Integer status,
                                    HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.unauthorized();
        }

        article.setUserId(user.getId());

        // 设置状态，默认为已发布
        if (status == null) {
            status = Constants.ARTICLE_STATUS_PUBLISHED;
        }
        article.setStatus(status);

        if (article.getId() == null) {
            Long id = articleService.insert(article, article.getTagIds());
            return Result.success(id);
        } else {
            // 验证是否是自己的文章
            Article existArticle = articleService.selectById(article.getId());
            if (existArticle == null || !existArticle.getUserId().equals(user.getId())) {
                return Result.error("无权编辑该文章");
            }
            articleService.update(article, article.getTagIds());
            return Result.success(article.getId());
        }
    }

    /**
     * 账号安全页面
     */
    @GetMapping("/user/security")
    public String security(Model model) {
        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
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
        if (user == null || user.getId() == null) {
            return Result.unauthorized();
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
            String filename = "avatar_" + user.getId() + "_" + System.currentTimeMillis() + extension;

            File destFile = new File(uploadPath + filename);
            file.transferTo(destFile);

            String avatarUrl = "/upload/avatars/" + filename;
            user.setAvatar(avatarUrl);
            userService.update(user);
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

        String oldPassword = data.get("oldPassword");
        String newPassword = data.get("newPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty()) {
            return Result.error("请输入旧密码");
        }
        if (newPassword == null || newPassword.trim().isEmpty()) {
            return Result.error("请输入新密码");
        }
        if (newPassword.length() < 6) {
            return Result.error("新密码长度不能少于6位");
        }

        boolean success = userService.updatePassword(user.getId(), oldPassword, newPassword);
        if (!success) {
            return Result.error("旧密码错误");
        }

        // 更新session中的用户信息（清除密码）
        User updatedUser = userService.selectById(user.getId());
        updatedUser.setPassword(null);
        session.setAttribute("user", updatedUser);

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
        String currentPassword = data.get("currentPassword");

        if (newUsername == null || newUsername.trim().isEmpty()) {
            return Result.error("请输入新账号");
        }
        if (newUsername.length() < 3) {
            return Result.error("新账号长度不能少于3位");
        }
        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            return Result.error("请输入当前密码");
        }

        User dbUser = userService.selectById(user.getId());
        if (dbUser == null) {
            return Result.error("用户不存在");
        }

        // 验证当前密码
        if (!userService.verifyPassword(user.getId(), currentPassword)) {
            return Result.error("当前密码错误");
        }

        User existingUser = userMapper.selectByUsername(newUsername);
        if (existingUser != null && !existingUser.getId().equals(user.getId())) {
            return Result.error("该账号已被使用");
        }

        user.setUsername(newUsername);
        userService.update(user);
        // 更新session（清除密码）
        User updatedUser = userService.selectById(user.getId());
        updatedUser.setPassword(null);
        session.setAttribute("user", updatedUser);

        return Result.success("账号修改成功");
    }

    /**
     * 草稿箱页面
     */
    @GetMapping("/drafts")
    public String draftsPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user != null && user.getId() != null) {
            List<Article> drafts = articleService.selectPageByUser(
                    user.getId(),
                    Constants.ARTICLE_STATUS_DRAFT,
                    1,
                    100
            ).getList();
            model.addAttribute("drafts", drafts);
        }
        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        return "front/drafts";
    }

    /**
     * 删除草稿API
     */
    @PostMapping("/article/draft/delete")
    @ResponseBody
    public Result<Boolean> deleteDraft(@RequestParam Long id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || user.getId() == null) {
            return Result.unauthorized();
        }

        Article article = articleService.selectById(id);
        if (article == null || !article.getUserId().equals(user.getId())) {
            return Result.error("无权删除该文章");
        }

        return Result.success(articleService.deleteById(id));
    }

    /**
     * 统计页面
     */
    @GetMapping("/stats")
    public String statsPage(Model model) {
        List<Article> allArticles = articleService.selectAll();
        List<Category> allCategories = categoryService.selectAllWithCount();
        List<Tag> allTags = tagService.selectAllWithCount();
        List<Comment> recentComments = commentService.selectRecentComments(1000);

        model.addAttribute("articleCount", allArticles.size());
        model.addAttribute("categoryCount", allCategories.size());
        model.addAttribute("tagCount", allTags.size());
        model.addAttribute("commentCount", recentComments.size());

        // 总浏览量
        int totalViews = 0;
        int totalLikes = 0;
        for (Article a : allArticles) {
            totalViews += (a.getViewCount() != null ? a.getViewCount() : 0);
            totalLikes += (a.getLikeCount() != null ? a.getLikeCount() : 0);
        }
        model.addAttribute("totalViews", totalViews);
        model.addAttribute("totalLikes", totalLikes);

        // 分类统计（带文章数）
        model.addAttribute("categoryStats", allCategories);

        // 标签统计（带文章数）
        model.addAttribute("tagStats", allTags);

        // 热门文章 TOP5（按浏览量排序）
        List<Article> topArticles = new ArrayList<>(allArticles);
        topArticles.sort((a, b) -> {
            int va = a.getViewCount() != null ? a.getViewCount() : 0;
            int vb = b.getViewCount() != null ? b.getViewCount() : 0;
            return Integer.compare(vb, va);
        });
        model.addAttribute("topArticles", topArticles.size() > 5 ? topArticles.subList(0, 5) : topArticles);

        // 最近评论
        model.addAttribute("recentComments", recentComments.size() > 10 ? recentComments.subList(0, 10) : recentComments);

        // 获取音乐列表
        List<Music> musicList = musicService.selectEnabledList();
        model.addAttribute("musicList", musicList);
        model.addAttribute("siteName", settingService.getValue("site_name"));
        return "front/stats";
    }

    /**
     * 按月份统计每日文章数量
     */
    @GetMapping("/api/calendar/count")
    @ResponseBody
    public Result<List<Map<String, Object>>> getCalendarCount(
            @RequestParam Integer year,
            @RequestParam Integer month) {
        List<Map<String, Object>> list = articleService.getArticleCountByMonth(year, month);
        return Result.success(list);
    }

    /**
     * 按日期查询文章列表
     */
    @GetMapping("/api/calendar/articles")
    @ResponseBody
    public Result<List<Article>> getCalendarArticles(
            @RequestParam String date) {
        List<Article> list = articleService.getArticlesByDate(date);
        return Result.success(list);
    }
}