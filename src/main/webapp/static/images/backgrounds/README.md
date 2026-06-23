# 背景图片资源目录

此目录用于存放预设的背景图片资源。

## 目录结构

```
src/main/webapp/
├── static/
│   └── images/
│       └── backgrounds/     # 预设背景图片（会被 Git 追踪）
│           ├── default.jpg  # 默认背景
│           ├── aurora.jpg   # 极光背景
│           ├── sunset.jpg   # 日落背景
│           └── ...
└── upload/
    └── backgrounds/         # 用户上传的背景图片（不会被 Git 追踪）
```

## 使用说明

1. **预设背景**：放在 `static/images/backgrounds/` 目录下
2. **用户上传**：放在 `upload/backgrounds/` 目录下（运行时动态创建）

## 注意事项

- 预设背景图片会被 Git 追踪并上传到仓库
- 用户上传的背景图片不会被 Git 追踪
- 建议预设背景图片大小不超过 5MB