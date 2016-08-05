# AYLayout

[![CI Status](http://img.shields.io/travis/alan-yeh/AYLayout.svg?style=flat)](https://travis-ci.org/alan-yeh/AYLayout)
[![Version](https://img.shields.io/cocoapods/v/AYLayout.svg?style=flat)](http://cocoapods.org/pods/AYLayout)
[![License](https://img.shields.io/cocoapods/l/AYLayout.svg?style=flat)](http://cocoapods.org/pods/AYLayout)
[![Platform](https://img.shields.io/cocoapods/p/AYLayout.svg?style=flat)](http://cocoapods.org/pods/AYLayout)

## 引入
　　使用[CocoaPods](http://cocoapods.org)可以很方便地引入AYLayout。Podfile添加AYLayout的依赖。

```ruby
pod "AYLayout"
```

## 简介
　　复杂业务、动画等，无法避免会用到代码布局，因此经常会在代码里充斥着xxxx.frame = CGRect(23, 55, 60, 11)之类布局代码，让人头晕目炫。写代码的同学估计也不会十分爽快，因为经常要去计算两个View的相对位置、相对父View的位置之类的（其实我就是这么走过来的），维护的同学看到这样的代码更是恶心想吐（我也是这么走过来的...）。

　　说到代码布局，不得不说到Masonry。Masonry是使用代码写Autolayout来布局，但是有时Autolayout在细节上很难定约束，不如frame来得直接爽快。几经尝试，最后觉得有的时候，Masonry还是有心无力。因此我写下AYLayout来布局UIView和CALayer，其本质上还是xxxx.frame = CGRect(xx,xx,xx,xx)，但是更直观。

　　由于UIView和CALayer采用的是不同的布局，所以我写了两个布局工具`AYLayoutV`和`AYLayoutL`，两者用法几乎一致。
## 用法
　　在AYLayout.h、PSViewLayout.h、PSLayerLayout.h中，对每个函数有详尽的注释。查看[AYLayout.h](https://github.com/alan-yeh/AYLayout/blob/master/AYLayout/Classes/AYLayout.h)可以学习布局语法。

　　AYLayout采用链式调用语法，代码语义化，比较直观。以下仅对[AYLayout.h](https://github.com/Poi-Son/PSKit/blob/master/PSKit/UIKits/Utils/AYLayout.h)中的代码进行解释。对照着`AYLayout.h`中的图示理解更轻松。


```objective-c
// view的大小为10*10，在relatedView的左方10px、下方30px的位置
[AYLayoutV(view).withSize(10, 10).toLeft(relatedView).distance(10).and.toBottomV.distance(30) apply];
// view的大小为10*10，在relatedView的右方30px、底部对齐的位置
[AYLayoutV(view).withSize(10, 10).toRight(relatedView).distance(30).and.alignBottomV apply];
// view的大小为10*10，距离父视图的左侧10px、底部30px的位置
[AYLayoutV(view).withSize(10, 10).alignParentLeft.distance(10).and.alignParentBottom.distance(30) apply];
// view的大小为10*10，在父视图底部外侧，并居中对齐
[AYLayoutV(view).withSize(10, 10).toParentBottom.and.alignParentCenterWidth apply];
// view的大小为10*10，在父视图左侧50px处，在relatedView下方的10px处
```

## License

AYLayout is available under the MIT license. See the LICENSE file for more info.
