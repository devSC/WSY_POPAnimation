//
//  CircleView.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/15.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "CircleView.h"

@interface CircleView()

@property (assign) CGFloat strokeWidth;
@property (strong, nonatomic) NSMutableArray *progressLayers;

@property (strong, nonatomic) CALayer *currentProgressLayer;
@property (nonatomic, assign, getter = isCircleComplete) BOOL circleComplete;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, strong) UIBezierPath *circlePath;

@end
@implementation CircleView



- (NSMutableArray *)progressLayers
{
    if (!_progressLayers) {
        _progressLayers = [NSMutableArray new];
    }
    return _progressLayers;
}

- (void)awakeFromNib
{

    self.strokeWidth = 5;
    self.duration = 10;
    
    _circlePath = [UIBezierPath bezierPath];
    [_circlePath addArcWithCenter:CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2) radius:100 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    
    CAShapeLayer *grayCircleLayer = [CAShapeLayer layer];
    grayCircleLayer.lineWidth = self.strokeWidth;
    grayCircleLayer.strokeEnd = 1;
    grayCircleLayer.strokeColor = [UIColor grayColor].CGColor;
    grayCircleLayer.fillColor = [UIColor clearColor].CGColor;
    
    grayCircleLayer.path = _circlePath.CGPath;
    [self.layer addSublayer:grayCircleLayer];
    
    
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.path = _circlePath.CGPath;
    
    progressLayer.strokeColor = [[self randomColor] CGColor];
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    progressLayer.lineWidth = self.strokeWidth;
    progressLayer.strokeEnd = 0.f;
    [self.layer addSublayer:progressLayer];
    
    [self.progressLayers addObject:progressLayer];
}
//- (void)

- (void)addNewLayer
{
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.path = self.circlePath.CGPath;
    progressLayer.strokeColor = [[self randomColor] CGColor];
    progressLayer.fillColor = [[UIColor clearColor] CGColor];
    progressLayer.lineWidth = self.strokeWidth;
    progressLayer.strokeEnd = 0.f;
    
    [self.layer addSublayer:progressLayer];
    [self.progressLayers addObject:progressLayer];
    
    self.currentProgressLayer = progressLayer;
}


- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.f];
}


- (void)updateAnimations
{
    CGFloat duration = self.duration * (1.f - [[self.progressLayers firstObject] strokeEnd]);
    NSLog(@"duration: %f", duration);
    
    CGFloat strokeEndFinal = 1.f;
    
    for (CAShapeLayer *progressLayer in self.progressLayers)
    {
        CABasicAnimation *strokeEndAnimation = nil;
        strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokeEndAnimation.duration = duration;
        strokeEndAnimation.fromValue = @(progressLayer.strokeEnd);
        strokeEndAnimation.toValue = @(strokeEndFinal);
        strokeEndAnimation.autoreverses = NO;
        strokeEndAnimation.repeatCount = 0.f;
        
        CGFloat previousStrokeEnd = progressLayer.strokeEnd;
        progressLayer.strokeEnd = strokeEndFinal;
        
        [progressLayer addAnimation:strokeEndAnimation forKey:@"strokeEndAnimation"];
        
        strokeEndFinal -= (previousStrokeEnd - progressLayer.strokeStart);
        
        if (progressLayer != self.currentProgressLayer)
        {
            CABasicAnimation *strokeStartAnimation = nil;
            strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
            strokeStartAnimation.duration = duration;
            strokeStartAnimation.fromValue = @(progressLayer.strokeStart);
            strokeStartAnimation.toValue = @(strokeEndFinal);
            strokeStartAnimation.autoreverses = NO;
            strokeStartAnimation.repeatCount = 0.f;
            
            progressLayer.strokeStart = strokeEndFinal;
            [progressLayer addAnimation:strokeStartAnimation forKey:@"strokeStartAnimation"];
        }
    }
    
    CABasicAnimation *backgroundLayerAnimation = nil;
    backgroundLayerAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    backgroundLayerAnimation.duration = duration;
    backgroundLayerAnimation.fromValue = @(self.backgroundLayer.strokeStart);
    backgroundLayerAnimation.toValue = @(1.f);
    backgroundLayerAnimation.autoreverses = NO;
    backgroundLayerAnimation.repeatCount = 0.f;
    backgroundLayerAnimation.delegate = self;
    
    self.backgroundLayer.strokeStart = 1.0;
    
    [self.backgroundLayer addAnimation:backgroundLayerAnimation forKey:@"strokeStartAnimation"];
}

- (void)updateLayerModelsForPresentationState
{
    for (CAShapeLayer *progressLayer in self.progressLayers)
    {
        progressLayer.strokeStart = [progressLayer.presentationLayer strokeStart];
        progressLayer.strokeEnd = [progressLayer.presentationLayer strokeEnd];
        NSLog(@"strokeStart: %f, strokeEnd: %f", [progressLayer.presentationLayer strokeStart], [progressLayer.presentationLayer strokeEnd]);
        
        [progressLayer removeAllAnimations];
    }
    
    self.backgroundLayer.strokeStart = [self.backgroundLayer.presentationLayer strokeStart];
    [self.backgroundLayer removeAllAnimations];
}

#pragma UIResponder overrides

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isCircleComplete == NO)
    {
        [self addNewLayer];
        [self updateAnimations];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isCircleComplete == NO)
    {
        [self updateLayerModelsForPresentationState];
    }
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.isCircleComplete == NO && flag)
    {
        self.circleComplete = flag;
    }
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
