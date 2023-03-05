
1. 终端 Vim 改变光标在不同模式下的样式

   - **Reference**: [Change cursor shape in different modes](https://vim.fandom.com/wiki/Change_cursor_shape_in_different_modes)

   ```vim
   let &t_SI = "\<Esc>[6 q"
   let &t_SR = "\<Esc>[4 q"
   let &t_EI = "\<Esc>[2 q"

   "  1 -> blinking block
   "  2 -> solid block
   "  3 -> blinking underscore
   "  4 -> solid underscore
   "  5 -> blinking vertical bar
   "  6 -> solid vertical bar
   ```

2. 出现类似`>4;m`、`>4;2m`的异常字符

   - **Reference**: [What's t_TE and t_TI added by vim 8?](https://vi.stackexchange.com/q/27399/41821)
   - **TL;DR** Solution: [disable the modifyOtherKeys feature](https://stackoverflow.com/a/62150215/14395049)
   - **Vim Help**: `:h map.txt` & `:h modifyOtherKeys`

   ```vim
   let &t_TI = ""
   let &t_TE = ""
   ```

3. Vim 支持终端真彩，但可能需要一些额外配置

   - **Reference**: [termguicolors doesn't work in terminal Vim](https://github.com/vim/vim/issues/993)
   - **Vim Help**: `:h term.txt` & `:h xterm-true-color` & `:h tmux-integration`

   ```vim
   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
   set termguicolors
   ```

<!-- null -->
