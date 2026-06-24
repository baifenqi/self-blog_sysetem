package com.leleo.blog.controller;

import com.leleo.blog.common.Result;
import com.leleo.blog.entity.Music;
import com.leleo.blog.service.MusicService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

/**
 * 音乐管理控制器
 */
@Controller
@RequestMapping("/api/music")
public class MusicController {

    @Autowired
    private MusicService musicService;

    /**
     * 获取音乐列表
     */
    @GetMapping
    @ResponseBody
    public Result<List<Music>> getMusicList() {
        return Result.success(musicService.selectEnabledList());
    }

    /**
     * 扫描音乐文件夹并更新数据库
     */
    @GetMapping("/scan")
    @ResponseBody
    public Result<List<Music>> scanMusicFolder() {
        String musicPath = System.getProperty("user.dir") + "/src/main/webapp/static/music/";
        File dir = new File(musicPath);
        
        if (!dir.exists()) {
            dir.mkdirs();
            return Result.success(new ArrayList<>());
        }

        File[] files = dir.listFiles((d, name) -> 
            name.toLowerCase().endsWith(".mp3") || 
            name.toLowerCase().endsWith(".wav") || 
            name.toLowerCase().endsWith(".ogg") ||
            name.toLowerCase().endsWith(".flac")
        );

        List<Music> musicList = new ArrayList<>();

        if (files != null) {
            for (int i = 0; i < files.length; i++) {
                File file = files[i];
                String title = file.getName().substring(0, file.getName().lastIndexOf('.'));
                String url = "/static/music/" + file.getName();
                
                // 检查是否已存在
                List<Music> existing = musicService.selectByUrl(url);
                if (existing.isEmpty()) {
                    Music music = new Music();
                    music.setTitle(title);
                    music.setArtist("Unknown Artist");
                    music.setUrl(url);
                    music.setCover("https://picsum.photos/200/200?random=" + (i + 1));
                    music.setSort(i + 1);
                    music.setStatus(1);
                    musicService.insert(music);
                }
                
                musicList.add(musicService.selectByUrl(url).get(0));
            }
        }

        return Result.success(musicList);
    }

    /**
     * 上传音乐文件
     */
    @PostMapping("/upload")
    @ResponseBody
    public Result<Music> uploadMusic(@RequestParam("file") MultipartFile file) {
        try {
            String contentType = file.getContentType();
            if (contentType == null || 
                (!contentType.contains("audio/mpeg") && !contentType.contains("audio/wav") && 
                 !contentType.contains("audio/ogg") && !contentType.contains("audio/flac"))) {
                return Result.error("请上传音频文件");
            }

            if (file.getSize() > 50 * 1024 * 1024) {
                return Result.error("文件大小不能超过 50MB");
            }

            String uploadPath = System.getProperty("user.dir") + "/src/main/webapp/static/music/";
            File dir = new File(uploadPath);
            if (!dir.exists()) {
                dir.mkdirs();
            }

            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename != null && originalFilename.contains(".")
                    ? originalFilename.substring(originalFilename.lastIndexOf("."))
                    : ".mp3";
            String filename = "music_" + System.currentTimeMillis() + extension;

            File destFile = new File(uploadPath + filename);
            file.transferTo(destFile);

            String title = originalFilename != null ? originalFilename.substring(0, originalFilename.lastIndexOf('.')) : "Untitled";
            String url = "/static/music/" + filename;

            Music music = new Music();
            music.setTitle(title);
            music.setArtist("Unknown Artist");
            music.setUrl(url);
            music.setCover("https://picsum.photos/200/200?random=" + System.currentTimeMillis());
            music.setSort(musicService.selectCount() + 1);
            music.setStatus(1);
            musicService.insert(music);

            return Result.success(music);
        } catch (Exception e) {
            e.printStackTrace();
            return Result.error("上传失败: " + e.getMessage());
        }
    }

    /**
     * 删除音乐
     */
    @DeleteMapping("/{id}")
    @ResponseBody
    public Result<String> deleteMusic(@PathVariable Long id) {
        Music music = musicService.selectById(id);
        if (music != null) {
            // 删除文件
            String filePath = System.getProperty("user.dir") + "/src/main/webapp" + music.getUrl();
            File file = new File(filePath);
            if (file.exists()) {
                file.delete();
            }
            musicService.deleteById(id);
        }
        return Result.success("删除成功");
    }
}