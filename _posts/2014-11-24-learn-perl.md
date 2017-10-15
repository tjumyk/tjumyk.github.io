---
layout: post
title: Perl学习笔记
description: "随便整理下Perl语言的学习笔记"
modified: 2014-11-28
tags: Perl
image:
  feature: learn_perl.jpg
  thumbnail: learn_perl_thumbnail.jpg
comments: true
share: true
---

考试结束有1周了，这7天感觉过得飞快。说实话玩得不少，不过断断续续看完了一本Perl教材，也算比较充实。
Perl给我的感觉是：灵活实用，但正因为太灵活，感觉程序规模上去后，代码很容易变得ugly。
它的语法上有很多琐碎的规则，过了一遍书上内容后，感觉忘了不少，所以在此简单总结一下。

---------------------



# 一、概述

## 1.1 定义

> Perl = **P**ractical **e**xtraction and **r**eport **l**anguage

## 1.2 Perl的核心特征

1. 隐式变量
: Perl中有的函数带有可选参数，当该忽略该参数时，隐式变量会起作用。
2. 函数与操作符可互换
: Perl中函数与操作符没有明显区别，形式上可以互相转换。
3. 数就是一种数
: Perl中的数只有一种类型：double，字面值数字也会隐式地转换成double值。
4. 变量是隐式声明的
: 变量在使用前不需要先声明。
5. 字符串和数
: 字符串（或数字）作为参数传入函数时，会根据上下文隐式地转换成数字（或字符串）。
6. Scala和list上下文
: Scala类型（或list类型）作为参数传入函数时，会根据上下文隐式地转换成list类型（或scala类型）。
7. 一个功能可以有多种实现
: 针对同一个问题，Perl可能提供了从简单到复杂的不同实现方式，初学者往往更喜欢使用简单但可能繁琐的方式。
8. 没有不必要的限制
: Perl语言设计为取消所有可能的限制。例如字符串和数组的长度是没有限制的，并且根据需要隐式地增长。当然实际机器的内存限制了可以达到的最大长度。

# 二、Scala类型，表达式和简单的输入输出

## 2.1 Scala字面值

### 2.1.1 数值字面值

默认情况下，Perl中绝大多数的数值数据都是以double（双精度浮点数）形式保存的。（代码中还是可以使用整数字面值的，只是最终保存时以double形式保存）

{% highlight perl %}
# Perl中#后面的内容为注释
37 3.7 .37 37. 3E7 3e7 .3E7 3.E7 3E-7  # 整数和浮点数（此处highlighter被调戏，求放过）
0x2aff 0xAA3  # 十六进制整数
0276 077      # 八进制整数
3_296_429     # 数字中间可以插入下划线来增强可读性，同3296429
{% endhighlight %}

### 2.1.2 字符串字面值

{% highlight perl %}
'poopsie'
'apples are good\t'       # 单引号内不支持转义，所以\t不是tab，而是\和t两个字符
'Wouldn\'t it be lovely?' # 除了\'用于插入一个单引号（另外\\表示一个\）
'good
bye'                      # 支持多行，共8个字符，包括内嵌的换行符

'can\'t, won\'t, wouldn\'t ever!'  # 这里所有单引号都得转义，比较麻烦
q^can't, won't, wouldn't ever!^    # q^表示改用^作为当前单引号字符串的分隔符，简化了代码的书写
q(Is Perl more fun than baseball?) # 其他例子
q[Well, maybe not.]

"Quantity \t Price \t Total \n\n"     # 双引号内支持转义，这里的\t才是一个Tab
"The dog replied, \"wuff!\""          # \"用于插入双引号
qq*"Definitely not!", she answered.*  # qq*表示改用*作为当前双引号字符串的分隔符，简化书写
{% endhighlight %}

## 2.2 Scala变量

所有Scala变量都以`$`开头，后面接上一个包含字母、数字和下划线的字符串，区分大小写，规则类似于C等语言对变量名的限定。

Scala变量并没有具体的类型声明，任何一个scala变量都可以存储数值、字符串或者内存位置的引用（相当于C的指针）。当一个Scala变量在代码中首次出现时（在没有显式定义的情况下），编译器会隐式地定义它，并且所有隐式定义的变量都是当前Perl程序的全局变量。我们也可以显式地定义一个变量，这将在后面涉及。

Perl中自带了许多隐式定义的变量，其中许多为scala变量。隐式定义的变量常常作为特定操作符的默认操作数，其中最常见的一个是`$_`。

如果一个Scala变量没有被显式赋值，其值为`undef`，在参与数值运算时会隐式转换为0，所以使用未赋值的变量也不会导致运行时错误。

{% highlight perl %}
# 字符串内的Scala变量会被解释，如果此处$name的值是bob，则此字符串会被解释为：
# "Apples are good for bob"
"Apples are good for $name" 
# 如果不希望解释变量，可以加上\
"Apples are good for \$name"
# 如果双引号内嵌单引号，$money仍然会被解释，因为外层限定符（也就是双引号）决定了字符串的行为
"The boy sent the message, 'Help, end $money'" 
# 如果单引号内嵌双引号，$money不会被解释，因为外层限定符（也就是单引号）决定了字符串的行为
'The boy sent the message, "Help, end $money"' 
# 如果字符串内的变量名后需要紧跟别的字符，可以用花括号{ }括上变量名，假如这里$day的值为Mon，
# 则此字符串会被解释为："Today is Monday"
"Today is ${day}day"
{% endhighlight %}

## 2.3 Scala操作符

### 2.3.1 算术操作符

