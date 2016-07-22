//
//  AYLayerLayout.h
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright © 2015年 Alan Yeh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AYResolveLayerX;
@class AYResolveLayerY;
@class AYResolveLayerCompleted;

NS_ASSUME_NONNULL_BEGIN

#define AYLayoutL(layer) [AYLayerLayout layoutForLayer:layer]
/**
 *  Layer布局
 *  注: Parent系列布局函数, 在superlayer为空时, 则与layer所在的UIView中的位置进行布局
 */
@interface AYLayerLayout : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

+ (instancetype)layoutForLayer:(CALayer *)layer;
- (instancetype)initWithLayer:(CALayer *)layer NS_DESIGNATED_INITIALIZER;

@property (nonatomic, readonly) AYLayerLayout *(^withSize)(CGFloat width, CGFloat height);/**< 设置大小 */
@property (nonatomic, readonly) AYLayerLayout *(^withSizeS)(CGSize size);/**< 设置大小 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) AYResolveLayerY *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) AYResolveLayerY *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) AYResolveLayerY *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) AYResolveLayerY *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) AYResolveLayerY *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */

@property (nonatomic, readonly) AYResolveLayerY *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerY *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerY *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerY *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerY *alignParentCenterWidth;/**< 父Layer横向居中 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) AYResolveLayerX *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) AYResolveLayerX *(^toTop)(CALayer *relatedLayer);/**< 在上侧 */
@property (nonatomic, readonly) AYResolveLayerX *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) AYResolveLayerX *(^toBottom)(CALayer *relatedLayer);/**< 在下侧 */
@property (nonatomic, readonly) AYResolveLayerX *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */

@property (nonatomic, readonly) AYResolveLayerX *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerX *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerX *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerX *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerX *alignParentCenterHeight;/**< 父Layer竖下居中 */

- (void)apply;
@end

@interface AYResolveLayerX : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) AYResolveLayerX *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) AYResolveLayerX *(^distance)(CGFloat distance);/**< 修改Y的偏差 */

#pragma mark - 决定X的属性
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignLeft)(CALayer *relatedLayer);/**< 左对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignLeftL;/**< 与上一个relatedLayer左对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignRight)(CALayer *relatedLayer);/**< 右对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignRightL;/**< 与上一个relatedLayer右对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignCenterWidth)(CALayer *relatedLayer);/**< 横向居中对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignCenterWidthL;/**< 与上一个related横向居中对齐 */

@property (nonatomic, readonly) AYResolveLayerCompleted *(^toLeft)(CALayer *relatedLayer);/**< 在左侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *toLeftL;/**< 在上一个relatedLayer左侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^toRight)(CALayer *relatedLayer);/**< 在右侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *toRightL;/**< 在上一个relatedLayer右侧 */

@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentLeft;/**< 父Layer左对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *toParentLeft;/**< 父Layer左侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentRight;/**< 父Layer右对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *toParentRight;/**< 父Layer右侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentCenterWidth;/**< 父Layer横向居中 */

- (void)apply;
@end

@interface AYResolveLayerY : NSObject
- (instancetype)init __attribute__((unavailable("不允许直接实例化")));
+ (instancetype)new __attribute__((unavailable("不允许直接实例化")));

@property (nonatomic, readonly) AYResolveLayerY *and;/**< 连词, 无操作 */
@property (nonatomic, readonly) AYResolveLayerY *(^distance)(CGFloat distance);/**< 修改X的偏差 */

#pragma mark - 决定Y的属性
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignTop)(CALayer *relatedLayer);/**< 上对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignTopL;/**< 与上一个relatedLayer上对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignBottom)(CALayer *relatedLayer);/**< 下对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignBottomL;/**< 与上一个relatedLayer下对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^alignCenterHeight)(CALayer *relatedLayer);/**< 竖向居中对齐 */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignCenterHeightL;/**< 与上一个relatedLayer竖向居中对齐 */

@property (nonatomic, readonly) AYResolveLayerCompleted *(^toTop)(CALayer *relatedLayer);/**< 上侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *toTopL;/**< 在上一个relatedLayer上侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *(^toBottom)(CALayer *relatedLayer);/**< 下侧 */
@property (nonatomic, readonly) AYResolveLayerCompleted *toBottomL;/**< 在上一个relatedLayer下侧 */

@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentTop;/**< 父Layer上对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *toParentTop;/**< 父Layer顶侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentBottom;/**< 父Layer下对齐(内侧, 可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *toParentBottom;/**< 父Layer底侧(外侧, 不可见) */
@property (nonatomic, readonly) AYResolveLayerCompleted *alignParentCenterHeight;/**< 父Layer竖向居中 */

- (void)apply;
@end

@interface AYResolveLayerCompleted : NSObject
@property (nonatomic, readonly) AYResolveLayerCompleted *(^distance)(CGFloat distance);

- (void)apply;
@end

@interface CALayer (Layout)
@property (nonatomic, assign) CGFloat ay_x;
@property (nonatomic, assign) CGFloat ay_y;
@property (nonatomic, assign) CGFloat ay_width;
@property (nonatomic, assign) CGFloat ay_height;
@property (nonatomic, assign) CGSize ay_size;
@property (nonatomic, assign) CGPoint ay_location;
@end
NS_ASSUME_NONNULL_END