package com.leleo.blog.service.impl;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.leleo.blog.common.Constants;
import com.leleo.blog.common.PageResult;
import com.leleo.blog.entity.Article;
import com.leleo.blog.entity.Tag;
import com.leleo.blog.mapper.ArticleMapper;
import com.leleo.blog.mapper.TagMapper;
import com.leleo.blog.service.ArticleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

/**
 * 文章服务实现类
 */
@Service
public class ArticleServiceImpl implements ArticleService {

    @Autowired
    private ArticleMapper articleMapper;

    @Autowired
    private TagMapper tagMapper;

    @Override
    public PageResult<Article> selectPage(String keyword, Long categoryId, Long tagId, String date, Integer status, Integer pageNum, Integer pageSize) {
        if (pageNum == null) pageNum = 1;
        if (pageSize == null) pageSize = Constants.DEFAULT_PAGE_SIZE;

        PageHelper.startPage(pageNum, pageSize);
        List<Article> list = articleMapper.selectPage(keyword, categoryId, tagId, date, status, null);
        PageInfo<Article> pageInfo = new PageInfo<>(list);

        // 查询每个文章的标签
        for (Article article : list) {
            List<Tag> tags = tagMapper.selectByArticleId(article.getId());
            article.setTags(tags);
        }

        return PageResult.build(pageInfo.getTotal(), pageNum, pageSize, list);
    }

    @Override
    public PageResult<Article> selectPageByUser(Long userId, Integer status, Integer pageNum, Integer pageSize) {
        if (pageNum == null) pageNum = 1;
        if (pageSize == null) pageSize = Constants.DEFAULT_PAGE_SIZE;

        PageHelper.startPage(pageNum, pageSize);
        List<Article> list = articleMapper.selectPage(null, null, null, null, status, userId);
        PageInfo<Article> pageInfo = new PageInfo<>(list);

        // 查询每个文章的标签
        for (Article article : list) {
            List<Tag> tags = tagMapper.selectByArticleId(article.getId());
            article.setTags(tags);
        }

        return PageResult.build(pageInfo.getTotal(), pageNum, pageSize, list);
    }

    @Override
    public Article selectById(Long id) {
        Article article = articleMapper.selectById(id);
        if (article != null) {
            List<Tag> tags = tagMapper.selectByArticleId(id);
            article.setTags(tags);
        }
        return article;
    }

    @Override
    public Article selectBySlug(String slug) {
        Article article = articleMapper.selectBySlug(slug);
        if (article != null) {
            List<Tag> tags = tagMapper.selectByArticleId(article.getId());
            article.setTags(tags);
        }
        return article;
    }

    @Override
    @Transactional
    public Long insert(Article article, Long[] tagIds) {
        if (article.getViewCount() == null) article.setViewCount(0);
        if (article.getCommentCount() == null) article.setCommentCount(0);
        if (article.getLikeCount() == null) article.setLikeCount(0);
        if (article.getIsTop() == null) article.setIsTop(0);
        if (article.getIsDeleted() == null) article.setIsDeleted(0);
        if (article.getStatus() == null) article.setStatus(Constants.ARTICLE_STATUS_PUBLISHED);

        articleMapper.insert(article);

        // 保存文章标签关联
        if (tagIds != null && tagIds.length > 0) {
            for (Long tagId : tagIds) {
                tagMapper.addTagToArticle(article.getId(), tagId);
            }
        }

        return article.getId();
    }

    @Override
    @Transactional
    public boolean update(Article article, Long[] tagIds) {
        articleMapper.update(article);

        // 更新文章标签关联
        tagMapper.deleteArticleTags(article.getId());
        if (tagIds != null && tagIds.length > 0) {
            for (Long tagId : tagIds) {
                tagMapper.addTagToArticle(article.getId(), tagId);
            }
        }

        return true;
    }

    @Override
    public boolean deleteById(Long id) {
        return articleMapper.deleteById(id) > 0;
    }

    @Override
    public boolean updateViewCount(Long id) {
        return articleMapper.updateViewCount(id) > 0;
    }

    @Override
    public boolean updateCommentCount(Long id) {
        return articleMapper.updateCommentCount(id) > 0;
    }

    @Override
    public boolean updateLikeCount(Long id) {
        return articleMapper.updateLikeCount(id) > 0;
    }

    @Override
    public List<Article> selectHotArticles(int limit) {
        return articleMapper.selectHotArticles(limit);
    }

    @Override
    public List<Article> selectLatestArticles(int limit) {
        return articleMapper.selectLatestArticles(limit);
    }

    @Override
    public List<Article> selectTopArticles() {
        return articleMapper.selectTopArticles();
    }

    @Override
    public Object selectStatistics() {
        return articleMapper.selectStatistics();
    }

    @Override
    public List<Article> selectAll() {
        return articleMapper.selectAll();
    }

    @Override
    public List<Map<String, Object>> getArticleCountByMonth(Integer year, Integer month) {
        YearMonth yearMonth = YearMonth.of(year, month);
        LocalDate firstDay = yearMonth.atDay(1);
        LocalDate lastDay = yearMonth.atEndOfMonth();

        String startDate = firstDay.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " 00:00:00";
        String endDate = lastDay.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + " 23:59:59";

        return articleMapper.selectArticleCountByMonth(startDate, endDate);
    }

    @Override
    public List<Article> getArticlesByDate(String date) {
        List<Article> articles = articleMapper.selectByDate(date);
        // 查询每篇文章的标签
        for (Article article : articles) {
            List<Tag> tags = tagMapper.selectByArticleId(article.getId());
            article.setTags(tags);
        }
        return articles;
    }
}