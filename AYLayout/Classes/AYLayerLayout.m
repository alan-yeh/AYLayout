//
//  AYLayerLayout.m
//  AYLayout
//
//  Created by Alan Yeh on 07/22/2016.
//  Copyright © 2015年 Alan Yeh. All rights reserved.
//

#import "AYLayerLayout.h"

typedef NS_ENUM(NSInteger, AYLayerLayoutMultiplyer) {
    AYLayerLayoutMultiplyerNegative = -1,  /**< 反向偏移 */
    AYLayerLayoutMultiplyerPositive = 1    /**< 正向偏移 */
};

@interface CALayer (AY_SUPER_SIZE)
@property (nonatomic, readonly) CGSize _superlayer_or_superview_size;/**< 父view或父layer的大小 */
@end

@interface AYResolveLayerX ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(AYLayerLayoutMultiplyer)multiplyer;
@end

@interface AYResolveLayerY ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(AYLayerLayoutMultiplyer)multiplyer;
@end

@interface AYResolveLayerCompleted ()
@property (nonatomic, assign) CGPoint location;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) AYLayerLayoutMultiplyer multiplyer;
@property (nonatomic, weak) CALayer *layer;
@property (nonatomic, weak) CALayer *relatedLayer;
@property (nonatomic, strong) id owner;
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(AYLayerLayoutMultiplyer)multiplyer;
@end

@implementation AYLayerLayout{
    CGPoint _location;
    CGSize _size;
    CALayer *_layer;
    CALayer *_relatedLayer;
}
#pragma mark - 初始化
- (instancetype)initWithLayer:(CALayer *)layer{
    if (self = [super init]) {
        _layer = layer ?: [[self class] ay_nil_layer_for_layout];
        _size = _layer.ay_size;
        _location = _layer.ay_location;
    }
    return self;
}

+ (instancetype)layoutForLayer:(CALayer *)layer{
    return [[self alloc] initWithLayer:layer];
}

+ (CALayer *)ay_nil_layer_for_layout{
    static CALayer *ay_nil_layer_instance;
    static CALayer *ay_nil_layer_superlayer_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ay_nil_layer_instance = [CALayer layer];
        ay_nil_layer_superlayer_instance = [CALayer layer];
        [ay_nil_layer_superlayer_instance addSublayer:ay_nil_layer_instance];
    });
    return ay_nil_layer_instance;
}
#pragma mark - 设置大小
- (AYLayerLayout * _Nonnull (^)(CGFloat, CGFloat))withSize{
    return ^(CGFloat width, CGFloat height){
        _size = CGSizeMake(width, height);
        return self;
    };
}

- (AYLayerLayout * _Nonnull (^)(CGSize))withSizeS{
    return ^(CGSize size){
        _size = size;
        return self;
    };
}