Perl支持的算术运算符与C很相似，它们都提供了基本运算符 `+` `-` `*` `/` `%` ，二进制运算符 `&` `|` `～` `^` `>>` `<<` ，以及自增`++`自减`--`运算符
不同点在于：

1. `%`和二进制运算符会将操作数隐式转换成整数后再进行计算（转换是截取整数部分，而不是四舍五入）
2. Perl提供了重复操作符`x`（小写字母x），用于重复字符串，后面会涉及。它的右操作数是数字，该数会被隐式转换成整数
3. Perl还提供了指数运算符`**`，作用同C里的pow函数
4. 包括`**`在内的其他操作符都会将其所有操作数隐式转换成double类型再进行计算

{% highlight perl %}
5 / 2      # = 2.5
7.86 % 3   # = 1
3 ** 2     # = 9
{% endhighlight %}

### 2.3.2 算符优先级

与C类似

### 2.3.3 字符串操作符

{% highlight perl %}
$str . "Holidays!"     # 连接字符串
"Happy! " x 3          # 重复字符串整数次，即"Happy! Happy! Happy! "
{% endhighlight %}

### 2.3.4 字符串函数

函数名 | 参数 | 操作
--- | --- | ---
chop | string | 删除并返回最后一个字符
chomp | string | 删除尾部的记录分隔符（如果有的话），默认的记录分隔符是换行，且适用不同系统环境
length | string | 返回字符串长度
lc | string | 字符全部转换为小写
uc | string | 字符全部转换为大写
ord | string | 返回第一个字符的ASCII数值
hex | string | 将十六进制字符串转换为对应数值
oct | string | 将八进制字符串转换为对应数值
index | 两个string | 返回第二个字符串在第一个字符串中的位置
rindex | 两个string | 类似index，但返回从右边开始的位置
substr | 一个string和两个数值 | 提取并返回字符串中从第一个数的位置开始到第二个数位置的子串
join | 一个字符和一个list | 将list中的字符串连接在一起，形成一个长串，并用给定的字符来分隔每个子串

### 2.3.5 混合模式表达式

如果一个表达式中，二元操作符两边的操作数是不同的类型，这个表达式为混合模式表达式。该表达式中，操作符定义了所需的参数类型，如果类型不一致，会发生隐式的类型转换。其中，数值转换成字符串相当于把数值打印到字符串中；而字符串转数值则会去掉头部空白符和尾部非数字字符，然后尝试将剩下的部分转换为对应数字，如果转换失败，则返回数字0。

{% highlight perl %}
7 + $str  # 如果$str的值为" 32abc"，会隐式转换为数值32，结果为数值39
7 + $str  # 如果$str的值为"alpha32"，会隐式转换为数值0，因为去掉头部空白符和尾部非数字字符后，
          # 剩下的部分无法转换为数值。所以结果为数值7
7 . $str  # 如果$str的值为" 32abc"，结果为字符串"7 32abc"
- $str    # 如果$str的值为" 32abc"，结果为数值-32
{% endhighlight %}

### 2.3.6 赋值语句

类似C中的定义，并且Perl中也支持复合赋值符，所有二元数值、字符串和布尔运算符（后面会涉及）都支持转换为对应的复合赋值符，例如`+=` `-=` `*=` `/=` ...

## 2.4 简单键盘输入和屏幕输出

Perl中输入输出都和一种特殊变量：文件句柄有关。标准输入（即键盘）和标准输出（即屏幕）都是文件，Perl中提供了对应的文件句柄`STDIN`和`STDOUT`。我们可以通过行输入操作符`<>` 来一行一行地从某个文件句柄中读入内容，并且可以通过`print`/`printf`函数输出字符串到屏幕上。因为Perl中函数和操作符可互换，所以`print`/`printf`也可以以操作符的形式进行调用。另外，Perl也支持`sprintf`将格式化文本输出到字符串中。

{% highlight perl %}
# Perl中完整的一个语句必须以;结束（除了区块中的最后一句语句可以省略;）
chomp($new_input = <STDIN>); # 从键盘读入一行字符串，存入$new_input并且去除末尾的换行符
print "Isn't this fun?\n";                   # 操作符方式调用print
print("That may be an overstatement!\n");    # 函数方式调用print
# 可以输出带有变量的字符串。print函数还可以接受多个字符串，它们会被逐个输出
print("The sum is: $sum", "\tThe average is: $average\n") 
{% endhighlight %}

## 2.5 运行Perl程序

{% highlight  Bash shell scripts %}
# 以下命令是shell指令，$为命令提示符
$ perl circle.pl  # 运行Perl脚本文件
$ perl -e 'print "Is this easy enough? \n";' # 直接执行单个Perl语句
$ perl   # 以交互方式运行，一行一行地输入并执行
print "Well, ok! \n";
print "This is also easy! \n";
<EOF> # 文件终结符，例如在Unix系统下，按下Control+D

$ perl -c circle.pl    # 解释并验证Perl脚本，但不执行
$ perl -w rectangle.pl # 显示警告信息，便于及早发现可能存在的bug
{% endhighlight %}

# 三、控制语句

## 3.1 控制表达式

### 3.1.1 简单控制表达式

简单控制表达式就是一个算术表达式或者一个字符串表达式。简单控制表达式的值根据以下规则进行解释：

1. 如果它是字符串表达式，那么其值为true，除非它是空字符串或者字符串"0"
2. 如果它是算术表达式，那么其值为true，除非它的值为0

