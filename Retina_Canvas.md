----
title: Retina Canvas?
----

## canvas在retina屏幕下线条锯齿化的解决方案

1. 问题描述

	当我们在retina屏幕（俗称视网膜屏幕下）用canvas画出一个圆形或者渲染出一张图片时，如果仔细观察我们会发现图案的边缘是模糊的，如[一般的实现方式](https://jsfiddle.net/yusphy45/f03yh2d6/)所示，观感就会感觉很差。
	
2. 问题分析

	之所以出现上面的情况这是跟retina屏幕与我们平时使用的屏幕渲染像素点的方式是不同的，具体原理请移步 [Retina显示屏](https://zh.wikipedia.org/wiki/Retina%E6%98%BE%E7%A4%BA%E5%B1%8F)，简单来说就是原本圆形路径上只需渲染一个像素点，现在在retina屏幕上需要渲染2个甚至更多像素点，这样就造成了原本均匀分布的像素点变得奇奇怪怪，导致了锯齿的出现。
	
3. 解决方案
	
	其实知道了原理之后，我们解决起来其实还是蛮方便的。
	- 首先我们知道现在大部分的浏览器window对象上存在devicePixelRatio这样一个属性的，简单来说就是物理像素/虚拟像素
	- 二是我们应该知道canvas的width与height的属性和css中的width、height是可以一起对canvas元素的宽高产生影响的
	- 那我们岂不是可以类似使用一种压缩的方式来解决
	- [好一点的方式](https://jsfiddle.net/yusphy45/4gafqav8/)
	- 但是我们接下来又发现一个问题 那就是canvas本身被缩小了 画出的形状也被相应的缩小了，我们应该如何在保证正常输入绘图尺寸的同时保证线条的锐利呢，画布的scale方法就派上了用场
	- [更好的方式](https://jsfiddle.net/yusphy45/4fdx5rcd/)

### 参考链接
> [High DPI Canvas](https://www.html5rocks.com/en/tutorials/canvas/hidpi/)

	
