
作为引子，首先来看一段描述，该段介绍了`SystemVerilog`对比`Verilog`在`RTL`**设计**和**建模**时的新特性之一（`logic`数据类型），然后下文我再详细展开对比介绍`Verilog`和`SystemVerilog`中的基本数据类型。（*该段内容引用自 [@Dr. Pong P. Chu](https://academic.csuohio.edu/chu-pong/) 的[书籍列表](https://academic.csuohio.edu/chu-pong/dr-chus-books/)之[《FPGA Prototyping by SystemVerilog Examples: Xilinx MicroBlaze MCS SoC》](https://academic.csuohio.edu/chu-pong/sv-mcs-book/)的[书籍说明](https://academic.csuohio.edu/chu-pong/wp-content/uploads/sites/64/2023/02/SystemVerilog-vs-Verilog-in-RTL-design.pdf)部分*）

> [《SystemVerilog vs Verilog in RTL Design》](https://academic.csuohio.edu/chu-pong/wp-content/uploads/sites/64/2023/02/SystemVerilog-vs-Verilog-in-RTL-design.pdf)By [Pong P. Chu](https://academic.csuohio.edu/chu-pong/), Chapter 3.1 **logic** DATA TYPE
>
> Verilog‐2001 divides the data types into a "net" group and a "variable" group. The former is used in the output of a continuous assignment and the `wire` type is the most commonly used type in the group. The latter is used in the output of a procedural assignment and the `reg` type is the most commonly used type in the group. Verilog‐2001 has a specific set of rules and restrictions regarding the assignment and connection of signals from the different groups.
>
> The names of the `wire` and `reg` types are misleading. A signal declared with the `wire` type can be a connection wire or a component with memory (e.g., a latch). A variable declared with the `reg` type may or may not infer a register. It can be a connecting wire, a register, a latch, or a "C‐like software variable". Furthermore, the rules and restrictions imposed on assignment and connection of signals from different the groups are confusing and unnecessary.
>
> SystemVerilog introduces the `logic` data type. It can be used in the variable group or net group, which is inferred automatically from context. The `logic` type can replace the `wire` and `reg` types in most codes. In addition, its name does not imply a specific hardware component and thus is more descriptive.

## 1. `Verilog`的数据类型

`Verilog`语言提供两组基本的数据类型：变量数据类型（`variable`）和线网数据类型（`net`），这两种类型都是四值逻辑。具体请参考《IEEE Standard for Verilog》Chapter 4 Data types。

- 对线网的声明进行简化，即：`net_type` **+** `list_of_net_identifiers`，其中`net_type`包含我们常用的如`wire`、`tri`、`wand`、`wor`等等（参考完整的线网声明：[net_declaration](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324090804.png)）；
- 对变量的声明进行简化，即：`reg | integer | time | real | realtime` **+** `list_of_variable_identifiers`（参考完整的变量声明：[variable_declaration](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324092030.png)）。

可以看到，在`Verilog`中，线网及变量的声明都很简单，都只有**两部分**：如`net_type | reg | integer` **+** `声明列表`即可。另外，再来看`Verilog`中的赋值，`Verilog`中将连续赋值（`Continuous assignment`）及过程赋值（`Procedural assignment`）中的左值（`LHS`）分别限制为了线网（`net`）和变量（`variable`）类型，换言之，如我们常用的`wire`类型（`net`）只可以被连续赋值，以及我们常用的`reg`类型（`variable`）只可以被过程赋值：

![image-20210324100218290](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324100218.png)

在`Verilog`中，`reg`经常用来表示存储组合逻辑或时序逻辑的变量，不过很多初学者会混淆其综合后的硬件单元。实际上，`reg`变量并不一定会被综合为寄存器（`register`），之所以定义成`reg`类型，是表示从仿真的语义上来讲需要一个存储单元，而与综合后的硬件电路没有直接的关联，所以对初学者而言有时会具有误导性。而在`SystemVerilog`中，我们便引入了更具有描述性的`logic`数据类型，下面来介绍`SystemVerilog`中的数据类型。

## 2. `SystemVerilog`的数据类型

`SystemVerilog`添加了很多新的数据类型，但依然可以分为两组类型：变量类型（`variable`）和线网类型（`net`），来看他们的声明及定义如下，具体请参考《IEEE Standard for SystemVerilog》Chapter 6 Data types。

- 对线网类型的声明进行简化，即（参考完整的线网声明：[net_declaration](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324103111.png)）：
  - `net_type` **+** `data_type` **+** `list_of_net_decl_assignments`
- 对变量类型的声明进行简化，即（参考完整的变量声明：[variable_declaration](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324103626.png)）：
  - `[const][var]` **+** `data_type` **+** `list_of_variable_decl_assignments`

对比上述简化版之后，就可以发现：`SystemVerilog`区分为**类型**和**数据类型**，且两种**类型**（`net`和`variable`）的变量声明方式相同，都是**三部分**：`类型` **+** `数据类型` **+** `声明列表`。其中线网类型（`net_type`）包含`supply0 | supply1 | tri | triand | trior | trireg | tri0 | tri1 | uwire | wire | wand | wor`，与`Verilog`相同；而变量类型（`variable_type`）只需要关键字`var`即可，并且`var`可以省略。另外**注意**，原来`Verilog`中的`reg`、`integer`、`time`、`real`、`realtime`在`SystemVerilog`中则都属于**数据类型**，并且`SystemVerilog`又添加了很多新的**数据类型**：

![image-20210324110320132](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324110320.png)

其中又可以分为二值逻辑、四值逻辑；新增了枚举（`enum`）、结构体（`struct`）、字符串（`string`）、类（`class`）等一些新的数据类型，这里不展开介绍。只要明白，仅有**数据类型**时（如`reg r;`、`byte b;`、`logic c;`），其默认表示的是变量**类型**，因为关键字`var`可以省略。另外，**数据类型**也可以省略，仅有**类型**声明时（如`wire w;`、`var v;`），此时**数据类型**被隐式声明为`logic`：

- If a data type is not specified in the net declaration or if only a range and/or signing is specified, then the data  type of the net is implicitly declared as `logic`.
- If a data type is not specified in the variable declaration or if only a range and/or signing is specified, then the data type of the variable is implicitly  declared as `logic`.

```verilog
reg          r  ; // equivalent to "var reg r;"
logic [15:0] l  ; // equivalent to "var logic [15:0] l;"
var byte my_byte; // equivalent to "byte my_byte;"
wire         w  ; // equivalent to "wire logic w;"
wire  [15:0] ww ; // equivalent to "wire logic [15:0] ww;"
var          v  ; // equivalent to "var logic v;"
var   [15:0] vw ; // equivalent to "var logic [15:0] vw;"
```

再来看到，既然线网类型的声明也是`线网类型` **+** `数据类型`（`net_type` **+** `data_type`），而在`SystemVerilog`中，像`reg`、`bit`、`byte`、`int`等，又都属于数据类型（`data_type`），那么，则有`tri reg t;`、`inout wire reg p;`、`wire int i;`等等，这些是否合法呢？显然是不合法的。在《IEEE Standard for SystemVerilog》Chapter 6.7.1 Net declarations with built-in net types 中对线网类型（`net_type`）的数据类型（`data_type`）单独做了限制说明（Certain restrictions apply to the data type of a net）：

- A valid data type for a net shall be one of the following:
  - A 4-state integral type, including a packed array or packed structure.
  - A fixed-size unpacked array or unpacked structure, where each element has a valid data type for a net.
- A lexical restriction applies to the use of the reg keyword in a net or port declaration. A net type keyword shall not be followed directly by the reg keyword. The reg keyword can be used in a net or port declaration if there are lexical elements between the net type keyword and the reg keyword.

这说明了线网类型（`net_type`）的数据类型（`data_type`）只能为四值数据类型（4-state data type），并且`net_type` **+** `reg` **+** `list_of_net_decl`是非法的。以下都是合法的线网类型声明（`net declarations`）：

```verilog
wire logic w;
wire [15:0] ww;
trireg (large) logic #(0,0,0) cap1;
typedef logic [31:0] addressT;
wire addressT w1;
wire struct packed { logic ecc; logic [7:0] data; } memsig;
```

最后再来看赋值，主要注意其连续赋值（`Continuous assignment`）中的左值（`LHS`）与`Verilog`的区别：在`SystemVerilog`中，连续赋值的左值支持变量类型，而`Verilog`仅仅支持线网类型。这意味着，在`SystemVerilog`中，甚至可以有`reg a; assign a = 1'b1;`也不会报错（请**不要**在实际代码中这么书写，建议使用`logic`数据类型）。

![](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/20210324135038.png)

所以，在`SystemVerilog`中，有如`logic [15:0] data;`，虽然默认表示的是变量类型（等价于`var logic [15:0] data;`），但是也支持连续赋值。由于其既支持连续赋值，又支持过程赋值，同时又是四值逻辑，所以`logic`数据类型可以代替`Verilog`设计代码中的大多数`wire`类型和`reg`类型，至于被综合成什么硬件，依然要由综合器根据上下文来进行推断。

## 3. 概括对比总结

![](https://bitnotes.oss-cn-shanghai.aliyuncs.com/assets/202502151640453.png)
