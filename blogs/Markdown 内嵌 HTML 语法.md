
> `Markdown`是一种可以使用普通文本编辑器编写的标记语言，通过简单的标记语法，它可以使普通文本内容具有一定的格式，具体请参考 [Markdown 语法说明](https://www.appinn.com/markdown/) 。在`Markdown`中可以内嵌`HTML`语法，本文总结了一些常用的`HTML`标记用于扩展`Markdown`语法。

## 1. 缩进与换行

- 在 Markdown 中，可以用`两个空格 + 回车`来进行换行，另外`<br />`也可以表示换行（注意：换行是指段落内的强迫换行，不同于分段，段落的前后要有一个以上的空行）；
- 在 Markdown 中，可以用 HTML 中的**特殊字符**（见[下文](#6-特殊字符)）`&ensp;`、`&emsp;`来实现缩进的效果，其中`&ensp;`表示半角空格，`&emsp;`表示全角空格。

输入如下所示：

```html
&ensp;&ensp;&ensp;&ensp;半角空格用`&ensp;`表示；<br />&emsp;&emsp;全角空格用`&emsp;`表示。
```

实现的效果如下所示：

&emsp;&emsp;半角空格用`&ensp;`表示；<br />&emsp;&emsp;全角空格用`&emsp;`表示。

## 2. 字体、字号、颜色、背景

```html
<font face="黑体">实现字体为黑体</font>
<small>比默认字体小一号</small>
这里显示的是浏览器默认字体大小
<font size=4>实现字体大小改变</font>
<big>比默认字体大一号</big>
<font color=red>实现字体颜色为红色</font>
<span style="background-color: orange">实现背景填充为橙色</span>
<font color=#FF69B4>字体颜色值也可以用十六进制表示</font>
<span style="background-color: #D3D3D3">背景颜色值也可以用十六进制表示</span>
<font face="黑体" size=4 color=red>实现字体效果：黑体、4号、红色</font>
<span style="background-color: #D3D3D3"><font size=4 color=#DC143C>默认字体，4号，使用十六进制表示颜色值</font></span>
```

----------

<font face="黑体">实现字体为黑体</font>
<small>比默认字体小一号</small>
这里显示的是浏览器默认字体大小
<font size=4>实现字体大小改变</font>
<big>比默认字体大一号</big>
<font color=red>实现字体颜色为红色</font>
<span style="background-color: orange"><font color=#596172>实现背景填充为橙色</font></span>
<font color=#FF69B4>字体颜色值也可以用十六进制表示</font>
<span style="background-color: #D3D3D3"><font color=#596172>背景颜色值也可以用十六进制表示</font></span>
<font face="黑体" size=4 color=red>实现字体效果：黑体、4号、红色</font>
<span style="background-color: #D3D3D3"><font size=4 color=#DC143C>默认字体，4号，使用十六进制表示颜色值</font></span>

----------

> 注意：其中，字号`size`的值可取 1 \~ 7，浏览器的默认值为 3。

## 3. 实现上标、下标

Markdown 支持上标和下标：上标使用`^xxx^`表示，下标使用`~xxx~`表示，如`X~1~^2^`则显示为 X~1~^2^ 。另外，也可以用 HTML 中的`<sup>xxx</sup>`实现上标、`<sub>xxx</sub>`实现下标。

```html
H<sub>2</sub>O、注册商标<sup>&reg;</sup>、(x<sub>1</sub>+x<sub>2</sub>)<sup>2</sup> = x<sub>1</sub><sup>2</sup>+x<sub>2</sub><sup>2</sup>+2x<sub>1</sub>x<sub>2</sub>
```

实现的效果如下所示：

> H<sub>2</sub>O、注册商标<sup>&reg;</sup>、(x<sub>1</sub>+x<sub>2</sub>)<sup>2</sup> = x<sub>1</sub><sup>2</sup>+x<sub>2</sub><sup>2</sup>+2x<sub>1</sub>x<sub>2</sub>

## 4. 实现下划线、上划线

可以使用`<u>`标签为文本添加下划线。

```html
如果文本不是超链接，就不要<u>对其使用下划线</u>。
```

显示效果如下：

> 如果文本不是超链接，就不要<u>对其使用下划线</u>。

可以使用`<span style="text-decoration: overline;"></span>`为文本添加上划线。

```html
<span style="text-decoration: overline;">RESET</span>是复位信号，输入低电平有效。
```

显示效果如下：

> <span style="text-decoration: overline;">RESET</span>是复位信号，输入低电平有效。

## 5. 关于图片处理的技巧

```markdown
Markdown 格式生成的图片默认居左对齐，大小受图片实际大小限制
![](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png)
```

<img style="margin-left: 0" src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" />

```html
可以用 HTML 中 <img> 标签的 "width" 及 "height" 属性来固定图片的大小
<img width=256 height=256 src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" />
```

<img width=256 height=256 style="margin-left: 0" src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" />

```html
可以用 <div> 标签结合 "align" 属性来控制图片居中对齐
<div align="center"><img src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" /></div>
```

![](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png)

```html
若要在图片下方加标注，可以用如下方式实现：
<center>
<img width=256 height=256 src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" />
图 1 数字图像处理的标准图
</center>
```

<img width=256 height=256 src="https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20200715225103.png" />

<p style="text-align:center">图 1 数字图像处理的标准图</p>

## 6. 特殊字符

> 一些常用的特殊符号，比如 &sect; 、&rarr; 、&copy; 、&pi; 等等，均可借助 HTML 语言很容易地实现，具体可参考 [w3school](https://www.w3school.com.cn/) 有关[HTML 符号](https://www.w3school.com.cn/charsets/ref_html_symbols.asp)、[HTML 实体](https://www.w3school.com.cn/charsets/ref_html_entities_4.asp)等相关的页面，下表摘录了部分常用字符作为示例：

|   字符   |    实体    |             描述             |
| :------: | :--------: | :--------------------------: |
|  &nbsp;  |  `&nbsp;`  |      non-breaking space      |
|  &copy;  |  `&copy;`  |        copyright sign        |
|  &yen;   |  `&yen;`   |     yen sign = yuan sign     |
| &brvbar; | `&brvbar;` |     broken vertical bar      |
|  &sect;  |  `&sect;`  |         section sign         |
|  &para;  |  `&para;`  |        paragraph sign        |
| &crarr;  | `&crarr;`  |       carriage return        |
| &hellip; | `&hellip;` |     horizontal ellipsis      |
| &laquo;  | `&laquo;`  | left double angle quotation  |
| &raquo;  | `&raquo;`  | right double angle quotation |
| &trade;  | `&trade;`  |       trade mark sign        |
|  &reg;   |  `&reg;`   |  registered trade mark sign  |
|  &deg;   |  `&deg;`   |         degree sign          |
| &frac14; | `&frac14;` |     fraction one quarter     |
| &frac12; | `&frac12;` |      fraction one half       |
| &frac34; | `&frac34;` |   fraction three quarters    |
| &permil; | `&permil;` |       millesimal sign        |
| &plusmn; | `&plusmn;` |       plus-minus sign        |
| &times;  | `&times;`  |     multiplication sign      |
| &divide; | `&divide;` |        division sign         |
| &oplus;  | `&oplus;`  |         circled plus         |
| &otimes; | `&otimes;` |        circled times         |
| &asymp;  | `&asymp;`  |       almost equal to        |
|   &ne;   |   `&ne;`   |         not equal to         |
|   &le;   |   `&le;`   |    less-than or equal to     |
|   &ge;   |   `&ge;`   |   greater-than or equal to   |
| &equiv;  | `&equiv;`  |         identical to         |
|  &prop;  |  `&prop;`  |       proportional to        |
| &infin;  | `&infin;`  |           infinity           |
|  &fnof;  |  `&fnof;`  |           function           |
| &Delta;  | `&Delta;`  |  greek capital letter delta  |
| &alpha;  | `&alpha;`  |   greek smal letter alpha    |
|  &beta;  |  `&beta;`  |    greek smal letter beta    |
| &gamma;  | `&gamma;`  |   greek smal letter gamma    |
| &theta;  | `&theta;`  |   greek smal letter theta    |
| &lambda; | `&lambda;` |   greek smal letter lambda   |
|   &mu;   |   `&mu;`   |     greek smal letter mu     |
|   &pi;   |   `&pi;`   |     greek smal letter pi     |
| &omega;  | `&omega;`  |   greek smal letter omega    |
|  &larr;  |  `&larr;`  |       leftwards arrow        |
|  &uarr;  |  `&uarr;`  |        upwards arrow         |
|  &rarr;  |  `&rarr;`  |       rightwards arrow       |
|  &darr;  |  `&darr;`  |       downwards arrow        |
|  &harr;  |  `&harr;`  |       left right arrow       |
|  &varr;  |  `&varr;`  |        up down arrow         |
|  &lArr;  |  `&lArr;`  |    leftwards double arrow    |
|  &uArr;  |  `&uArr;`  |     upwards double arrow     |
|  &rArr;  |  `&rArr;`  |   rightwards double arrow    |
|  &dArr;  |  `&dArr;`  |    downwards double arrow    |
|  &hArr;  |  `&hArr;`  |   left right double arrow    |
|  &vArr;  |  `&vArr;`  |     up down double arrow     |
