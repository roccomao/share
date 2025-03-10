
## 1. 首先理解 scope 的概念

除了常见的`module`、`interface`、`class`、`task`以及`function`等等，另外，***begin-end*** **block** 和 ***fork-join*** **block** 也是一个 **scope**（这里的 ***fork-join*** **block** 包括`fork-join`、`fork-join_any`和`fork-join_none`），如下示例，在匿名块中也可以声明变量，该变量只在当前匿名块或者其内部嵌套的 **scope** 中是可见的：

```verilog
`timescale 1ns/1ns

module test;
  int a = 1;
  initial begin
    int b;
    b = 2;
    $display("block scope b is %0d", b);    // 2
  end
  // initial begin
  //   $display("try to access b : %0d", b);   // Error
  // end
  initial begin
    int a;
    a = 3;
    begin
      $display("block scope a is %0d", a);  // 3
    end
  end
  initial fork
    int a;
    a = 4;
    #0 $display("block scope a is %0d", a); // 4
  join
  initial begin
    $display("module scope a is %0d", a);   // 1
  end
endmodule
```

## 2. Scope and lifetime

参考 IEEE Std 1800-2017 **6.21** Scope and lifetime，原文这一小节全都是重点，请仔细阅读。

- Variables declared inside a static task, function, or block are local in scope and default to a static lifetime.
  - Specific variables **within a static** task, function, or block can be **explicitly declared as automatic**. Such variables have **the lifetime of the call or block** and **are initialized on each entry to the call or block**.
- Tasks and functions may be declared as automatic. Variables declared in an **automatic** task, function, or block are **local in scope**, default to **the lifetime of the call or block**, and **are initialized on each entry to the call or block**. An automatic block is one in which declarations are automatic by default.
  - Specific variables **within an automatic** task, function, or block can be **explicitly declared as static**. Such variables have a static lifetime.
- The lifetime of a ***fork-join*** **block** shall encompass the execution of all processes spawned by the block. The lifetime of a scope enclosing any ***fork-join*** **block** includes the lifetime of the ***fork-join*** **block**.

## 3. About the for-loop

- Reference : IEEE Std 1800-2017 **12.7.1** The for-loop
- declared `for` loop variables are **by default** `automatic`
- The variables used to control a for-loop can also be declared within the loop, as part of the *for_initialization* assignments. **This creates an implicit begin-end block around the loop**, containing declarations of the loop variables with **automatic** lifetime. **This block creates a new hierarchical scope, making the variables local to the loop scope**. The block is unnamed by default, but can be named by adding a statement label to the for-loop statement. Thus, other parallel loops cannot inadvertently affect the loop control variable.

```verilog
module m;
  initial begin
    for (int i = 0; i <= 255; i++)
      // something
  end
  initial begin
    loop2: for (int i = 15; i >= 0; i--)
      // something
  end
endmodule
```

其与下列代码等价：

```verilog
module m;
  initial begin
    begin
      automatic int i;
      for (i = 0; i <= 255; i++)
        // something
    end
  end
  initial begin
    begin : loop2
      automatic int i;
      for (i = 15; i >= 0; i--)
        // something
    end
  end
endmodule
```

## 4. Variable declarations in the static scope

还是参考 IEEE Std 1800-2017 **6.21** Scope and lifetime 这一小节：Variables declared in a static task, function, or procedural block default to a static lifetime and a local scope. However, an explicit static keyword shall be required when an initialization value is specified as part of a static variable's declaration to indicate the user's intent of executing that initialization only once at the beginning of simulation. The static keyword shall be optional where it would not be legal to declare the variables as automatic. 即，**对于缺省为`static`的声明**：是指仅仅有变量声明而不包含初始化的时候，此时`static`关键字可省略；而当变量声明包含初始化的值时，应当显式指定`static`或`automatic`关键字（除非`automatic`声明是非法的，此时`static`关键字可省略），否则会警告或报错。以下是示例代码：

```verilog
`timescale 1ns/1ns

module test;
  // A variable declaration that contains an initialization value
  int svar0 = 1; // automatic is illegal, so static shall be optional
  initial begin
    // A variable declaration that contains an initialization value
    int var1 = 1; // Warning: an explicit static/automatic needed
    for (int i = 0; i < 3; i++) begin
      // A variable declaration that contains an initialization value
      int var2 = 1; // Error: an explicit static/automatic needed
    end
  end
endmodule
```