那么，未定义的变量一定为false，因为未定义的数字会被解释为0，未定义的字符串会被解释为空字符串。
注意，"0.0"看起来像0，但是由于它不是"0"，所以它的值为true。

### 3.1.2 关系表达式

用于比较两个字符串或者数值的大小关系，包含了一个关系操作符（如下表）。它的值如果为ture，返回数字1；如果为false，则返回空字符串。关系操作符在运算时一定会隐式地转换参数类型。

比较类型 | 数值比较 | 字符串比较
--- | --- | ---
相等 | == | eq
不等 | != | ne
小于 | < | lt
大于 | > | gt
小于或等于 | <= | le
大于或等于 | >= | ge

示例如下：

{% highlight perl %}
"fruit" eq 7    # 7会被隐式转换为"7"
"27" gt "3"     # 由于这里是字符串比较，"3"的ASCII值比"2"大，所以结果为false
"boy" == "girl" # 由于这里是数值比较，"boy"和"girl"都被转换为0，所以结果为true
{% endhighlight %}

与C类似，关系操作符不具有连接性，所以不能使用`$a < $b < $c`这样的表达式。

### 3.1.3 复合表达式

由scala变量、scala字面值、关系表达式和布尔操作符组成。布尔操作符类似C里的定义，包括`&&` `||` 和 `!`，具有短路效应。另外Perl提供了一组类似的操作符`and` `or` `not`，唯一的区别在于更好的可读性和更低的算符优先级，并且事实上，它们的优先级比其他任何Perl操作符的优先级还要低。

注意所有二元布尔操作符都可以与等号连接，形成复合赋值操作符。例如：

{% highlight perl %}
$a ||= $b;
{% endhighlight %}

## 3.2 选择语句

{% highlight perl %}
# 类似C
if($a > $b){
    print "\$a is greater than \$b \n";
}else{
    print "\$a is not greater than \$b \n";
}

# 可以省去else部分
if($a > $b){
    print "Largest: $a \n";
}

# 也可以写成一行 
if($a > $b){ print "Largest: $a \n"; }

# unless与if恰恰相反，在控制表达式为false的时候才执行里面的语句
unless (($count < $limit) or $nolimit){
    print "I simply cannot go on! \n";
}

# 可以使用elsif连接多个分支，注意不是"elseif"，也不是"else if"
if($age < 18){
    print "You're just a kid! \n";
}elsif($age < 40){
    print "Not a kid, but still young \n"
}elsif($age < 65){
    print "Middle aged, hub? \n";
}else{
    print "You're now in the \"Golden Age\", right? \n";
}

# 条件表达式，类似C
$average = ($number != 0) ? $num / $number : 0;

# 如果条件表达式的then表达式和else表达式都具有左值，那么整个条件表达式可以放在复制语句的等号左边
(($next > 0) ? $positives : $negatives) += $next;
{% endhighlight %}

## 3.3 迭代语句

{% highlight perl %}
# 类似C的while
$sum = 0;
while($sum <= 1000){
    $sum += <STDIN>; # 这里从键盘读入一行字符串，并隐式转换成了数值，加到了$sum中
}

# until与while恰恰相反，当控制表达式为false时执行循环体，直到条件为true结束循环
until($sum > 1000){
    $sum += <STDIN>;
}

# 类似C的for
for($count = 0 ; $count < 10; $count++){
    $sum += <STDIN>;
}

# 类似C的逗号分隔表达式，其整体结果为最后一个表达式的值
$x = ($a = 7, $b = 10, $c = -2);

# 由此，我们可以在for结构中的初始化或更新多个变量
for($forward = 0, $backward = 10;
    $forward < 10;
    $forward++, $backward--){
    # 循环体
}
{% endhighlight %}

## 3.4 区块跳转

与C类似，Perl中提供了如下区块跳转的操作符，便于对循环结构进行更灵活的控制：

操作符 | 相当于C的关键字 | 作用
--- | --- | ---
next | continue | 停止当前迭代，并跳转到控制表达式，如果表达式仍为true，继续下次迭代
last | break | 跳出当前循环体，并开始执行循环体下面的第一条语句
redo | 无 | 停止当前迭代，并跳转到循环体的第一个语句，注意不会再次运算控制表达式，谨慎使用

这些操作符支持加上一个标签名作为唯一参数，这会在该标签对应的循环结构上执行相应的跳转。

{% highlight perl %}
OUTER: # 为外层for循环加上标签
    for($a = 0; $a < 100; $a++){ 
        for($b = 0 ; $b < 100; $b++){
            $product = $a * $b;
            if($product > 1000){
                last OUTER;  # 不加参数仅能跳出最内层循环体，加上参数后则可以跳出外层for循环
            }else{
                print "Next product is $product \n";
            }
        }
    }
{% endhighlight %}

## 3.5 语句修饰符

条件操作符和循环操作符还可用于构造语句修饰符。语句修饰符可添加到单个语句的末尾，以对其行为进行控制。

{% highlight perl %}
$bob++ if $wor eq "bob"; # 先检测if条件，如果为true，才会执行被修饰的语句
$sum *= 2 until $sum > 1000; # 先检测until条件，如果为true，循环执行被修饰语句，直到条件为false
{% endhighlight %}

注意无论是采用普通的循环结构，还是使用这样的语句修饰符来构造循环，它们都是前测循环，意味着逻辑上都是先检测条件，再执行循环体。

要实现后测循环，也就是先执行循环体再检测条件，需要使用do块，并在它的后面接上包含循环操作符的语句修饰符。

