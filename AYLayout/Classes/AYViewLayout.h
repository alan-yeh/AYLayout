//
//  AYLayout.h
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright (c) 2015年 Alan Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AYResolveViewX;
@class AYResolveViewY;
@class AYResolveViewComplete;

#define AYLayoutV(view) [AYViewLayout layoutForView:view]

NS_ASSUME_NONNULL_BEGIN
/**
 *  根据frame设置View的位置, 此类不适用于AutoLayout
 */
@interface AYViewLayout : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

+ (instancetype)layoutForView:(UIView *)view;
- (instancetype)initWithView:(UIView *)view NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) AYViewLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) AYViewLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) AYResolveViewY *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) AYResolveViewY *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) AYResolveViewY *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) AYResolveViewY *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) AYResolveViewY *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */

@property (nonatomic, readonly) AYResolveViewY *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewY *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewY *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewY *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewY *alignParentCenterWidth;/**< 父View横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) AYResolveViewX *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) AYResolveViewX *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) AYResolveViewX *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) AYResolveViewX *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) AYResolveViewX *(^alignCenterHeight)(UIView *relatedView);/**< 竖向居中对齐 */

@property (nonatomic, readonly) AYResolveViewX *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewX *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewX *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewX *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewX *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface AYResolveViewX : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) AYResolveViewX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) AYResolveViewX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) AYResolveViewComplete *(^alignLeft)(UIView *relatedView);/**< 左对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignLeftV;/**< 与上一个relatedView左对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *(^alignRight)(UIView *relatedView);/**< 右对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignRightV;/**< 与上一个relatedView右对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *(^alignCenterWidth)(UIView *relatedView);/**< 横向居中对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignCenterWidthV;/**< 与上一个relatedView横向居中对齐 */

@property (nonatomic, readonly) AYResolveViewComplete *(^toLeft)(UIView *relatedView);/**< 在左侧 */
@property (nonatomic, readonly) AYResolveViewComplete *toLeftV;/**< 在上一个relatedView左侧 */
@property (nonatomic, readonly) AYResolveViewComplete *(^toRight)(UIView *relatedView);/**< 在右侧 */
@property (nonatomic, readonly) AYResolveViewComplete *toRightV;/**< 在上一个relatedView右侧 */

@property (nonatomic, readonly) AYResolveViewComplete *alignParentLeft;/**< 父View左侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewComplete *toParentLeft;/**< 父View左侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewComplete *alignParentRight;/**< 父View右侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewComplete *toParentRight;/**< 父View右侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewComplete *alignParentCenterWidth;/**< 父View横向居中 */

- (void)apply;
@end

@interface AYResolveViewY : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) AYResolveViewY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) AYResolveViewY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) AYResolveViewComplete *(^alignTop)(UIView *relatedView);/**< 上对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignTopV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *(^alignBottom)(UIView *relatedView);/**< 下对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignBottomV;/**< 与上一个relatedView上对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *(^alignCenterHeight)(UIView *relatedView);/**< 居中对齐 */
@property (nonatomic, readonly) AYResolveViewComplete *alignCenterHeightV;/**< 与上一个relatedView居中对齐 */

@property (nonatomic, readonly) AYResolveViewComplete *(^toTop)(UIView *relatedView);/**< 在上侧 */
@property (nonatomic, readonly) AYResolveViewComplete *toTopV;/**< 在上一个relatedView上侧 */
@property (nonatomic, readonly) AYResolveViewComplete *(^toBottom)(UIView *relatedView);/**< 在下侧 */
@property (nonatomic, readonly) AYResolveViewComplete *toBottomV;/**< 在上一个relatedView下侧 */

@property (nonatomic, readonly) AYResolveViewComplete *alignParentTop;/**< 父View顶侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewComplete *toParentTop;/**< 父View顶侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewComplete *alignParentBottom;/**< 父View底侧(内侧, 可见) */
@property (nonatomic, readonly) AYResolveViewComplete *toParentBottom;/**< 父View底侧(外侧, 不可见区域, 常用于动画准备位置) */
@property (nonatomic, readonly) AYResolveViewComplete *alignParentCenterHeight;/**< 父View竖向居中 */

- (void)apply;
@end

@interface AYResolveViewComplete : NSObject
@property (nonatomic, readonly) AYResolveViewComplete *(^distance)(CGFloat distance);

- (void)apply;
@end


@interface UIView (Layout)
@property (nonatomic, assign) CGFloat ay_x;/**< view.frame.origin.x */
@property (nonatomic, assign) CGFloat ay_y;/**< view.frame.origin.y */
@property (nonatomic, assign) CGFloat ay_width;/**< view.frame.size.width */
@property (nonatomic, assign) CGFloat ay_height;/**< view.frame.size.height */
@property (nonatomic, assign) CGSize ay_size;/**< view.frame.size */
@property (nonatomic, assign) CGPoint ay_location;/**< view.frame.origin */
@end
NS_ASSUME_NONNULL_END