## 5. 一个示例代码片段的分析

如果理解了前文的 **scope**、**lifetime** 以及 **for-loop**，就可以解释 IEEE Std 中 **6.21** 小节的示例：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i=0; i<3; i++) begin
      automatic int loop3 = 0;
      for (int j=0; j<3; j++) begin
        loop3++;
        $display(loop3);
      end
    end // prints 1 2 3 1 2 3 1 2 3
    // ------------------------------
    for (int i=0; i<3; i++) begin
      static int loop1 = 0;
      for (int j=0; j<3; j++) begin
        loop1++;
        $display(loop1);
      end
    end // prints 1 2 3 4 5 6 7 8 9
  end
endmodule : test
```

为了描述 **for** 循环的运行过程，其大致与下列代码等价：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    begin
      automatic int i;
      i = 0;
      begin
        automatic int loop3 = 0;
        for (int j=0; j<3; j++) begin
          loop3++;
          $display(loop3);
        end
      end
      i = 1;
      begin
        automatic int loop3 = 0;
        for (int j=0; j<3; j++) begin
          loop3++;
          $display(loop3);
        end
      end
      i = 2;
      begin
        automatic int loop3 = 0;
        for (int j=0; j<3; j++) begin
          loop3++;
          $display(loop3);
        end
      end
      i = 3;
    end
    // ---------------------------------
    begin
      automatic int i;
      static int loop1 = 0; // static lifetime
      // loop1 only be initialized once on first entry to the call or block
      i = 0;
      begin
        for (int j=0; j<3; j++) begin
          loop1++;
          $display(loop1);
        end
      end
      i = 1;
      begin
        for (int j=0; j<3; j++) begin
          loop1++;
          $display(loop1);
        end
      end
      i = 2;
      begin
        for (int j=0; j<3; j++) begin
          loop1++;
          $display(loop1);
        end
      end
      i = 3;
    end
  end
endmodule : test
```

--------

如果只看后半部分代码，稍微更改如下：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i=0; i<3; i++) begin
      static int local_i = i; // Error
      for (int j=0; j<3; j++) begin
        local_i++;
        $display(local_i);
      end
    end
  end
endmodule : test
```

这里会报错：A static declaration may not use any non-static references in its initial expression，即在包含初始化的`static`变量声明中，其初始化表达式中不能引用`automatic`变量。我们删除变量声明时的初始化表达式，修改如下，我们来分析一下输出结果：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i=0; i<3; i++) begin
      static int local_i; // no explicit initialization
      local_i = i;
      for (int j=0; j<3; j++) begin
        local_i++;
        $display(local_i);
      end
    end
  end
endmodule : test
```

这时，其输出为`1 2 3 2 3 4 3 4 5`，同理，展开循环，其大致与下列代码等价：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    begin
      automatic int i;
      static int local_i;
      i = 0;
      begin
        local_i = i;
        for (int j=0; j<3; j++) begin
          local_i++;
          $display(local_i);
        end
      end
      i = 1;
      begin
        local_i = i;
        for (int j=0; j<3; j++) begin
          local_i++;
          $display(local_i);
        end
      end
      i = 2;
      begin
        local_i = i;
        for (int j=0; j<3; j++) begin
          local_i++;
          $display(local_i);
        end
      end
      i = 3;
    end
  end
endmodule : test
```

以`C`语言作对比，就像`C`语言在函数中声明的静态局部变量一样，该变量在全局数据区（静态区）分配内存，它始终驻留在全局数据区，生命周期直到程序运行结束（**have a static lifetime instead of the lifetime of the call or block**），但注意其作用域（**scope**）依然为局部作用域；该静态局部变量在程序执行到该变量的声明处时被首次初始化，且以后的函数调用不再进行初始化（**only be initialized once on first entry to the call or block**），我们一般在声明时进行初始化（如`static int local_i = 0;`），如果没有显式初始化，则会被程序自动初始化为其默认值（IEEE Std 1800-2017 **Table 6-7** Default variable initial values）。另外，需要注意不要混淆了初始化与赋值，初始化与变量赋值不同，即使是静态变量也可以被多次赋值，但静态变量只会被初始化一次。

## 6. loop with *fork-join* block

如果循环中包含 ***fork-join*** **block**，结果有时可能会和预期不同。同理，我们可以把循环展开，来看看程序的运行过程，这里 ***fork-join*** **block** 包含`fork-join`、`fork-join_any`和`fork-join_none`，我们分别来看。

### 6.1 loop with `fork-join` block

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    for (int i = 0; i < 3; i++)
      fork
        #1 $display("@%0t : %0d", $time(), i);
        #2 $display("@%0t : %0d", $time(), i);
        #3 $display("@%0t : %0d", $time(), i);
      join
    // something
  end
endmodule : test
```

