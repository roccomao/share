
实际上，最主要的是我们只要知道编辑器的命令行接口，即 Command Line Interface (CLI)，就可以在其他地方配置调用该编辑器，而这个不难得到，如 [VS Code CLI](https://code.visualstudio.com/docs/editor/command-line)，查看文档，我们可以用`code -g file:line[:character]`打开文件`file`，并跳转到指定的行和可选的列位置。

接下来我们只需要打开 IDE 的配置窗口，一般他们都会给出提示用来说明如何传递命令行参数，例如我们今天举例的三款 FPGA 开发 IDE 都只支持文件名及行号选项，分别是：**ISE** 的`$1`和`$2`、**Vivado** 的`[file name]`和`[line number]`以及 **Quartus** 的`%f`和`%l`。以 VSCode 举例配置如下：

- **ISE**     : `D:\\Tools\\Microsoft\ VS\ Code\\Code.exe -g $1:$2`
- **Quartus** : `"D:\Tools\Microsoft VS Code\Code.exe" -g %f:%l`
- **Vivado**  : `"D:/Tools/Microsoft VS Code/Code.exe" -g [file name]:[line number]`

同理，若使用 Vim，只需在 Vim 中运行`:h vim-arguments`即可查看启动 Vim 的命令行参数，类似的，配置`gVim`如下：

- **ISE**     : `D:\\Tools\\Vim\\vim90\\gvim.exe $1 +$2`
- **Quartus** : `"D:\Tools\Vim\vim90\gvim.exe" %f +%l`
- **Vivado**  : `"D:/Tools/Vim/vim90/gvim.exe" [file name] +[line number]`

总之，查看你所用编辑器的命令行接口 **CLI**，然后按照其相应的格式传入具体的实参表达式即可。下面分享我个人对几个 IDE 配置 gVim 编辑器的自定义设置，供参考：

- **ISE**            : `D:\\Tools\\Vim\\vim91\\gvim.exe --servername GISE --remote-silent +$2 $1`
- **Quartus**        : `"D:\Tools\Vim\vim91\gvim.exe" --servername GQUARTUS --remote-silent +%l %f`
- **Vivado**         : `"D:/Tools/Vim/vim91/gvim.exe" --servername GVIVADO --remote-silent +[line number] [file name]`
- **Source Insight** : `"D:\Tools\Vim\vim91\gvim.exe" --servername GSRCINS --remote-silent +%l %f`
- **Visual Studio**  : `--servername GVS --remote-silent "+call cursor($(CurLine), $(CurCol))" $(ItemPath)`
- **Keil MDK**       : `--servername GKEIL --remote-silent "+call cursor(~E+1, ^E??1)" "#E"`
- **DVT Eclipse**    : `--servername GDVT --remote-silent +${selected_resource_line} "${selected_resource_loc}"`

----------------

如果你也同时在使用 VSCode 和 gVim，你甚至可以在 VSCode 中配置快捷键，从而使用 gVim 来快速打开当前文件，只需要在`tasks.json`中创建一个全局任务，如下所示：

```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Edit with Vim",
            "type": "shell",
            "command": "gvim",
            "args": [
                "--servername",
                "GCODE",
                "--remote-silent",
                "+${lineNumber}",
                "${file}"
            ],
            "problemMatcher": [],
            "presentation": {
                "panel": "new",
                "close": true,
                "reveal": "never"
            }
        }
    ]
}
```

然后为该任务创建按键绑定即可，比如我绑定快捷键为 <code>Alt+`</code> 如下示例：

```json
[
    {
        "key": "alt+oem_3",
        "command": "workbench.action.tasks.runTask",
        "args": "Edit with Vim"
    }
]
```