{% highlight perl %}
# 该程序以循环形式连续地读取从键盘输入的字符串，统计bob的数量，直到输入的字符串为～时程序结束
$chomp($word = <STDIN>);
do{
    $bob++ if $word eq "bob";
    chomp($word = <STDIN>);
}until $word eq "~"; # 先执行循环体，然后检测条件
{% endhighlight %}

## 3.6 停止执行

{% highlight perl %}
# 如果参数字符串末尾没有换行符，系统会自动加上更多调试信息（例如程序名称、行号）和换行符
# 如果参数字符串末尾有换行符，调试信息则不会自动加上
die "The input file is empty!"; 

# 如果一个系统函数调用失败，其错误码会保存在$!中，所以$!一般会出现在die的参数中
die "Input/output function error $!";

# 如果你想让程序直接退出，而不提供额外信息，可以使用error，其参数为程序最终返回的错误码，0表示正常退出
exit 0;
{% endhighlight %}

## 3.7 更多输入相关

结合行输入操作符和控制表达式，我们可以连续读入多行数据。由于Perl的许多内置函数支持默认参数，当省略参数时，会使用隐式参数执行操作，所以下面的代码显得十分简洁。另外，当`<>`操作符读到EOF时，会返回空字符串，作为控制表达式的话，即为false。

{% highlight perl %}
while(<STDIN>){ # STDIN读入的内容隐式地赋值给$_
    print; # 使用$_作为默认参数
    chomp; # 使用$_作为默认参数
    if($_ eq "money"){
        print "I've finally found it!!! \n";
    }
}

# <>操作符不提供参数时：
#   1. 如果程序提供了命令行参数时，它会使用命令行参数中提供的文件名获取文件句柄
#      ，逐行读取，如果有多个参数，会按顺序读取对应文件
#   2. 如果程序没有得到命令行参数，它会转而从STDIN读入，即从键盘读入
while(<>){ # 从文件或STDIN读入的内容隐式地赋值给$_
    print; # 使用$_作为默认参数
}
{% endhighlight %}

## 3.8 调试器

{% highlight Bash shell scripts %}
$ perl -d example.pl # 启动调试器，使用交互式的命令行进行调试
{% endhighlight %}

Perl调试器的用法类似于GDB，以下列出主要的几个指令：（*斜体*为指令参数）

指令 | 解释 | 行为
--- | --- | ---
n | next | 执行下一行语句，如果包含函数，执行该函数并返回
s | step | 执行单行语句，如果包括函数，则进入该函数的首行
b *k* | breakpoint | 在*k*行设置断点
b *subx* | breakpoint | 在函数*subx*的首行设置断点
c | continue | 继续执行，直到下一个断点
p *expr* | print | 计算表达式并显示其结果
q | quit | 终结该程序

# 四、数组

## 4.1 数组简介

Perl的数组十分灵活，其长度可以根据需要自动扩展，没有类型限制，也就是每个数组单元都可以保存数值、字符串和引用。

## 4.2 list字面值

list是Scala值的有序列。

List字面值 | 描述
--- | ---
(5) | 一个包含单个数值的list
() | 一个空list
("apples", "pcs") | 一个包含两个字符串的list
("me", 100, "you", 50) | 一个包含两个字符串和两个数值的list
($sum, "Sum") | 一个带有变量的list
(2 * $total, "!" x 20) | 一个带有表达式的list
qw(bob carol ted arf) | 一个隐式quote的list

范围操作符（省略号`..`）可用于在list字面值中指定一个范围内的scala字面值，支持数值或字符串。例如：

List字面值 | 等价list
--- | ---
(0 .. 6) | (0, 1, 2, 3, 4, 5, 6)
(1.5 .. 7) | (1.5, 2.5, 3.5, 4.5, 5.5, 6.5)
(5 .. 3) | ()
('a' .. 'z') | ('a', 'b', 'c' ... 'z') 
('aa' .. 'zz') | ('aa', 'ab', 'ac', ... 'zz')

注意上面第二个例子，等价list中每个数值都是前面的值加1，最后一个值要求不超过最大值7，所以是6.5。
另外，后两个例子中的等价list只是对取值的解释，不是Perl的语句。

## 4.3 数组

数组是一个值为list的变量，名称命名规则类似Scala变量，但必须以`@`开头。除去首字符同名的Scala变量和数组变量没有任何关系，例如`$list`与`@list`无关。数组变量和Scala变量一样，不需要声明，其长度会随需要自动增长。未初始化（赋值）的数组有默认的初始值：空数组，也就是`()`。注意list字面值中仅能包含scala值（或表达式、变量），不可以嵌套数组等其他类型的值，scala值包括数值、字符串和引用。

{% highlight perl %}
@a = (2, 4, 6);            # @a有3个元素
@a = ('a', 'b', 'c', 'd'); # 现在@a有4个元素，其长度自动增长为4
@a = (4.35);               # 现在@a仍然有4个元素，但是后3个元素被设为了undef
@a = 1;      # 如果scala值赋值给数组，该数组会被设为仅包含该scala值的单元素数组，所以@a现在是(1)

# 如果数组变量赋值给scala变量，该scala变量会被设为数组的长度，所以下面$girl值被设为3
@names = ('mary', 'jo', 'ann');
$girls = @names; 

($a, $b) = (2, 4);     # 如果list字面值中仅包含变量，那么该字面值可以作为赋值语句的目标
($a, $b) = (2, 4, 6);  # 如果赋值语句左侧元素数量少于右侧，那么右侧多余的值会被忽略
($a, $b, $c) = (2, 4); # 如果赋值语句左侧元素数量多于右侧，那么左侧多余的变量会被设为undef