对于`fork-join`块，此时输出结果确定，如下：

```
# @1 : 0
# @2 : 0
# @3 : 0
# @4 : 1
# @5 : 1
# @6 : 1
# @7 : 2
# @8 : 2
# @9 : 2
```

这是因为`fork-join`块会等待其生成的子进程全部完成后才会把控制权交回父进程，所以可以理解为和之前的循环展开 ***begin-end*** **block** 相同，因为在循环控制变量（如示例中的`i`）更新到下一个值之前都将保持不变并等待当前的 ***begin-end*** **block** 或`fork-join`块全部执行完成，区别是 ***begin-end*** **block** 内的子进程顺序执行，而`fork-join`块内的子进程并行执行。上述代码大致与下列代码等价：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    begin
      automatic int i;
      i = 0;
      fork
        #1 $display("@%0t : %0d", $time(), i);
        #2 $display("@%0t : %0d", $time(), i);
        #3 $display("@%0t : %0d", $time(), i);
      join
      i = 1;
      fork
        #1 $display("@%0t : %0d", $time(), i);
        #2 $display("@%0t : %0d", $time(), i);
        #3 $display("@%0t : %0d", $time(), i);
      join
      i = 2;
      fork
        #1 $display("@%0t : %0d", $time(), i);
        #2 $display("@%0t : %0d", $time(), i);
        #3 $display("@%0t : %0d", $time(), i);
      join
      i = 3;
    end
    // something
  end
endmodule : test
```

### 6.2 loop with `fork-join_any` block

而对于`fork-join_any`和`fork-join_none`，则稍有不同，先来看`fork-join_any`块，其描述为 **The parent process blocks until any one of the processes spawned by this fork completes**，那如果`fork-join_any`块中只有一个子进程，则其行为就和`fork-join`块完全相同了，如下示例：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++)
      fork
        #1 $display("@%0t : %0d", $time(), i);
      join_any
  end
endmodule : test
```

输出如下所示：

```
# @1 : 0
# @2 : 1
# @3 : 2
```

同理，将循环展开即可，大致与下列代码等价：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    begin
      automatic int i;
      i = 0;
      fork
        #1 $display("@%0t : %0d", $time(), i);
      join_any
      i = 1;
      fork
        #1 $display("@%0t : %0d", $time(), i);
      join_any
      i = 2;
      fork
        #1 $display("@%0t : %0d", $time(), i);
      join_any
      i = 3;
    end
  end
endmodule : test
```

--------

而对于前文的`fork-join`块中的示例代码，我们直接将`fork-join`更改为`fork-join_any`，此时的`fork-join_any`块中包含了不止一个子进程，如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    for (int i = 0; i < 3; i++)
      fork
        #1 $display("@%0t : %0d", $time(), i);
        #2 $display("@%0t : %0d", $time(), i);
        #3 $display("@%0t : %0d", $time(), i);
      join_any
    // something
  end
endmodule : test
```

此时的输出结果看起来貌似有点困惑：

```
# @1 : 0
# @2 : 1
# @2 : 1
# @3 : 2
# @3 : 2
# @3 : 2
# @4 : 3
# @4 : 3
# @5 : 3
```

实际上，如同上述的`fork-join`块示例代码的等价代码，对于`fork-join_any`，我们依然可以直接将循环展开，得到如下代码（其中注释标注的标签方便我们说明代码的执行顺序）：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    begin
      automatic int i;
      i = 0;
      fork                                     // fork_A
        #1 $display("@%0t : %0d", $time(), i); // A_1
        #2 $display("@%0t : %0d", $time(), i); // A_2
        #3 $display("@%0t : %0d", $time(), i); // A_3
      join_any
      i = 1;
      fork                                     // fork_B
        #1 $display("@%0t : %0d", $time(), i); // B_1
        #2 $display("@%0t : %0d", $time(), i); // B_2
        #3 $display("@%0t : %0d", $time(), i); // B_3
      join_any
      i = 2;
      fork                                     // fork_C
        #1 $display("@%0t : %0d", $time(), i); // C_1
        #2 $display("@%0t : %0d", $time(), i); // C_2
        #3 $display("@%0t : %0d", $time(), i); // C_3
      join_any
      i = 3;
    end
    // something
  end
