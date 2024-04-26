
如果你还因为某些原因而不得不使用 Xilinx ISE 软件，而他在 Windows 10 系统上将无法正常运行，这里有一份来自 10 年之前的[解决方案](https://www.eevblog.com/forum/fpga/guide-getting-xilinx-ise-to-work-with-windows-8-64-bit/msg479087/#msg479087)，为防止链接失效，引用如下：

<details>
<summary>Guide: Getting Xilinx ISE to work with Windows 8 / Windows 10 (64-bit)</summary>

*Published on: July 14, 2014, 07:37:57 pm*

>**10/8/2015 Updated: This guide will also work for Windows 10 64-bit**
>
>I recently scored a Spartan 3E Starter Board on eBay. So, thinking I was on to a winner as I used this board during my time at uni, I downloaded and installed Xilinx ISE WebPACK.
>
>But the problem is, it barely works in 64-bit mode on Windows 8. The license manager and Project Navigator both just close when you try to open a file and PlanAhead only works in 32-bit mode.
>
>Xilinx ISE does not officially support Windows 8 and it probably never will as Xilinx are focused on their new suite - Vivado. However, Vivado only works with 7 series devices and upwards, so no Spartan 3 or Spartan 6 FPGAs!
>
>But all is not lost, here is how you can get ISE (64-bit) working on Windows 8.
>
>**Fixing Project Navigator, iMPACT and License Manager**
>
>Note: I am assuming you are using ISE 14.7 and have installed it to the default location
>
>- Open the following directory: C:\Xilinx\14.7\ISE_DS\ISE\lib\nt64
>- Find and rename libPortability.dll to libPortability.dll.orig
>- Make a copy of libPortabilityNOSH.dll (copy and paste it to the same directory) and rename it libPortability.dll
>- Copy libPortabilityNOSH.dll again, but this time navigate to C:\Xilinx\14.7\ISE_DS\common\lib\nt64 and paste it there
>- In C:\Xilinx\14.7\ISE_DS\common\lib\nt64 Find and rename libPortability.dll to libPortability.dll.orig
>- Rename libPortabilityNOSH.dll to libPortability.dll
>
>**Fixing PlanAhead not opening from 64-bit Project Navigator**
>
>PlanAhead will not open when you are running 64-bit Project Navigator (e.g. for I/O Pin Planning), it just displays the splash screen but never opens.
>
>To fix it, we have to force PlanAhead to always run in 32-bit mode.
>
>- Open C:\Xilinx\14.7\ISE_DS\PlanAhead\bin and rename rdiArgs.bat to rdiArgs.bat.orig
>- Download the [attached zip file](https://www.eevblog.com/forum/fpga/guide-getting-xilinx-ise-to-work-with-windows-8-64-bit/?action=dlattach;attach=102040)
>- Extract it. You should now have a file named rdiArgs.bat
>- Copy the new rdiArgs.bat file to C:\Xilinx\14.7\ISE_DS\PlanAhead\bin
>
>Now you should have a working ISE Design Suite on Windows 8 64-bit.
>
>Hope this helps !!!

</details>

在这里 [Github: cbureriu/xilinx-14.7-patch-for-Win10-32-64](https://github.com/cbureriu/xilinx-14.7-patch-for-Win10-32-64) 有一份脚本可以快速实现上述方案（它不包含 Fixing PlanAhead），然而随着时间的推移，在 Windows 10 更新新的补丁后，上述方法可能不再有效，正如 [Issue](https://github.com/cbureriu/xilinx-14.7-patch-for-Win10-32-64/issues/2) 中评论到的：

> If you have WSL enabled, after Windows 10 update KB5021233, this batch will not work. All Xilinx tools (ISE, XPS, XSDK) will simply fail to launch. Please use the [following DLLs](https://www.exxosforum.co.uk/forum/download/file.php?id=29188) and replace all LibPortability.dll and LibPortability_NOSH.dll as well. Regards!

我们可以去[原始帖子](https://www.exxosforum.co.uk/forum/viewtopic.php?f=65&t=6052)查看详情，下载来自 [czietz](https://www.exxosforum.co.uk/forum/viewtopic.php?p=95891#p95891) 修改后的文件 [xilinx-ise-win10-hang-hotfix.zip](https://www.exxosforum.co.uk/forum/download/file.php?id=29188) 来替换原始文件，我编写了 bat 脚本来实现自动化替换，同时把上述的 Fixing PlanAhead 方案也添加了进来，使用方法如下：

--------

0. **注意**：若你打开过 ISE 并闪退，或者双击打开后没有看到任何反应，实际上 ISE 程序还在运行，请打开任务管理器，找到所有的 ise.exe 及 ISE 相关的程序，右键手动结束任务，以防止文件被进程占用而导致我们替换补丁文件时可能会失败

1. 通过本仓库下载[所有需要的文件](https://github.com/roccomao/share/tree/master/code/Others/Xilinx)：包含 [patch.bat](../code/Others/Xilinx/patch.bat)，[revert.bat](../code/Others/Xilinx/revert.bat) 和一个目录 `patch/`，其中目录 `patch/` 下的文件全部来源于上述链接

2. 假设你的 ISE 安装在了 `D:\Xilinx\` 目录下，将会有目录结构 `D:\Xilinx\14.7\ISE_DS\`，总之去到根目录，请将上述文件放置在 `xxx\14.7` 的同级目录下，如下：
   ```
   14.7/
   patch/
   patch.bat
   revert.bat
   ```

3. 运行 **patch.bat** 即可自动完成所有替换，此时便可以正常使用 ISE 软件；若要恢复所有的原始文件，即撤销替换，请运行 **revert.bat**

<!-- ../blob/master -->