# 如果赋值左侧出现数组，它会吞掉剩余的所有元素，所以下面的@list值为("dog", "monkey")，而$b设为undef
($a, @list, $b) = ("cat","dog","monkey"); 
($first, @list) = @list; # 实际使用中可用于去除数组的第一个元素

@b = (2, 3, 4);
@a = (1, @b, 5); # 如果赋值右侧出现数组，它包含的元素会被展开，这里相当于(1, 2, 3, 4, 5)

# 清空数组
@list = ();    # 正确方式一
undef @list;   # 正确方式二
@list = undef; # 错误方式，该操作会将数组赋值为包含一个undef元素的数组。

# 双引号字符串中的数组变量会被解释，其中的元素会被按顺序打印出来，元素之间以单个空格隔开
print "The list is @list \n"; 
{% endhighlight %}

Perl中没有多维数组，但是可以通过保存了一系列引用的数组来模拟多维数组，因为引用也是一种scala值，这将在后面涉及。

## 4.4 引用数组元素

不出意料，Perl中引用数组中的元素也是使用`[]`，只需在数组名后添加`[下标]`，这里方括号中的下标是scala值或者可转换成scala值的表达式，下标从0开始。
出乎意料的是，Perl中引用数组元素时，变量名需要改成`$`开头，就好像这个整体是一个scala变量。

{% highlight perl %}
@list = (1,2,3,4);
$list[0] = 17;        # 这里引用了数组list里的元素，需要改成$开头

# 注意前面说过，$list与@list无关，但$list[0]与@list有关，切勿混淆
$list = "Darcie";
@list = (2, 4, 6, 8);
$list[1] = 10;
print "Scalar: $list Element: $list[1] List: @list";
# 上述语句输出 Scalar: Darcie Element: 10 List: 2 10 6 8

# 下面是数组头两个元素互换，这样做是合法的，因为其效果是两个赋值并行完成
($list[0], $list[1]) = ($list[1], $list[0]); 

# 如果试图访问数组最后一个元素后面的信息（也就是数组越界），得到的值为undef，并不会产生错误
@highs = (92, 84, 81, 79, 85);
$Saturday_hi = $highs[6];

# 不同于常见编程语言的设定，Perl中访问数组元素时，下标可以为负数，
# 此时该下标对应的元素从最后一个往前数，最后一个为-1
@list = (2, 4, 6, 8, 10);
print "The last element is: $list[-1] \n";        # 显示10
print "The second last element is: $list[-2] \n"; # 显示8
print "The first element is: $list[-5] \n";       # 显示2
$list[-10] = 17;       # 当负数下标超过允许的范围时，会产生严重运行时错误

# 当给数组某个超过当前长度的下标位置的元素赋值时，数组会隐式地扩展到所需的长度。
$list[50] = 22; # 数组长度扩展成51

# 要想获知某个数组中最后一个元素的下标，可以通过$#接数组名称这样的隐式变量来获得，例如：
print "The last index of \@list is $#list \n";
# 我们还可以用此变量将数组设为空数组：
$#list = -1;
# 当需要使用较大长度的数组时，如果让该数组隐式地按需扩展长度，从短到长，频繁地扩展，效率会比较低。
# 更高效的方法是一开始就设置好最终的数组长度。例如我们需要长度为1000的数组时，可以采用如下做法：
$list[999] = 0;  # 方法一，给最后一个元素赋值
$#list = 999;    # 方法二，设置最后一个元素的下标
{% endhighlight %}

## 4.5 切片

切片是对数组中元素子集的引用。

{% highlight perl %}
@salaries = (34000, 41950, 52100, 39650);
@salaries[4, 5] = (48500, 41500);
@first3_salaries = @salaries[0, 1, 2];
@next3_salaries = @salaries[3..5];

@list = (1, 3, 5, 7, 9) [$first, $second]; # list字面值也可以使用切片

@list = (2, 4, 6, 8);
@list[1, 3] = @list[3, 1]; # 交换数组中的元素

{% endhighlight %}

## 4.6 Scalar和list上下文

Perl中操作数的上下文影响了其在表达式中的值。上下文分两种，scala和list。赋值语句的左值类型决定了该操作的上下文，例如赋值语句左侧是scala，右侧是数组，则数组的长度会被赋给左值。一些函数和操作符需要其参数为scala，一些需要list类型。我们可以强制转换list类型为scala类型，但不能强制转换任何类型为list类型，因为如果某个函数需要list参数的话，其参数已经被强制转换为了list类型。当list字面值赋值给scala时，会将其中的最后一个元素的值赋给scala变量。还有的操作符在两种上下文中都可以使用。

{% highlight perl %}
@list + 0                                              # 强制转换list为scala
print "Length of \@list is: ", scalar(@list), "\n";    # 强制转换list为scala

$x = (7, 12, 27, 5);    # $x的值为list的最后一个元素，即为5
$x = qw(a b c d);       # $x的值为数组长度，即为4

$next = <STDIN>;        # 读入一行
@input = <STDIN>;       # 读入所有行，数组中每个元素为一行的输入内容
{% endhighlight %}

## 4.7 foreach语句

{% highlight perl %}
foreach $age (@ages){              # 遍历数组
    $age++;
}

foreach $count (1, 3, 5, 7, 9){    # 遍历list字面值
    $sum += $salaries[$count];
}

foreach $index (0..99){            # 遍历以范围表示的list字面值
    $sum += $list[$index];
}