endmodule : test
```

1. 首先执行到`fork_A`并阻塞，当前变量`i`为`0`，等待任一子进程完成，经过 **1ns**，`A_1`先完成，打印`@1 : 0`并回到父进程，此时后台还有两个进程`A_2`和`A_3`等待被调度
2. 父进程执行到`fork_B`并阻塞，此时变量`i`已经变为`1`，同时产生了三个子进程`B_1`、`B_2`和`B_3`，又经过 **1ns**，`A_2`和`B_1`被调度，所以打印两条`@2 : 1`，此时后台还有三个进程`A_3`、`B_2`和`B_3`等待被调度
3. 由于`B_1`完成，`fork_B`回到父进程并执行到`fork_C`，又产生了三个子进程`C_1`、`C_2`和`C_3`，此时变量`i`已经变为`2`，又经过 **1ns**，此时`A_3`、`B_2`和`C_1`被调度，所以打印出三条`@3 : 2`，此时后台还有三个进程`B_3`、`C_2`和`C_3`等待被调度
4. 由于`C_1`完成，`fork_C`回到父进程，然后循环控制变量`i`变为`3`，不再满足循环条件，所以退出`for`循环，而此时后台还有三个进程`B_3`、`C_2`和`C_3`等待被调度，又经过 **1ns**，`B_3`和`C_2`被调度执行，所以打印出两条`@4 : 3`，再经过 **1ns**，`C_3`被调度执行，所以最后打印出`@5 : 3`，仿真结束

--------

那么如何使上述的`fork-join_any`块示例代码输出 3 个 `0`、3 个 `1` 以及 3 个 `2`？参考前文的 ***begin-end*** **block** 例程，相似的，我们依然可以在 ***fork-join*** **block** 中使用`automatic`变量来在块内对循环变量`i`做本地拷贝，如下示例所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    for (int i = 0; i < 3; i++)
      fork
        // local copy, local_i, for each value of i
        automatic int local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
    // something
  end
endmodule : test
```

此时的输出结果如下所示：

```
# @1 : 0
# @2 : 0
# @2 : 1
# @3 : 0
# @3 : 1
# @3 : 2
# @4 : 1
# @4 : 2
# @5 : 2
```

按照了我们的预期，输出了 3 个 `0`、3 个 `1` 以及 3 个 `2`，且时序与之前分析的`fork-join_any`块示例完全相同，这里不再次分析，其执行过程大致等价于如下代码：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    begin
      automatic int i;
      i = 0;
      fork
        // local copy, local_i, current value of i is 0
        automatic int local_i = i; // local local_i is 0
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 1;
      fork
        // local copy, local_i, current value of i is 1
        automatic int local_i = i; // local local_i is 1
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 2;
      fork
        // local copy, local_i, current value of i is 2
        automatic int local_i = i; // local local_i is 2
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 3;
    end
    // something
  end
endmodule : test
```

在这里，之所以对循环控制变量`i`的本地拷贝有效，是因为在程序进入到一个 block 或者 scope 时，会首先对该 scope 内的变量声明进行处理，如果变量声明包含显式的初始化，会进行相应的初始化，否则将被初始化为默认值。可以理解为，不同于程序性的代码，声明性的代码全都是在进入当前的 scope 时被并行的优先处理，且这一过程没有开销（比如无法打断点，也不会产生子进程）。

行文至此，实际上这里还有两点值得我们注意：

1. 注意*在变量声明时显式初始化*以及*对变量先声明再赋值*之间的区别
2. 关于在 ***fork-join*** **block** 内使用静态变量的问题（注意静态变量的生命周期）

其实在先前的循环与 ***begin-end*** **block** 示例中也出现了这两类问题，只不过由于其顺序执行的特性使得结果很容易分析，因而没有特别说明；但是在 ***fork-join*** **block** 中稍不注意就有可能会出现意料之外的结果，因而在这里有必要分别就这两点再做如下示例说明。

--------

关于第 1 点，如果不是在变量声明时进行显式初始化，而是先声明再有赋值语句，如下示例所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    for (int i = 0; i < 3; i++)
      fork
        // local copy, local_i, for each value of i
        automatic int local_i; // default initialization
        local_i = i;           // assignment statement
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
    // something
  end
endmodule : test
```

