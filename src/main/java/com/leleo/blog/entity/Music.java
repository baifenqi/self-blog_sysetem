package com.leleo.blog.entity;

/**
 * 音乐实体类
 */
public class Music extends BaseEntity {

    private static final long serialVersionUID = 1L;

    /**
     * 音乐标题
     */
    private String title;

    /**
     * 艺术家
     */
    private String artist;

    /**
     * 音乐URL
     */
    private String url;

    /**
     * 封面URL
     */
    private String cover;

    /**
     * 歌词
     */
    private String lyrics;

    /**
     * 排序
     */
    private Integer sort;

    /**
     * 状态：0-禁用，1-启用
     */
    private Integer status;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getArtist() {
        return artist;
    }

    public void setArtist(String artist) {
        this.artist = artist;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getCover() {
        return cover;
    }

    public void setCover(String cover) {
        this.cover = cover;
    }

    public String getLyrics() {
        return lyrics;
    }

    public void setLyrics(String lyrics) {
        this.lyrics = lyrics;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }
}