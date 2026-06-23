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

import java.util.List;

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
    public PageResult<Article> selectPage(String keyword, Long categoryId, Long tagId, Integer pageNum, Integer pageSize) {
        if (pageNum == null) pageNum = 1;
        if (pageSize == null) pageSize = Constants.DEFAULT_PAGE_SIZE;

        PageHelper.startPage(pageNum, pageSize);
        List<Article> list = articleMapper.selectPage(keyword, categoryId, tagId);
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
}