该程序的输出结果如下所示：

```
# @1 : 2
# @1 : 1
# @1 : 0
# @2 : 2
# @2 : 1
# @2 : 0
# @3 : 2
# @3 : 1
# @3 : 0
```

在这里想说明的是，要**注意**：***fork-join*** **block** 也会为**一条赋值语句开辟一个子进程**，但是**变量声明不会产生进程**（即使是带初始化表达式的变量声明）。其实会发现，同`C`语言相同，比如我们在仿真时也可以单步执行，会看到程序指针总是会直接跳过变量声明。还是写出该程序的大致等价代码来进行解释，如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    begin
      automatic int i;
      i = 0;
      fork           // <--------------------------------+
        automatic int local_i; //                        |
        local_i = i; // <--------------------------------+  A0
        #1 $display("@%0t : %0d", $time(), local_i); //  |  A1
        #2 $display("@%0t : %0d", $time(), local_i); //  |  A2
        #3 $display("@%0t : %0d", $time(), local_i); //  v  A3
      join_any       // <--------------------------------+
      i = 1;         //                                  |
      fork           // <--------------------------------+
        automatic int local_i; //                        |
        local_i = i; // <--------------------------------+  B0
        #1 $display("@%0t : %0d", $time(), local_i); //  |  B1
        #2 $display("@%0t : %0d", $time(), local_i); //  |  B2
        #3 $display("@%0t : %0d", $time(), local_i); //  v  B3
      join_any       // <--------------------------------+
      i = 2;         //                                  |
      fork           // <--------------------------------+
        automatic int local_i; //                        |
        local_i = i; // <--------------------------------+  C0
        #1 $display("@%0t : %0d", $time(), local_i); //  |  C1
        #2 $display("@%0t : %0d", $time(), local_i); //  |  C2
        #3 $display("@%0t : %0d", $time(), local_i); //  v  C3
      join_any       // <--------------------------------+
      i = 3;
    end
    // something
  end
endmodule : test
```

之前示例，每个`fork-join_any`块产生 3 个子进程（即 3 条带延时控制的 display 语句），而现在每个`fork-join_any`块包含了 4 个子进程（我们这里多出了一条没有添加时延的赋值语句），结果其执行过程依次是：

1. 进入第一个`fork-join_any`块，赋值语句`local_i = i;`立即被调度执行，由于该进程（`A0`）不耗时，所以执行完成并返回到父进程，此时后台已有三个子进程（`A1`、`A2`和`A3`）在等待被调度执行
2. 进入第二个`fork-join_any`块，然后同上，同理，一直执行到循环变量`i`为 3，退出循环，此时后台有 9 个子进程 `A1`、`A2`、`A3`、`B1`、`B2`、`B3`、`C1`、`C2`和`C3`在等待被调度执行
3. 经过 **1ns**，`A1`、`B1`和`C1`同时被调度执行，且他们之间的顺序是不确定的（Nondeterminism）：我在 Questa Sim 仿真测试中其执行顺序是 `C1`-`B1`-`A1`，所以打印结果是`@1 : 2`-`@1 : 1`-`@1 : 0`；而在 VCS 仿真测试中其执行顺序是 `A1`-`B1`-`C1`，所以打印结果是`@1 : 0`-`@1 : 1`-`@1 : 2`
4. 又经过 **1ns**，`A2`、`B2`和`C2`同时被调度执行；同理，再经过 **1ns**，`A3`、`B3`和`C3`同时被调度执行，最后仿真结束

实际上，这里我们使用的是`fork-join_any`块，本意是要等待 3 条带延时控制的 display 语句其中任意一个子进程执行完成后才返回控制权进入下一轮循环，但由于赋值语句的存在，其最终表现的行为同`fork-join_none`相同，因为赋值语句也同样会产生一个子进程，且这里没有添加延时或其他阻塞语句。所以，如果单纯想在 ***fork-join*** **block** 中对外部变量做本地拷贝，请直接在变量声明时显式进行初始化即可。

最后，再次总结，在 ***fork-join*** **block** 中，我们一定要注意**声明变量并初始化**及**赋值语句**之间的区别。由`fork`产生的各个子进程是并行执行的，而一条赋值语句也是一个普通的子进程，和其他子进程一样等待被调度执行；但对于变量声明，并不会产生进程，只要执行到`fork`，当前 ***fork-join*** **block** 中的所有变量声明都将立即被处理，同时，如果变量声明时伴随着显式的初始化值表达式，该变量也会被正确初始化，否则被初始化为其默认值（IEEE Std 1800-2017 **Table 6-7** Default variable initial values）。实际上，包括 ***begin-end*** **block** 和 ***fork-join*** **block**，甚至是任何的 **scope**，当程序执行进入到该 **scope** 内时，都会首先对 **scope** 内的所有变量声明进行初始化，但会忽略其内部嵌套的 **scope** 内的变量声明，除非程序执行再次进入到内部嵌套的 **scope** 内时才会对该 **scope** 内的变量声明进行初始化。

--------

关于第 2 点，现在再来说明一下在 ***fork-join*** **block** 内使用静态变量的问题，如果还是想让`fork-join_any`块示例代码输出 3 个 `0`、3 个 `1` 以及 3 个 `2`，能否使用静态变量来做本地拷贝呢？如下代码所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    for (int i = 0; i < 3; i++)
      fork
        static int local_i;
        local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
    // something
  end
endmodule : test
```

