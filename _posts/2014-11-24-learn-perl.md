---
layout: post
title: Perl学习笔记
description: "随便整理下Perl语言的学习笔记"
modified: 2014-11-24
tags: Perl
image:
  feature: learn_perl.jpg
comments: true
share: true
---

<script type="text/javascript">
if(/learn-perl\/?$/.test(window.location.href)){
	document.querySelector('.entry-image').style.maxHeight="100%";
}
</script>

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

### 2.2 Scala变量

所有Scala变量都以$开头，然后是一个字母，后面还可以接上一个包含字母、数字和下划线的字符串，区分大小写，规则类似于C等语言对变量名的限定。（书上是这么写的，但实际上还有诸如$1,$2,$_等等的Scala变量，但这些都是系统隐式定义的变量，所以我们自己定义的变量最好是按照上述规则来定义。）

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

### 2.3 Scala操作符

#### 2.3.1 算术操作符

Perl支持的算术运算符与C很相似，它们都提供了基本运算符 + - * / % ，二进制运算符 & | ～ ^ >> << ，以及自增++自减--运算符
不同点在于：

1. %和二进制运算符会将操作数隐式转换成整数后再进行计算（转换是截取整数部分，而不是四舍五入）
2. Perl提供了重复操作符x（小写字母x），用于重复字符串，后面会涉及。它的右操作数是数字，该数会被隐式转换成整数
3. Perl还提供了指数运算符**，作用同C里的pow函数
4. 包括**在内的其他操作符都会将其所有操作数隐式转换成double类型再进行计算

{% highlight perl %}
5 / 2      # = 2.5
7.86 % 3   # = 1
3 ** 2     # = 9
{% endhighlight %}

> 未完待续  :smile:

> 参考书籍：《<a href="http://www.amazon.com/Little-Book-Perl-Robert-Sebesta/dp/0139279555" target="_blank">A Little Book on Perl</a>》, Robert W. Sebesta, Prentice Hall.



