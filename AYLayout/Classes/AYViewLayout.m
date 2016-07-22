//
//  AYLayout.m
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright (c) 2015年 Alan Yeh. All rights reserved.
//

#import "AYViewLayout.h"

typedef NS_ENUM(NSInteger, AYViewLayoutMultiplyer) {
    AYViewLayoutMultiplyerNegative = -1, /**< 反向偏移 */
    AYViewLayoutMultiplyerPositive = 1   /**< 正向偏移 */
};

@interface AYResolveViewX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(AYViewLayoutMultiplyer)multiplyer;
@end

@interface AYResolveViewY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(AYViewLayoutMultiplyer)multiplyer;
@end

@interface AYResolveViewComplete ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYViewLayoutMultiplyer multiplyer;
@property (nonatomic, weak) UIView *view;
@property (nonatomic, weak) UIView *relatedView;
@property (nonatomic, strong) id owner;
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(AYViewLayoutMultiplyer)multiplyer;
@end

@implementation AYViewLayout{
    CGPoint _location;
    CGSize _size;
    UIView *_view;
    UIView *_relatedView;
}
#pragma mark - 初始化
+ (instancetype)layoutForView:(UIView *)view{
    return [[self alloc] initWithView:view];
}

- (instancetype)initWithView:(UIView *)view{
    if (self = [super init]) {
        _view = view ?: [[self class] ay_nil_view_for_layout];
        _size = _view.ay_size;
        _location = _view.ay_location;
    }
    return self;
}

+ (UIView *)ay_nil_view_for_layout{
    static UIView *ay_nil_view_instance;
    static UIView *ay_nil_view_superview_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ay_nil_view_instance = [UIView new];
        ay_nil_view_superview_instance = [UIView new];
        [ay_nil_view_superview_instance addSubview:ay_nil_view_instance];
    });
    
    return ay_nil_view_instance;
}

- (instancetype)init{
    return [self initWithView:[AYViewLayout ay_nil_view_for_layout]];
}
#pragma mark - 设置大小
- (AYViewLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        _size = CGSizeMake(width, height);
        return self;
    };
}

- (AYViewLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        _size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (AYResolveViewY * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(view.ay_x - _size.width, _location.y);
        return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(view.ay_x, _location.y);
        return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewY * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(view.ay_x + view.ay_width, _location.y);
        return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(view.ay_x + view.ay_width - _size.width, _location.y);
        return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewY * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(view.ay_x + (view.ay_width - _size.width) / 2, _location.y);
        return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewY *)alignParentLeft{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(0, _location.y);
    return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewY *)toParentLeft{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(-_size.width, _location.y);
    return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewY *)alignParentRight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ay_width - _size.width, _location.y);
    return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewY *)toParentRight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_view.superview.ay_width, _location.y);
    return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewY *)alignParentCenterWidth{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake((_view.superview.ay_width - _size.width) / 2, _location.y);
    return [[AYResolveViewY alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (AYResolveViewX * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(_location.x, view.ay_y - _size.height);
        return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(_location.x, view.ay_y);
        return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewX * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(_location.x, view.ay_y + view.ay_height);
        return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(_location.x, view.ay_y + view.ay_height - _size.height);
        return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewX * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:_view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        _location = CGPointMake(_location.x, view.ay_y + (view.ay_height - _size.height) / 2);
        return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:view multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewX *)alignParentTop{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, 0);
    return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewX *)toParentTop{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, - _size.height);
    return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewX *)alignParentBottom{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ay_height - _size.height);
    return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewX *)toParentBottom{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, _view.superview.ay_height + _size.height);
    return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewX *)alignParentCenterHeight{
    NSAssert(_view.superview, @"[ERROR]: could not find the superview");
    _location = CGPointMake(_location.x, (_view.superview.ay_height - _size.height) / 2);
    return [[AYResolveViewX alloc] initWithView:_view size:_size location:_location relatedView:nil multiplyer:AYViewLayoutMultiplyerPositive];
}

- (void)apply{
    _view.frame = (CGRect){_location, _size};
}

@end

@implementation AYResolveViewX
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(AYViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveViewX *)and{
    return self;
}