此时的输出结果如下所示：

```
# @1 : 2
# @1 : 2
# @1 : 2
# @2 : 2
# @2 : 2
# @2 : 2
# @3 : 2
# @3 : 2
# @3 : 2
```

首先，在前文我们已经介绍过，**static** 变量的初始化表达式中不能引用 **automatic** 变量，所以这里使用静态变量时，只能先声明，然后再通过赋值语句来做本地拷贝，这同时又回到了上一个讨论问题，请阅读在上一个示例中的具体说明；其次，为什么最后`local_i`都是 2，实际上就是 **static** 变量与 **automatic** 变量的区别，即生命周期及作用域的问题，在前文中也都有示例介绍和说明，这里不再赘余，我们还是直接展开其具体的执行过程来进行解释说明吧，其大致如下所示，只要阅读代码即可理解其输出结果：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    // something
    begin
      automatic int i;
      static int local_i;
      i = 0;
      fork
        local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 1;
      fork
        local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 2;
      fork
        local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_any
      i = 3;
    end
    // something
  end
endmodule : test
```

你可能会发现，在以上所有包含 **static** 变量声明的示例中，我们在分析大致执行过程时，都将 **static** 变量的声明放在了与多个 **block** 并列的 **scope** 中，这实际上是为了模拟 **static** 变量的 **scope** 和 **lifetime**，且 **static** 变量只会被初始化一次。在 **scope and lifetime** 小节中，使用了多次 **entry of the call or block**，实际上这就可以大致与`C`的函数调用做类比，只不过在`C`中只有函数，而我们这里有 **call** : { **function** & **task** } 以及 **block** : { ***begin-end*** **block** & ***fork-join*** **block** }，所以除了 **call** 以外，我们每次进入一个 **block**，也可以大致理解成进行一次`C`的函数调用，所以除了 **function** 和 **task**，我们在 **block** 中的 **static** 变量也可以大致等价于`C`函数内的静态局部变量。有了这些类比，如果你也熟悉`C`，那么对上述所有示例的理解也将更加清晰。例如此示例，在 ***fork-join*** **block** 中使用了静态变量，使该 **block** 不可重入【请参考**可重入函数**（**reentrant function**）的概念】，尤其是对于`fork-join_any`和`fork-join_none`，在循环中定义`fork-join_any`或`fork-join_none`块时，我们一般是希望该 **block** 是可重入的，所以不要在其内部使用静态变量，换言之，在并发线程中（***fork-join*** **block**）声明变量时，请务必要使用 **automatic** 变量来保存数值（当然同理，在 ***begin-end*** **block** 中最好也如此），除非你明确知道你正在做什么。

### 6.3 loop with `fork-join_none` block

最后，我们再来看`fork-join_none`块，其描述为 **The parent process continues to execute concurrently with all the processes spawned by the fork. The spawned processes do not start executing until the parent thread executes a blocking statement or terminates**. 其中注意第二句，不同于`fork-join`和`fork-join_any`，他们遇到`join`或`join_any`关键字时，由`fork`产生的子进程都开始被调度执行；而对于`fork-join_none`，当遇到`join_none`关键字时，立即将控制权交回父进程，但此时由`fork`产生的子进程并未立即开始被调度执行，而是要等到父进程继续执行到一条阻塞语句或者父进程终止时，这些子进程才开始被调度执行。举个简单的示例，如下所示：

```verilog
`timescale 1ns/1ns

module test;
  int m;
  initial begin
    fork
      m = 0;
      #0 $display("@%0t : %0d", $time(), m);
    join_none
    m = 1;
    $display("@%0t : %0d", $time(), m);
  end
endmodule : test
```

