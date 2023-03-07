
实际上，最主要的是我们只要知道编辑器的命令行接口，即 Command Line Interface (CLI)，就可以在其他地方配置调用该编辑器，而这个不难得到，如 [VS Code CLI](https://code.visualstudio.com/docs/editor/command-line)，查看文档，我们可以用`code -g file:line[:character]`打开文件`file`，并跳转到指定的行和可选的列位置。

接下来我们只需要打开 IDE 的配置窗口，一般他们都会给出提示用来说明如何传递命令行参数，例如我们今天举例的三款 FPGA 开发 IDE 都只支持文件名及行号选项，分别是：**ISE** 的`$1`和`$2`、**Vivado** 的`[file name]`和`[line number]`以及 **Quartus** 的`%f`和`%l`。举例如下（如果编辑器路径已被添加到环境变量，那么这里还可以省略完整路径，直接改为`code`即可）：

- **ISE** : `D:\\Tools\\Microsoft\ VS\ Code\\Code.exe -g $1:$2`
- **Quartus** : `"D:\Tools\Microsoft VS Code\Code.exe" -g %f:%l`
- **Vivado** : `"D:/Tools/Microsoft VS Code/Code.exe" -g [file name]:[line number]`

同理，若使用 Vim，在 Vim 中运行`:h vim-arguments`即可查看启动 Vim 的命令行参数，类似的，配置`gvim`如下：

- **ISE** : `D:\\Tools\\Vim\\vim90\\gvim.exe $1 +$2`
- **Quartus** : `"D:\Tools\Vim\vim90\gvim.exe" %f +%l`
- **Vivado** : `"D:/Tools/Vim/vim90/gvim.exe" [file name] +[line number]`

<!-- null -->
