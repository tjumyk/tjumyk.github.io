---
layout: post
title: 正则表达式学习笔记
description: "结合Perl中的应用，简单整理一下正则表达式的学习笔记"
modified: 2014-12-17
tags: [Regex, Perl]
image:
  feature: hack-like-pro-introduction-regular-expressions-regex.1280x600.jpg
comments: true
share: true
---

这里简单总结以下Perl中正则表达式的用法

--------------------

## 一、简介

Perl中模式匹配符的形式如下：

{% highlight perl %}
m dl pattern dl [modifiers]
{% endhighlight %}

该式是布尔表达式，返回`true`或者`false`。其中，`m`是操作符，`dl`是模式的限定符（指定模式的起始和结束），`modifiers`是可选的，可用于改变模式的用法。最常见的限定符是斜杠`/`，当使用`/`作为限定符时，`m`可以省略。当模式中需要用到`/`（例如UNIX路径：`usr/users/sebesta`），我们可以使用其他限定符，但此时`m`不可省略，例如`m~pattern~`。

## 二、简单模式

### 2.1 匹配字符

模式中的字符分为三类：

1. 常规字符，用于匹配自身
2. 元字符，在模式中有特殊的意义
3. 句号

转义序列，例如`\t`和`\cC`(Control+C)，可以出现在模式中，并匹配自身。元字符仅当在前面插入`\`时才可以匹配自身。元字符有：`\` `|` `(` `)` `[` `]` `{` `}` `^` `$` `*` `+` `?` `.`，其中有的字符仅在特定的上下文中有特殊的意义。

默认参与匹配的字符串是`$_`，因此可以直接使用如下的结构：

{% highlight perl %}
if(/snow/){
    print "There was snow somewhere in \$_ \n";
}else{
    print "\$_ was snowless \n";
}
{% endhighlight %}

模式中出现的空格也是普通字符，匹配自身。例如：

{% highlight perl %}
/snow days/ # 中间必须有且仅有一个空格符
{% endhighlight %}

句号匹配除了换行符外的任意字符。例如：

{% highlight perl %}
/a../  # a后面必须接上两个非换行符
{% endhighlight %}

### 2.2 字符类

字符类是一组字符，其中的任意一个字符可以匹配目标字符。例如：

{% highlight perl %}
/[<>=]/ # 匹配 < > = 中的任意一个字符
{% endhighlight %}

短横线`-`可用于表示一个范围内的字符。例如：

{% highlight perl %}
/[A-Za-z]/ # 匹配任意的一个英文字母
/[0-7]/    # 匹配任意的一个八进制数字
{% endhighlight %}

如果`-`出现在字符类的末尾，则仅表示一个普通字符，匹配自身。如果你需要在字符类中的其他地方指定普通字符`-`，则需要在前面添加反斜杠`\`。

{% highlight perl %}
/[0-3-]/   # 匹配'0', '1', '2', '3' 或 '-'
{% endhighlight %}

有时，指定不属于某一范围的字符更加方便，我们可以在字符类的最左端添加`^`：

{% highlight perl %}
/[^A-Za-z]/ # 匹配任意的一个非英文字母的字符
/[^01]/     # 匹配任意的一个非'0'或'1'的字符
{% endhighlight %}

有些字符类是很常用的，它们有预定义的缩写：

缩写|等价模式|匹配
\d|[0-9]|一个数字
\D|[^0-9]|一个非数字字符
\w|[A-Za-z_]|一个单词字符
\W|[^A-Za-z_]|一个非单词字符
\s|[ \r\t\n\f]|一个空白符
\S|[^ \r\t\n\f]|一个非空白符

示例如下：

{% highlight perl %}
/[A-Z]"\s/   # 匹配一个大写英文字母，一个双引号以及一个空白符
/[\dA-Fa-f]/ # 匹配一个十六进制数字
/\w\w:\d\d/  # 匹配两个字母，一个冒号，和两个数字
{% endhighlight %}

模式中也可以包含变量。例如：

{% highlight perl %}
$hexpat = "\\s[\dA-Fa-f]\\s"; # 这里\s需要前加上一个\，或者改用单引号
if(/$hexpat/){
    print "\$_ has a hex digit \n";
}
{% endhighlight %}

### 2.3 量词

Perl中提供了4种量词：`*` `+` `?` `{m,n}`。量词紧跟在字符、字符类或者小括号括上的子模式后面，用以指定重复的次数。

量词 | 意义
{n} | 重复n次
{m,} | 重复至少m次
{m,n} | 重复至少m次，且不超过n次

其他量词是以上形式的缩写，`*`相当于`{0,}`，`+`相当于`{1，}`，`？`相当于`{0,1}`。

量词匹配引出了匹配过程的分析：

1. 模式匹配总是会匹配字符串最左边的能够匹配整个模式的子串
2. 量词有两种匹配方式：贪心匹配和最小匹配
3. 贪心匹配中，量词总是会匹配可能的最长子串。这是量词的默认匹配方式。
4. 最小匹配中，量词总是会匹配可能的最短子串。需要在量词的后面加上`？`来启用最小匹配
5. 一个模式中如果出现多个量词，最左边的量词是最贪心的。

示例如下：

模式 | 字符串 | 匹配子串
`/m/` | Tommie | 左边的m
`/m*/` | Tommie | T左边的空字符串
`/m*i/` | Tommie | mmi
`/.*Bob/` | Bob sat next to the Bobcat and listened to the Bobolink | Bob sat next to the Bobcat an listened to the Bob
`/Fred+/` | Freddie's hot dogs | Fredd
`/Fred+?/` | Freddie's hot dogs | Fred
`/Bob.*Bob.*link/` | Bob sat next to the Bobcat and listened to the Bobolink | 其中第一个`.*`匹配" sat next to the Bobcat and listened to the "

### 2.4 析取

析取（Alternation）通过`|`来指定，它相当于编程语言中的逻辑或。例如：

{% highlight perl %}
/a|e|i|o|u/          # 相当于/[aeiou]/
/Fred|Mike|Dracula/  # 也可用于析取字符串
/t(oo?|wo)/          # 可用括号括上析取结构
{% endhighlight %}

析取结构从左往右逐个尝试匹配，所以`/Tom|Tommie/`永远不会匹配右边的"Tommie"。在字符类中没有必要使用析取操作符，例如`[belly|belts|bells]`相当于`[belyts]`，这可能并不是你想要的结果。

### 2.5 模式操作符的优先级

要正确地使用各种模式操作符，必须了解其优先级。

操作符 | 优先级
括号 | 最高
量词 | 较高
字符类 | 较低
析取 | 最低

例如：`/#|-+/`匹配一个#号或者一个或多个减号；而`/(#|-)+/`匹配一个或多个#号或者一个或多个减号。