$sum += $list[$_] foreach (0..99); # 作为语句修饰符使用，这里用隐式变量$_保存遍历时的数组元素
{% endhighlight %}

## 4.8 List操作符

Perl提供了很多操作数组和list的操作符，由于数组的值就是list，所以我们一般把它们叫做list操作符。提醒下，操作符和函数是等价的。

* reverse

{% highlight perl %}
@names = ("Al", "Bob", "Jake");
@rnames = reverse @names;       # 数组逆序，结果为("Jake", "Bob", "Al")

$name = "adam";
$rname = reverse $name;         # scala变量会被强制转换为字符串，并逆序，这里就是"mada"
{% endhighlight %}

* sort

{% highlight perl %}
@sorted_names = sort @names;    # 排序数组，直接这样使用sort操作符的话，其中每个元素被强制转换为
                                # 字符串并以字典序排序

@list = (42, 68, 10, 5, 103);
@sorted_list = sort @list;      # 所以这里以字典序排序的结果不是我们想要的，如何让sort操作符按
                                # 数值排序会在后面涉及
{% endhighlight %}

* x (乘号)

{% highlight perl %}
@valentine = ("I love you!") x 5; # 创建包含5个同样字符串的数组
@list = (0) x @list;              # 由于x右侧值为scala，这里右边的@list会被转换为其长度，所以
                                  # 结果是将该list所有元素置0
{% endhighlight %}

* chop 和 chomp

{% highlight perl %}
@list = ('little', 'green', 'apples');
chop(@list);       # 对数组中每个字符串使用chop，并返回最后一个字符串中被截取的末尾字符，这里
                   # 就是‘s’

@input = <STDIN>;
chomp(@input);     # 对数组中每个字符串使用chomp，并返回总共删除的行分隔符的数量

{% endhighlight %}

* splice

{% highlight perl %}
@list = (2, 4, 6, 8, 10);
splice (@list, 3);             # 去掉index从3开始的元素，现在list值为(2, 4, 6)

@list = (2, 4, 6, 8, 10);
splice (@list, 2, 2);          # 去掉index从2开始的2个元素，现在list值为(2, 4, 10)

@list = (1, 2, 3, 4, 5);
@new = (7, 6);
splice (@list, 2, 2, @new);    # 去掉index从2开始的2个元素并插入新元素，
                               # 现在list值为(1, 2, 7, 6, 5)

@list = (1, 2, 3, 4, 5);
@new = (7, 6);
splice (@list, 2, 0, @new);    # 也可以不删除元素，插入新元素，现在list值为
                               # (1, 2, 7, 6, 3, 4, 5)

@list = (1, 2, 3, 4, 5);
splice (@list, 2, 2, 9, 8, 7); # 还可以把新元素的值直接写在参数中（从第4个参数开始），现在list
                               # 值为(1, 2, 9, 8, 7, 5)                               
{% endhighlight %}

* push 和 pop

{% highlight perl %}
push @stack1, "Mary";

push @stack2, (9, 11, 13);

push @stack2, 9, 11, 13;   # 等价于 push(@stack2, 9, 11, 13)

$value = pop @stack1;

@list = ("bob", "carol", "ted");
@name = shift @list;       # shift与pop类似，只是在数组开头弹出元素
unshift @list , "mikie";   # unshift与push类似，只是在数组开头压入新元素

push @list, shift(@list);  # 结合push和shift可以循环转动元素（rotate）
unshift @list, pop(@list); # 类似上面的操作，只是方向相反
{% endhighlight %}

* split

`split [/Pattern/[, Expression[, Limit]]]` 类似于javascript的`split`函数。其中`/Pattern/`为正则表达式，`Expression`为目标表达式，`Limit`是产生的最大元素数量

{% highlight perl %}
@fruit = split /,/, "apples,gwapes,pineapples,cannonballs", 3;
# 结果为("apples", "gwapes", "pineapples,cannonballs")

@fruit = split /,/, "apples,gwapes,pineapples,cannonballs";
# 结果为("apples", "gwapes", "pineapples", "cannonballs")

@fruit = split /,/; # 用给定的正则表达式对$_执行split操作

@fruit = split ;    # 用空白符（即/\s/）对$_执行split操作
{% endhighlight %}

## 4.9 命令行参数

`@ARGV`是Perl中保存所有命令行参数的隐式变量，因此可以用如下方式访问所有命令行参数：

{% highlight perl %}
# 方法一
foreach $index (0 .. $#ARGV) {
    print "$ARGV[$index] \n";
}

# 方法二
$num_args = $#ARGV + 1;
for ($count = 1; $count <= $sum_args; $count++){
    $argument = shift(@ARGV);
    print "$argument \n";
}

# 由于pop和shift有默认参数@ARGV，所以下述代码可以替代方法二中for循环里的$argument = shift(@ARGV);
$argument = shift;
{% endhighlight %}

# 五、Hash和引用

Hash有时被称为关联数组，或者哈希表。Perl是唯一的一个拥有内置Hash支持的且被广泛使用的语言。Hash结合引用类型的scala变量可以构造出复杂的数据结构，例如数组的数组或者hash的数组。

## 5.1 Hash结构

Hash和数组很像，但两者最主要的区别是：

1. Hash结构中数据元素由字符串值索引，这些字符串也被保存在Hash中，并被称为键(key)。

2. Hash结构中的数据元素并没有经过排序。

Hash中的每个元素是一对scalar值，其中前者是键，后者为值。Hash变量以`%`开头，和数组类似，使用Hash变量不需要提前声明，并且它会根据需要自动增长，也可以在任何时候将其压缩。我们可以通过键来访问Hash中对应的值。