该程序将总会输出`1 0`，因为进入`fork`后，创建了两个子进程，然后遇到`join_none`关键字，返回到父进程继续执行，但此时由`fork`创建的两个子进程并没有立即开始执行，父进程继续执行，先后执行了`m = 1;`和`display`语句，打印出了`1`，由于这两条语句都不会产生阻塞，所以此时由`fork`创建的两个子进程还未开始执行，直到`begin-end`块结束，父进程终止，这两个子进程才开始并行执行，又由于`#0`的存在，在这两个并行的子进程中，`display`进程总是在`m = 0;`进程之后才被调度执行，所以又打印出了`0`。

在理解了前文中的各个示例后，那么对循环中包含`fork-join_none`的执行过程应该也是很清晰的，所以直接来看一个示例吧，代码如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++)
      fork
        // local copy, local_i, for each value of i
        automatic int local_i = i;
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
  end
endmodule : test
```

在 Questa Sim 仿真中，输出结果如下所示：

```
# @1 : 2
# @1 : 1
# @1 : 0
# @2 : 2
# @2 : 1
# @2 : 0
# @3 : 2
# @3 : 1
# @3 : 0
```

其执行过程大致与下列代码一致：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    begin
      automatic int i;
      i = 0;
      fork
        automatic int local_i = 0; // initialization
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
      i = 1;
      fork
        automatic int local_i = 1; // initialization
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
      i = 2;
      fork
        automatic int local_i = 2; // initialization
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
      i = 3;
    end
  end
endmodule : test
```

每次进入`fork`块，首先对块内声明的变量进行初始化，然后创建子进程，一直到遇到`join_none`关键字，直接返回到父进程并继续执行，最后开始执行子进程：在 **1ns** 时，有三个子进程同时被调度执行，其先后顺序不确定（在 SV 的仿真调度语义中属于是 Nondeterminism 的），不同的仿真器可能有不同的输出结果，比如，在 Questa Sim 仿真测试中输出`@1 : 2 1 0`，而在 VCS 仿真测试中输出`@1 : 0 1 2`；之后在 **2ns** 及 **3ns** 时，同理。

### 6.4 loop with block 的对比总结

如果对比总结 ***begin-end*** **block** 和 ***fork-join*** **block**，实际上都可以把 **block** 类比成`C`中的函数来理解。每次进入 **block**，都首先对 **block** 内声明的变量进行初始化（注意：对于 **static** 变量声明，只有首次进入 **block** 时才对变量进行初始化），需要注意其生命周期，而后：

- 如果是 ***begin-end*** **block**，则直接顺序执行块内的语句（statement）
- 如果是 ***fork-join*** **block**，则只对块内的语句（statement）创建子进程，并不立即执行
  - 对于`fork-join`块，直到遇到`join`关键字，此时块内的所有子进程已被创建，这些子进程才开始并行执行，并且父进程在此处被阻塞，要等待这些子进程全部完成后才继续执行
  - 对于`fork-join_any`块，直到遇到`join_any`关键字，此时块内的所有子进程已被创建，这些子进程才开始并行执行，并且父进程在此处被阻塞，要等待这些子进程中的任一子进程完成后才继续执行，这时剩余的子进程将继续在后台同父进程一起并行执行
  - 对于`fork-join_none`块，直到遇到`join_none`关键字，此时块内的所有子进程已被创建，但这些子进程并不是立即开始并行执行，且父进程**不**在此处被阻塞，而是直接继续执行，直到遇到了阻塞语句或终止时才开始并行执行这些子进程，到这时所有的子进程和父进程是一起并行执行的关系

--------

## 7. Supplement

在 IEEE Std **9.3.2** Parallel blocks 中有说明：**Variables declared in the block_item_declaration of a fork-join block shall be initialized to their initialization value expression whenever execution enters their scope and before any processes are spawned.**