## 三、复杂模式

### 3.1 锚

锚用于匹配字符串中的特定位置，而不是匹配其中特定的字符或字符串。其中`^`匹配字符串中第一个字符前面的位置，即表示字符串的开头；`$`匹配字符串中最后一个字符后面的位置，即表示字符串的结尾；`\b`匹配字母字符(`\w`)和非字母字符(`\W`)之间的位置，可用于匹配某个不属于另一单词中的单词。注意`^`符号仅在位于模式最左端或字符类最左端时具有特殊意义，其他情况下都是匹配自身的普通字符。

示例如下：

{% highlight perl %}
/^Shelley/        # 匹配以Shelley开头的字符串
/hair$/           # 匹配以hair结尾的字符串
/^[^!]^/          # 匹配以非!开头且第二个字符为^的字符串
/\bwear\b/        # 匹配独立的单词wear，不会匹配包含wear的单词，例如Swimwear
{% endhighlight %}

### 3.2 绑定操作符

Perl中可以使用`=～`让某个字符串尝试匹配某模式，返回布尔值，表示是否成功匹配。也可使用`!～`来判断是否不能成功匹配，结果与`=～`相反。

{% highlight perl %}
$string =~ /[,;:]/
$string !~ /[,;:]/
if(<STDIN> =~ /^[Yy]/) { ... }
{% endhighlight %}

### 3.3 模式修饰符

模式的末尾可以带上修饰符，它要么会改变模式的解释方式，要么会改变模式匹配的工作方式。

符 | 意义
i  | 忽略大小写
m  | 输入字符串被当作多行文本来处理，此时`^`匹配所有换行符的前面位置，`$`匹配所有换行符的后面位置
s  | 输入字符串被当作单行文本来处理，此时`.`会匹配所有字符，包括换行符
o  | 当模式中出现scalar变量，默认情况下，此模式在每次使用时都会重新编译，执行开销较大；而当确定变量的值恒定不变时，可使用此修饰符通知Perl无需重复编译此模式
x  | 允许在模式中包含空白符且它们不会被解释，使得该模式与去掉这些空白符后的模式等价。这里空白符包括以`#`开头的行注释，从而我们可以给复杂模式添加注释

## 四、记忆匹配

## 五、正则表达式的扩展

## 六、split函数

## 七、替换

## 八、示例

## 九、翻译字符

> 参考书籍：《<a href="http://www.amazon.com/Little-Book-Perl-Robert-Sebesta/dp/0139279555" target="_blank">A Little Book on Perl</a>》, Robert W. Sebesta, Prentice Hall.
