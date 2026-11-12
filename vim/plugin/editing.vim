vim9script

# 不使用文件类型插件推荐的代码风格
g:filetype_recommended_style = 0

# 保留 tab 字符
set noexpandtab

# tab 宽度
&tabstop = 4

# 键入 tab 时的缩进，使用 tab 操作步长
&softtabstop = 0

# 缩进宽度跟随 tab 显示宽度
&shiftwidth = &tabstop

# 缩进对齐
set shiftround

# 自动缩进
set autoindent smartindent
