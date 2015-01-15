//
//  GradientView.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/15.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "GradientView.h"
@interface GradientView()
@property (nonatomic, readonly) CALayer *maskLayer;
@property (nonatomic, assign) CGFloat progress;
@end

@implementation GradientView
@synthesize maskLayer;
@synthesize progress;

+ (Class)layerClass
{
    return [CAGradientLayer class];
}

- (void)awakeFromNib
{
    CAGradientLayer *layer = (id)self.layer;
    [layer setStartPoint:CGPointMake(0, 0.5)];
    [layer setEndPoint:CGPointMake(1.0, 0.5)];
    
    NSMutableArray *colors = [NSMutableArray array];
    
    for (NSInteger hue = 0; hue < 360; hue += 5) {
        
        UIColor *color;
        color = [UIColor colorWithHue:1.0 * hue / 360.0
                           saturation:1.0
                           brightness:1.0
                                alpha:1.0];
        [colors addObject:(id)[color CGColor]];
    }
    [layer setColors:[NSArray arrayWithArray:colors]];
    [self performAnimation];
    
    maskLayer = [CALayer layer];
    [maskLayer setFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    [maskLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [layer setMask:maskLayer];
}

- (void)performAnimation
{
    // Move the last color in the array to the front
    // shifting all the other colors.
    CAGradientLayer *layer = (id)self.layer;
    NSMutableArray *mutable = [[layer colors] mutableCopy];
    id lastColor = [mutable lastObject];
    [mutable removeLastObject];
    
    [mutable insertObject:lastColor atIndex:0];
    
    NSArray *shiftColors = [NSArray arrayWithArray:mutable];
    
    // Update the colors on the model layer
    [layer setColors:shiftColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    [animation setToValue:shiftColors];
    [animation setDuration:0.08];
    [animation setFillMode:kCAFillModeForwards];
    [animation setDelegate:self];
    [layer addAnimation:animation forKey:@"animationGradient"];
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self performAnimation];
}

- (void)setProgress:(CGFloat)value {
    if (progress != value) {
        // Progress values go from 0.0 to 1.0
        progress = MIN(1.0, fabs(value));
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    // Resize our mask layer based on the current progress
    CGRect maskRect = [maskLayer frame];
    maskRect.size.width = CGRectGetWidth([self bounds]) * progress;
    [maskLayer setFrame:maskRect];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