{% highlight perl %}
# Perl中并没有Hash字面值，取而代之的是如下所示的list字面值：
("bob", 42, "carol", 40, "ted", 29)

# =>符号可以替换其中的部分逗号来使其更加具有可读性
("bob" => 42, "carol" => 40, "ted" => 29)

# =>左侧的值会被隐式地加上引号
(print => "yes") # 等价于("print" => "yes")

# 当数组赋值给hash时，奇数位值作为键，偶数位作为对应的值
@list = ("Grumpy" => 44, "Sleepy" => 27, "Maxine" => 79);
%dwarfs_ages = @list;
%salaries = ("Bill" => 79_500, "Billy" => 43_000, "Billie" => 55_200);

# 当hash的值赋给数组时，按键值对展开，但顺序是任意的，例如上面的%salaries赋给数组可能会得到如下结果：
("Billie", 55200, "Billy", 43000, "Bill", 79500);

$salaries{"Billy"}             # 43000
$salaries{"Willie"} = 47000;   # 插入新的键值对或更改已有键对应的值
$salaries{Bill} += 500;        # {}中间的键是隐式加上引号的，相当于$salaries{"Bill"} += 500

# 将hash置空的两种方式
%salaries = ();
undef %salaries;

# hash变量在引号中不会被解释，以防止与printf中的格式符冲突
print "%salaries"; # 会打印"%salaries"

# 切片
@some_salaries = @salaries{"Bill", "Billy"}; # 注意切片以@开头，因为hash切片的结果是数组
{% endhighlight %}

## 5.2 Hash操作符

{% highlight perl %}
delete $salaries{"Bill"};   # 删除hash中Bill这个键及其对应的值
undef $salaries{"Billy"};   # 这并不能删除删除这个键，只能将该键对应的值设为undef
exists $salaries{"Billy"};  # 判断hash中是否存在某个键，返回布尔值

@days = keys %highs;        # 获得hash中的所有键，返回的是数组
# 可以结合foreach使用，打印出hash中的所有键值
foreach $day (keys %highs){
    print "On $day the high temperature was $highs{$day} \n";
}
$length = keys %highs;      # 获取键的数量（因为等号左侧是scala变量）

# values可以获得所有值，没有特定的顺序，没有关联的键，所以可能不是很实用
foreach $temp (values %highs) { print "$temp \n" }

# 还可以使用each操作符来遍历hash中的键值对
while(($day, $temp) = each %highs){
    print "On $day the high temperature was $temp \n";
}
{% endhighlight %}

Perl有预定义的hash：`%ENV`，保存了操作系统的环境变量。

## 5.3 引用

下面讨论第三种scala类型——引用。它与其他语言中的指针类似。许多应用程序需要使用复杂的数据结构。这些结构可以通过常指针，即Perl中的引用来定义和操作。引用的值是地址，这些地址可以是其他命名变量的地址或者匿名变量（字面值）的地址，或者甚至是我们将在后面介绍的子程序的地址。没有名字的匿名变量只可以通过引用来使用。