- (AYResolveViewX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x, self.location.y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)alignLeftV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + view.ay_width - self.size.width, self.location.y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewComplete *)alignRightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + self.relatedView.ay_width - self.size.width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toLeft{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x - self.size.width, self.location.y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewComplete *)toLeftV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x - self.size.width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toRight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + view.ay_width, self.location.y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)toRightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + self.relatedView.ay_width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterWidth{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(view.ay_x + (view.ay_width - self.size.width) / 2, self.location.y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)alignCenterWidthV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.relatedView.ay_x + (self.relatedView.ay_width - self.size.width) / 2, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)alignParentLeft{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(0, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)toParentLeft{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete *)alignParentRight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ay_width - self.size.width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete *)toParentRight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.view.superview.ay_width + self.size.width, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)alignParentCenterWidth{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake((self.view.superview.ay_width - self.size.width) / 2, self.location.y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation AYResolveViewY
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location relatedView:(UIView *)relatedView multiplyer:(AYViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.relatedView = relatedView;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveViewY *)and{
    return self;
}

- (AYResolveViewY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)alignTopV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + view.ay_height - self.size.height);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewComplete *)alignBottomV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + self.relatedView.ay_height - self.size.height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toTop{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y - self.size.height);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
    };
}

- (AYResolveViewComplete *)toTopV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y - self.size.height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))toBottom{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + view.ay_height);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)toBottomV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + self.relatedView.ay_height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete * _Nonnull (^)(UIView * _Nonnull))alignCenterHeight{
    return ^(UIView *_Nonnull view){
        if ([view isEqual:self.view.superview]) {
            NSLog(@"[WARNING]: relatedView is superview, check your expression");
        }
        self.location = CGPointMake(self.location.x, view.ay_y + (view.ay_height - self.size.height) / 2);
        return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
    };
}

- (AYResolveViewComplete *)alignCenterHeightV{
    NSAssert(self.relatedView, @"[ERROR]: could not find the relatedView");
    self.location = CGPointMake(self.location.x, self.relatedView.ay_y + (self.relatedView.ay_height - self.size.height) / 2);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)alignParentTop{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, 0);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)toParentTop{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete *)alignParentBottom{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ay_height - self.size.height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerNegative];
}

- (AYResolveViewComplete *)toParentBottom{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, self.view.superview.ay_height + self.size.height);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (AYResolveViewComplete *)alignParentCenterHeight{
    NSAssert(self.view.superview, @"[ERROR]: could not find the superview");
    self.location = CGPointMake(self.location.x, (self.view.superview.ay_height - self.size.height) / 2);
    return [[AYResolveViewComplete alloc] initWithView:self.view size:self.size location:self.location owner:self multiplyer:AYViewLayoutMultiplyerPositive];
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}
@end

@implementation AYResolveViewComplete
- (instancetype)initWithView:(UIView *)view size:(CGSize)size location:(CGPoint)location owner:(NSObject *)owner multiplyer:(AYViewLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.view = view;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveViewComplete * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[AYResolveViewY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.view.frame = (CGRect){self.location, self.size};
}

@end

@implementation UIView(Layout)

- (CGFloat)ay_x{
    return self.frame.origin.x;
}

- (void)setAy_x:(CGFloat)ay_x{
    self.frame = (CGRect){CGPointMake(ay_x, self.ay_y), self.ay_size};
}

- (CGFloat)ay_y{
    return self.frame.origin.y;
}

- (void)setAy_y:(CGFloat)ay_y{
    self.frame = (CGRect){CGPointMake(self.ay_x, ay_y), self.ay_size};
}

- (CGFloat)ay_width{
    return self.frame.size.width;
}

- (void)setAy_width:(CGFloat)ay_width{
    self.frame = (CGRect){self.ay_location, CGSizeMake(ay_width, self.ay_height)};
}

- (CGFloat)ay_height{
    return self.frame.size.height;
}

- (void)setAy_height:(CGFloat)ay_height{
    self.frame = (CGRect){self.ay_location, CGSizeMake(self.ay_width, ay_height)};
}

- (CGSize)ay_size{
    return self.frame.size;
}

- (void)setAy_size:(CGSize)ay_size{
    self.frame = (CGRect){self.ay_location, ay_size};
}

- (CGPoint)ay_location{
    return self.frame.origin;
}

- (void)setAy_location:(CGPoint)ay_location{
    self.frame = (CGRect){ay_location, self.ay_size};
}
@end
