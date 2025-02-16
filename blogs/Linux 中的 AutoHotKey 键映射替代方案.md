
## 1. Windows 之 AutoHotKey

初次了解`AutoHotKey`，是在[Win 下最爱效率神器：AutoHotKey | 晚晴幽草轩](https://www.jeffjade.com/2016/03/11/2016-03-11-autohotkey/)这篇博客中，博主有对`AutoHotKey`作详细介绍，这里不再赘余。当时打字很慢，更苦于写代码时需要经常按方向键、`Home`、`End`以及删除键等等按键（当然这些问题有些编辑器就可以解决），还经常涉及到文本选择，对个人而言很是痛苦，直到遇到了`AutoHotKey`，解决了一大痛点，可以用它来重新布局我的键盘。看到了[@冯若航](https://www.zhihu.com/people/vonng)大佬分享的`AHK`脚本[AutoHotKey 常用函数或小技巧有哪些分享？](https://www.zhihu.com/question/19645501/answer/39906404)，我稍微做了一丁点修改及删减，主要的按键映射如下图所示（全部是关于和`CapsLock`按键的组合应用，完整功能见代码）：

![](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210316225809.png)

这里稍微说明一下：将`CapsLock`键映射为了`ESC`键，`CapsLock`键通过`CapsLock + \`来实现，图中的实现默认为和`CapsLock`组合按下时生效（如`CapsLock + T`插入当前的日期和时间，`CapsLock + D`复制当前行等等）；另外，关于光标移动，比如`CapsLock + H`映射为`Home`键，若再同时按下`Alt`键，则可实现选中当前光标到`Home`键位置之间的文本，其余的比如`CapsLock + Alt + U`实现向前选中一个字词皆类似，依此类推详见上图（另外，还可按住`CapsLock + Alt`不松手，多次按下不同的光标移动映射按键，以此来实现快速精确的选中任何文本）。

这里也把代码分享一下，我的`CapsLock.ahk`脚本如下所示：

```
;---- CapsLock Initializer ----
SetCapsLockState, AlwaysOff

;---- CapsLock + \ === CapsLock ----
CapsLock & \::
GetKeyState, CapsLockState, CapsLock, T
if CapsLockState = D
    SetCapsLockState, AlwaysOff
else
    SetCapsLockState, AlwaysOn
KeyWait, \
return

;---- CapsLock === ESC ----
CapsLock:: Send, {ESC}

;---- Editor ----
CapsLock & z:: Send, ^z             ; Z = Cancel
CapsLock & x:: Send, ^x             ; X = Cut
CapsLock & c:: Send, ^c             ; C = Copy
CapsLock & v:: Send, ^v             ; V = Paste
CapsLock & a:: Send, ^a             ; A = Select All
CapsLock & g:: Send, ^y             ; Y = Redo
;---- Delete ----
CapsLock & ,:: Send, {Del}          ; , = Del char after
CapsLock & .:: Send, ^{Del}         ; . = Del word after
CapsLock & /:: Send, +{End}{Del}    ; / = Del all  after
CapsLock & m:: Send, {BS}           ; m = Del char before
CapsLock & n:: Send, ^{BS}          ; n = Del word before
CapsLock & b:: Send, +{Home}{Del}   ; b = Del all  before
;---- ---- ---- ----
CapsLock & f:: Send, ^f             ; F = Find
CapsLock & w:: Send, ^w             ; W = Close
CapsLock & s:: Send, ^s             ; S = Save
CapsLock & e:: Send, !{F4}          ; E = Exit
;---- ---- ---- ----
CapsLock & q:: Send, {Enter}
CapsLock & r:: Send, {AppsKey}
;---- ---- ---- ----
CapsLock & =:: Send, ^{WheelUp}
CapsLock & -:: Send, ^{WheelDown}

;---- CapsLock + D === Copy Current Line ----
CapsLock & d:: Send, {Home}+{End}^c{End}

;---- CapsLock + T === Insert Current Time ----
CapsLock & t:: Send, %A_YYYY%{Asc 45}%A_MM%{Asc 45}%A_DD%{Asc 32}%A_Hour%{Asc 58}%A_Min%{Asc 58}%A_Sec%

;---- U === Word Before ----
CapsLock & u::
if GetKeyState("Alt") = 0
    Send, ^{Left}
else
    Send, ^+{Left}
return

;---- O === Word After ----
CapsLock & o::
if GetKeyState("Alt") = 0
    Send, ^{Right}
else
    Send, ^+{Right}
return

;---- P === PageDown ----
CapsLock & p::
if GetKeyState("Alt") = 0
    Send, {PgDn}
else
    Send, +{PgDn}
return

;---- Y === PageUp ----
CapsLock & y::
if GetKeyState("Alt") = 0
    Send, {PgUp}
else
    Send, +{PgUp}
return

;---- H === Home ----
CapsLock & h::
if GetKeyState("Alt") = 0
    Send, {Home}
else
    Send, +{Home}
return

;---- ; === End ----
CapsLock & `;::
if GetKeyState("Alt") = 0
    Send, {End}
else
    Send, +{End}
return

;---- J === Left ----
CapsLock & j::
if GetKeyState("Alt") = 0
    Send, {Left}
else
    Send, +{Left}
return

;---- K === Down ----
CapsLock & k::
if GetKeyState("Alt") = 0
    Send, {Down}
else
    Send, +{Down}
return

;---- I === Up ----
CapsLock & i::
if GetKeyState("Alt") = 0
    Send, {Up}
else
    Send, +{Up}
return

;---- L === Right ----
CapsLock & l::
if GetKeyState("Alt") = 0
    Send, {Right}
else
    Send, +{Right}
return

;---- Mouse Controller ----
CapsLock & Up::    MouseMove, 0, -10, 0, R  ; Mouse Up
CapsLock & Down::  MouseMove, 0, 10, 0, R   ; Mouse Down
CapsLock & Left::  MouseMove, -10, 0, 0, R  ; Mouse Left
CapsLock & Right:: MouseMove, 10, 0, 0, R   ; Mouse Right

;---- CapsLock + Enter === Mouse Left ----
CapsLock & Enter::
SendEvent, {Blind}{LButton Down}
KeyWait, Enter
SendEvent, {Blind}{LButton Up}
return

;---- Scroll Left ----
CapsLock & WheelUp::    ; 向左滚动
ControlGetFocus, fcontrol, A
Loop 2  ; <-- 增加这个值来加快滚动速度
    SendMessage, 0x114, 0, 0, %fcontrol%, A
return

;---- Scroll Right ----
CapsLock & WheelDown::  ; 向右滚动
ControlGetFocus, fcontrol, A
Loop 2  ; <-- 增加这个值来加快滚动速度
    SendMessage, 0x114, 1, 0, %fcontrol%, A
return
```

## 2. Linux 之 Xmodmap

但在使用 Linux 时，没有了`AutoHotKey`的按键映射，很不习惯，最后找到了`Xmodmap`的解决方案。参考链接：[Xmodmap (简体中文)](https://wiki.archlinuxcn.org/wiki/Xmodmap)，这里也把配置文件`~/.Xmodmap`分享出来，如下所示：

```
! Caps_Lock --> Mode_switch
clear  lock
add    mod5 = Caps_Lock
keycode  66 = Mode_switch

! Caps_Lock + \ --> Caps_Lock
keycode  51 = backslash bar Caps_Lock

! Caps_Lock + space --> Escape
keycode  65 = space NoSymbol Escape

! Caps_Lock + q --> Enter
keycode  24 = q Q Return

! Caps_Lock + r --> Menu
keycode  27 = r R Menu

! Caps_Lock + , --> Delete
keycode  59 = comma less Delete

! Caps_Lock + m --> BackSpace
keycode  58 = m M BackSpace

! Caps_Lock + y --> PageUp
keycode  29 = y Y Prior

! Caps_Lock + p --> PageDown
keycode  33 = p P Next

! Caps_Lock + i --> Up
keycode  31 = i I Up

! Caps_Lock + k --> Down
keycode  45 = k K Down

! Caps_Lock + j --> Left
keycode  44 = j J Left

! Caps_Lock + l --> Right
keycode  46 = l L Right

! Caps_Lock + h --> Home
keycode  43 = h H Home

! Caps_Lock + ; --> End
keycode  47 = semicolon colon End
```

具体的功能实现过程可参考上述链接 [Xmodmap](https://wiki.archlinux.org/title/Xmodmap) 以及 [Xmodmap Command](https://www.ibm.com/docs/en/aix/7.3?topic=x-xmodmap-command)。不足之处：`Xmodmap`需要`X`图形界面的环境支持，在没有安装图形界面的纯文本命令行模式下无法运行；另外，其无法实现组合键的映射，只能实现单一按键或组合按键到某一按键的映射，因此`Xmodmap`仅仅实现了以上`AutoHotKey`部分的单个按键的映射（具体仅包含以下按键：CapsLock、Escape、Enter、Menu、Delete、BackSpace、PgUp、PgDn、Up、Down、Left、Right、Home、End）。**这里注意：由于`CapsLock`本身映射为了无意义的`Mode_switch`按键，所以不能再直接映射为`ESC`按键了，此时`ESC`由`CapsLock + Space`来实现，`CapsLock`功能依然由`CapsLock + \`来实现。**