#pragma mark - 决定X的属性
- (AYResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ay_x - _size.width, _location.y);
        return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ay_x, _location.y);
        return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ay_x + layer.ay_width, _location.y);
        return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ay_x + layer.ay_width - _size.width, _location.y);
        return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerY * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        _location = CGPointMake(layer.ay_x + (layer.ay_width - _size.width) / 2, _location.y);
        return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerY *)alignParentLeft{
    _location = CGPointMake(0, _location.y);
    return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerY *)toParentLeft{
    _location = CGPointMake(-_size.width, _location.y);
    return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerY *)alignParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width - _size.width, _location.y);
    return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerY *)toParentRight{
    _location = CGPointMake(_layer._superlayer_or_superview_size.width, _location.y);
    return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerY *)alignParentCenterWidth{
    _location = CGPointMake((_layer._superlayer_or_superview_size.width - _size.width)/ 2, _location.y);
    return [[AYResolveLayerY alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

#pragma mark - 决定Y的属性
- (AYResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ay_y - _size.height);
        return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ay_y);
        return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ay_y + layer.ay_height);
        return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ay_y + layer.ay_height - _size.height);
        return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerX * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer * _Nonnull layer){
        _location = CGPointMake(_location.x, layer.ay_y + (layer.ay_height - _size.height) / 2);
        return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:layer multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerX *)alignParentTop{
    _location = CGPointMake(_location.x, 0);
    return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerX *)toParentTop{
    _location = CGPointMake(_location.x, - _size.height);
    return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerX *)alignParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height - _size.height);
    return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerX *)toParentBottom{
    _location = CGPointMake(_location.x, _layer._superlayer_or_superview_size.height + _size.height);
    return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerX *)alignParentCenterHeight{
    _location = CGPointMake(_location.x, (_layer._superlayer_or_superview_size.height - _size.height) / 2);
    return [[AYResolveLayerX alloc] initWithLayer:_layer size:_size location:_location relatedLayer:nil multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (void)apply{
    _layer.ay_size = _size;
    _layer.ay_location = _location;
}
@end

@implementation AYResolveLayerX
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(AYLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveLayerX *)and{
    return self;
}

- (AYResolveLayerX * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        return self;
    };
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x, self.location.y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)alignLeftL{
    self.location = CGPointMake(self.relatedLayer.ay_x, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + layer.ay_width - self.size.width, self.location.y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerCompleted *)alignRightL{
    self.location = CGPointMake(self.relatedLayer.ay_x + self.relatedLayer.ay_width - self.size.width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toLeft{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x - self.size.width, self.location.y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerCompleted *)toLeftL{
    self.location = CGPointMake(self.relatedLayer.ay_x - self.size.width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toRight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + layer.ay_width, self.location.y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)toRightL{
    self.location = CGPointMake(self.relatedLayer.ay_x + self.relatedLayer.ay_width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterWidth{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(layer.ay_x + (layer.ay_width - self.size.width) / 2, self.location.y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)alignCenterWidthL{
    self.location = CGPointMake(self.relatedLayer.ay_x + (self.relatedLayer.ay_width - self.size.width) / 2, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)alignParentLeft{
    self.location = CGPointMake(0, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)toParentLeft{
    self.location = CGPointMake(-self.size.width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted *)alignParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width - self.size.width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted *)toParentRight{
    self.location = CGPointMake(self.layer._superlayer_or_superview_size.width + self.size.width, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)alignParentCenterWidth{
    self.location = CGPointMake((self.layer._superlayer_or_superview_size.width - self.size.width) / 2, self.location.y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}
@end

@implementation AYResolveLayerY
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location relatedLayer:(CALayer *)relatedLayer multiplyer:(AYLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.relatedLayer = relatedLayer;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveLayerY *)and{
    return self;
}

- (AYResolveLayerY * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        return self;
    };
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)alignTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + layer.ay_height - self.size.height);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerCompleted *)alignBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + self.relatedLayer.ay_height - self.size.height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toTop{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y - self.size.height);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
    };
}

- (AYResolveLayerCompleted *)toTopL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y - self.size.height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))toBottom{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + layer.ay_height);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)toBottomL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + self.relatedLayer.ay_height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted * _Nonnull (^)(CALayer * _Nonnull))alignCenterHeight{
    return ^(CALayer *_Nonnull layer){
        self.location = CGPointMake(self.location.x, layer.ay_y + (layer.ay_height - self.size.height) / 2);
        return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
    };
}

- (AYResolveLayerCompleted *)alignCenterHeightL{
    self.location = CGPointMake(self.location.x, self.relatedLayer.ay_y + (self.relatedLayer.ay_height - self.size.height) / 2);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)alignParentTop{
    self.location = CGPointMake(self.location.x, 0);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)toParentTop{
    self.location = CGPointMake(self.location.x, -self.size.height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted *)alignParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height - self.size.height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerNegative];
}

- (AYResolveLayerCompleted *)toParentBottom{
    self.location = CGPointMake(self.location.x, self.layer._superlayer_or_superview_size.height + self.size.height);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (AYResolveLayerCompleted *)alignParentCenterHeight{
    self.location = CGPointMake(self.location.x, (self.layer._superlayer_or_superview_size.height - self.size.height) / 2);
    return [[AYResolveLayerCompleted alloc] initWithLayer:self.layer size:self.size location:self.location owner:self multiplyer:AYLayerLayoutMultiplyerPositive];
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}
@end
@implementation AYResolveLayerCompleted
- (instancetype)initWithLayer:(CALayer *)layer size:(CGSize)size location:(CGPoint)location owner:(id)owner multiplyer:(AYLayerLayoutMultiplyer)multiplyer{
    if (self = [super init]) {
        self.layer = layer;
        self.size = size;
        self.location = location;
        self.owner = owner;
        self.multiplyer = multiplyer;
    }
    return self;
}

- (AYResolveLayerCompleted * _Nonnull (^)(CGFloat))distance{
    return ^(CGFloat distance){
        if ([self.owner isKindOfClass:[AYResolveLayerY class]]) {
            self.location = CGPointMake(self.location.x, self.location.y + distance * self.multiplyer);
        }else{
            self.location = CGPointMake(self.location.x + distance * self.multiplyer, self.location.y);
        }
        return self;
    };
}

- (void)apply{
    self.layer.ay_size = self.size;
    self.layer.ay_location = self.location;
}

@end


@implementation CALayer (Layout)

- (CGFloat)ay_x{
    return self.position.x - self.anchorPoint.x * self.ay_width;
}

- (void)setAy_x:(CGFloat)ay_x{
    self.position = CGPointMake(ay_x + self.anchorPoint.x * self.ay_width, self.position.y);
}

- (CGFloat)ay_y{
    return self.position.y - self.anchorPoint.y * self.ay_height;
}

- (void)setAy_y:(CGFloat)ay_y{
    self.position = CGPointMake(self.position.x, ay_y + self.anchorPoint.y * self.ay_height);
}

- (CGFloat)ay_width{
    return self.bounds.size.width;
}

- (void)setAy_width:(CGFloat)ay_width{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(ay_width, self.ay_height)};
}

- (CGFloat)ay_height{
    return self.bounds.size.height;
}

- (void)setAy_height:(CGFloat)ay_height{
    self.bounds = (CGRect){CGPointZero, CGSizeMake(self.ay_width, ay_height)};
}

- (CGSize)ay_size{
    return self.bounds.size;
}

- (void)setAy_size:(CGSize)ay_size{
    self.bounds = (CGRect){CGPointZero, ay_size};
}

- (CGPoint)ay_location{
    return CGPointMake(self.ay_x, self.ay_y);
}

- (void)setAy_location:(CGPoint)ay_location{
    self.position = CGPointMake(ay_location.x + self.anchorPoint.x * self.ay_width, ay_location.y + self.anchorPoint.y * self.ay_height);
}
@end

@implementation CALayer (AY_SUPER_SIZE)
- (CGSize)_superlayer_or_superview_size{
    NSAssert(self.superlayer, @"can't find superlayer in layer:%@", self);
    return self.superlayer.ay_size;
}
@end
