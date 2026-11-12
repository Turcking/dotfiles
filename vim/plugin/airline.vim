vim9script

# 总是显示标签栏
g:airline#extensions#tabline#enabled = 1

autocmd User AirlineAfterInit {

	# 不显示当前模式
	set noshowmode

	# 如果 luna 主题可用，切换到该主题
	if !!globpath(&runtimepath, "autoload/airline/themes/luna.vim")
		call airline#switch_theme("luna")
	endif

}