反斜杠`\`可用于将命名变量或scala字面值的地址赋给一个变量，保存该地址的变量即为一个硬引用。解引用（dereference）只需将值变量的名字中字母或数字部分替换成对应引用变量的名字，而对数组或hash解引用还可以使用`->`操作符。另外，Perl中也可以使用变量名称的字符串来作为一种引用，即软引用，其解引用方式与硬引用相同。具体实例如下：

{% highlight perl %}
$sum = 0;
$ref_sum = \$sum;
@list = (1, 3, 5, 7);
$ref_list = \@list;

$ref_list = [1, 3, 5, 7]; # list字面值也可以用[]来声明，从而得到其地址
$ref_hash = {             # hash字母值(本质上还是list字面值)可以用{}来声明，从而得到其地址
    'Bob' => '42',
    'Jake' => '12',
    'Darcie' => '11'
};
$ref_pi = \3.14159;       # 用\取得scala字面值的地址

$sum = 17;
$ref_sum = \$sum;
print "The sum is: $$ref_sum \n"; # 显示：The sum is: 17
print "The sum is: $ref_sum \n";  # 显示：The sum is: SCALAR(0xb75d3c)

$$ref_list[3] = 17;
$ref_list -> [3] = 17;       # 与上式等价

$$ref_hash{'Bob'} = '42';
$ref_hash -> {'Bob'} = '42'; # 与上式等价

$sum_name = "sum";
$$sum_name = 17;
{% endhighlight %}

使用软引用十分危险，因为可能由于拼错引用的变量的名称而导致严重的后果，所以可以使用`use strict 'refs';`来指示编译器禁用这种符号引用。

## 5.4 嵌套数据结构

有了引用变量，我们可以构造比数组和hash更加复杂的数据结构。

{% highlight perl %}
@mat = (
    [1, 3, 5],
    [7, 9, 11],
    [13, 15, 17]
);

$ref_mat = [
    [1, 3, 5],
    [7, 9, 11],
    [13, 15, 17]
];

@row1 = (1, 3, 5);
@row2 = (7, 9, 11);
@row3 = (13, 15, 17);
@mat = (\@row1, \@row2, \@row3);

print "The (2,3) element is: $mat[2] -> [3] \n";
print "The (2,3) element is: $mat[2][3] \n";      # 两个[]之间的->可以省略
$ref_mat -> [2][2] = 17;
$$ref_mat[2][2] = 17;    # 由于$的优先级比[]高，所以该式与上式等价

# 读取矩阵的示例
$num_rows = <STDIN>;  # 输入行数
foreach $row_num (0 .. $num_rows - 1){
    $temp = <STDIN>;
    @row = split / /, $temp;
    $mat[$row_num] = [ @row ];
}

# 打印矩阵的示例
foreach $ref_row (@mat){
    print "@$ref_row";
}
{% endhighlight %}

# 六、函数

Perl中，函数又叫子程序。

## 6.1 子程序基础

Perl中的子程序没有显式地指定参数数量、参数类型和返回值类型。子程序可以在其他子程序的函数体以外的任何地方定义。

## 6.2 无参数的函数

{% highlight perl %}
# 函数声明
sub print_header;

# 函数定义
sub print_header {
    print "\n Program Output \n\n";
}

# 直接函数调用
print_header(); # 当作函数来调用
print_header;   # 当作操作符来调用

# 用在表达式中
$result = 2 * fun() + 1;
$sum = sumer();

# 下述两种带有返回值的函数等价
$pi = 3.14159;
sub two_pi_1 {
    return (2 * $pi);
}
sub two_pi_2 {
    2 * $pi;     # 如果sub块的最后不是return语句，则最后一个表达式的值将作为返回值
}

# 函数调用的上下文决定了其返回值求值时的上下文
sub sub1{
    @result = (1, 3, 5);
}
$scalar = sub1();  # 值为3
@list = sub1();    # 值为1 3 5
{% endhighlight %}

## 6.3 变量的作用域和生命周期

Perl中的变量是隐式地属于全局变量，但我们可以通过`my`和`local`来定义局部变量，并且可以通过`use strict 'vars'`来通知编译器禁用全局变量。

{% highlight perl %}
sub sub1{
    my $sum = 0; # 用my声明的局部变量仅在当前区块中有效
    ...
}

my($a, $b, $c);               # 声明多个局部变量
my($a, @list) = (3, 2, 7, 6); # 声明并初始化多个局部变量

# 任何非函数体的区块都可以被嵌套，所有区块中都可以定义对应的局部变量
$temp = 5; # 全局变量
{
    my $temp = 10; # 外层区块的局部变量
    if($list[$outer] > $list[$inner]){
        my $temp = $list[$inner]; # 内层区块的局部变量
        $list[$inner] = $list[$outer];
        $list[$outer] = $temp;
    }
}

sub sub2{
    local $count = 0; # 用local声明的局部变量（或者说"半局部变量"）在当前区块以及调用的函数的
                      # 函数体中有效
    addCount();
}
sub addCount{
    $count++;
}
sub2();
{% endhighlight %}

## 6.4 参数

{% highlight perl %}
# 使用@_(或@ARG，前提是使用'use English')获得函数调用时传入的参数
sub adder{
    ++@ARG[0]; # 直接操作@ARG，即相当于引用传参
    ++@ARG[1];
}
$x = 7;
@list = (1, 3, 5);
adder($x, @list);   # 函数返回后，$x值为8，@list值为(2, 3, 5)

sub sub1{
    my ($x, $y, $z) = @ARG; # 新建局部变量保存传入参数，即相当于拷贝传参
    ...
}

# 当传入参数为引用类型时
sub add_1_scalar{
    my $param = $ARG[0];
    $$param++; # 解引用
}
add_1_scalar(\$sum);

# 当需要向某个函数传入当前@ARG值（调用该函数前的值），而不是新建一个@ARG时，可以这样调用函数
&sub1;
{% endhighlight %}

## 6.5 非直接的函数调用

我们可以通过`\`和`&`来获得函数的地址，从而保存到引用变量中，然后可以通过`&`解引用来调用该函数。当然，我们也可以采用软引用，直接使用函数名称字符串来解引用。

{% highlight perl %}
# 保存函数地址
$ref_fun = \&print_header;
$ref_fun_soft = "print_header";
$ref_fun_anonymous = sub {
    print "\n Program Output \n\n";
}
# 通过引用变量调用函数
&$ref_fun();
&$ref_fun_soft();
&$ref_fun_anonymous();
{% endhighlight %}

## 6.6 Perl预定义函数

具体请查表，略

## 6.7 再谈sort函数

sort函数可以接受两个参数，其中第一个参数为排序操作时的比较函数，第二个参数则是需要排序的数组。该比较函数可以采用函数名、函数区块或者一个值为函数名称或函数地址的scala变量。该函数中包含了隐式变量`$a`和`$b`，对应了每次比较的两个元素，该函数需要返回0表示两者顺序无关，或大于0表示两者需要对调位置，或小于0表示两者已经排好序。Perl提供了两个默认的比较函数：`<=>`来比较数值，`cmp`来比较字符串。通过自定义比较函数，我们可以完成自定义的排序操作。另外，这里`$a`和`$b`即使在`use strict 'vars'`时仍可使用，因为它们是特殊的局部变量，不受此命令限制。

{% highlight perl %}
sort { $a <=> $b } @list; # 默认排序
sort { $b <=> $a } @list; # 逆序排序数值
sort { $b cmp $a } @list; # 逆序排序字符串

# 示例：将hash中的键值对按照值的大小逆序输出
foreach $key (sort { $top_five{$b} <=> $top_five{$a}; } keys %top_five){
    print "$key \t $top_five{$key} \n";
}
{% endhighlight %}

> 参考书籍：《<a href="http://www.amazon.com/Little-Book-Perl-Robert-Sebesta/dp/0139279555" target="_blank">A Little Book on Perl</a>》, Robert W. Sebesta, Prentice Hall.



