---
layout: post
title: Hello New Blog
description: "Celebration for this new blog"
modified: 2013-12-18
tags: 
image:
  feature: abstract-3.jpg
  credit: dargadgetz
  creditlink: http://www.dargadgetz.com/ios-7-abstract-wallpaper-pack-for-iphone-5-and-ipod-touch-retina/
comments: true
share: true
---
##First Step

After I struggling for several days, my first *high-tech* blog was finally built up!!!

Before this one, I've written some posts on my old [QQ Space](http://773534839.qzone.qq.com). At that time, I thought *QQ Space* is not very good, at least cannot suffice my requirements. Yeah, I'm that kind man who want everything to be free and perfect, so I dislike the restrictions and paid but no-good services there. 

I has also tried the *WordPress* blog system, which is very powerful and free to use. But I admit that it made me very happy, only when I successfully bought a host service with no pain and just forgot about the high cost and the high network lags...that's only a joke.

But today, with the strong support from [GitHub](https://www.github.com) and many open source projects, this brand new blog was born! It's free to host static website on *GitHub*, no up-time limit, no space limit, no annoying limits!

## How It's Made
GitHub supports two kinds of websites in its [GitHub Page](http://pages.github.com/) service, one is pure static site, the other one is static site build with [Jekyll](http://www.jekyllrb.com). This blog is the second type. *Jekyll* is a kind of blog-aware website generator, it can be installed by [Ruby Gems](http://rubygems.org/). Inside of it, maybe in some modules, [Python](http://www.python.org) is required to do some task.

Besides, I found an open-source website template for *Jekyll* blog [here](https://github.com/mmistakes/hpstr-jekyll-theme/). It looks great and can work perfectly with Jekyll. But when I want to cutomize some styles, I need to modify and compile the `*.less` files. To compile that, I should also install [Grunt](http://gruntjs.com/) and some *Grunt* plugins, and all of these packagers should be installed by <attr title='Node.Js Package Manager'>NPM</attr> from [node.js](http://nodejs.org).

So, here is the construction blueprint of this blog:

* GitHub Page
* Jekyll
    * Ruby & Ruby Gems
    * Python
* Grunt & plugins
    * Node.Js & NPM

## What's Next
I've created [several projects](https://github.com/tjumyk?tab=repositories) on *GitHub*, but with lack of time, I failed to write good documents for them. Recently, I'm not as busy as before, and I may get more free time in the following months, so I will try to add some posts here to give detailed descriptions of those projects.

Further more, I've started a new project about web font generation for static web pages. This time, I'll post documents here when it is published.

> GOOD GOOD CODE, DAY DAY UP.