我们有示例代码如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++)
      fork
        // something
        begin
          automatic int local_i = i;
          #local_i $display("@%0t : %0d", $time(), local_i);
        end
        // something
      join_none
  end
endmodule : test
```

那么，这里`local_i`的值是不确定的，或者说这里`local_i`对变量`i`的本地拷贝并不符合预期，没有正确的保存变量`i`的数值，该程序的输出结果如下所示：

```
# @3 : 3
# @3 : 3
# @3 : 3
```

在这里，我们只是补充了一个示例说明。实际上，我们在前文全都已经介绍说明过：

1. 只有当程序执行进入到 **scope** 内时，才会对 **scope** 内声明的所有变量进行初始化
2. `fork`创建 ***fork-join*** **block** 内的各个子进程的同时并没有执行子进程

所以此示例中`fork-join_none`块内只创建了一个子进程，但创建子进程并不是调度执行该子进程，所以实际上程序还没有执行进入到该`begin-end`块内，自然不会对`begin-end`块内的变量声明进行初始化，等到创建的子进程开始执行时，程序才真正会进入到`begin-end`块内并对块内声明的所有变量进行初始化，而此时变量`i`的值，相对于在创建子进程的时刻，已经发生了改变。

我们只需要在 ***fork-join*** **block** 内做本地拷贝即可，如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++)
      fork
        automatic int local_i = i;
        // something
        begin
          #local_i $display("@%0t : %0d", $time(), local_i);
        end
        // something
      join_none
  end
endmodule : test
```

此时程序的输出结果如下所示：

```
# @0 : 0
# @1 : 1
# @2 : 2
```

除此之外，我们还可以在各个子进程中对`local_i`再做本地拷贝，以此来隔离各个子进程对`local_i`的更改，示例如下所示：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++)
      fork
        automatic int local_i = i;
        // something ...
        begin
          // local copy, process_i, for value of local_i
          // do not copy from i, otherwise, the value of process_i is undetermined
          automatic int process_i = local_i;
          #process_i $display("@%0t : %0d", $time(), process_i);
          // we can access or modify variable process_i here
          // ... ... use process_i here
        end
        begin
          automatic int process_i = local_i; // this is ok
          // ... ... use process_i here
        end
        // something ...
      join_none
  end
endmodule : test
```

--------

除了直接在 ***fork-join*** **block** 内做本地拷贝，我们经常还会见到如下写法：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++) begin
      automatic int local_i = i;
      fork
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
    end
  end
  // Previous Example :
  // --------------------------------------------------
  // initial begin
  //   for (int i = 0; i < 3; i++)
  //     fork
  //       automatic int local_i = i;
  //       #1 $display("@%0t : %0d", $time(), local_i);
  //       #2 $display("@%0t : %0d", $time(), local_i);
  //       #3 $display("@%0t : %0d", $time(), local_i);
  //     join_none
  // end
  // --------------------------------------------------
endmodule : test
```

请对比理解这两种写法，做一个简单说明，这里就是多了一层 **scope**，在`fork-join_none`的外部再套了一个`begin-end`，此时，`automatic int local_i = i;`将可以从`fork-join_none`块中拿出来，那么变量`i`将在上一层的 **scope** 中被保存，相比于之前的示例，现在每次循环时程序会首先顺序执行`begin-end`块内`fork`之前的所有语句，这样的好处是不只限于本地变量的声明及初始化语句，我们在创建并行的子进程之前，也可以执行一些其他的程序，比如配置环境等等，如下一个简单示例：

```verilog
`timescale 1ns/1ns

module test;
  initial begin
    for (int i = 0; i < 3; i++) begin
      automatic int local_i = i;
      $display("@%0t : before creating the child process.", $time());
      // Any statement, to write something as an example
      local_i++;
      if (local_i > 2)
        local_i = 0;
      // You can also do some other things here
      // ... ... ...
      // Statements shall be executed in sequence
      // ... ... ...
      $display("@%0t : start creating the child process.", $time());
      fork
        #1 $display("@%0t : %0d", $time(), local_i);
        #2 $display("@%0t : %0d", $time(), local_i);
        #3 $display("@%0t : %0d", $time(), local_i);
      join_none
    end
  end
endmodule : test
```

<div class="post-contents-active"></div>
