//
//  ScaleView.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/12.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ScaleView.h"
#import <POP.h>

@implementation ScaleView

- (void)awakeFromNib
{
//    CALayer *firstLayer  = [CALayer layer];
//    [firstLayer setFrame:CGRectMake(0, 0, 20, 20)];
//    [firstLayer setBackgroundColor:[UIColor redColor].CGColor];
//    [firstLayer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
//    [firstLayer setCornerRadius:10];
//    [self.layer addSublayer:firstLayer];
//    [self applyAinamationToLayer:firstLayer];
    self.count = 4;
    NSInteger vertical = self.count;
    for (int j = 0; j <vertical ; j ++) {
        for (int i = 0; i < self.count; i++) {
            CALayer *firstLayer  = [CALayer layer];
            [firstLayer setFrame:CGRectMake(i * 25, j * 25, 20, 20)];
            [firstLayer setBackgroundColor:[UIColor redColor].CGColor];
            //        [firstLayer setPosition:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)];
            [firstLayer setCornerRadius:10];
            [self.layer addSublayer:firstLayer];
            CGFloat delyed = self.count;
            [self applyAinamationToLayer:firstLayer delyed:i/delyed];
        }
    }


}

- (void)applyAinamationToLayer: (CALayer *)layer delyed: (CFTimeInterval)delyedTime
{
    POPBasicAnimation *baseAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    baseAnimation.duration = 1.0;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    baseAnimation.beginTime = delyedTime + CACurrentMediaTime();
    baseAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    baseAnimation.autoreverses = YES;
    baseAnimation.repeatCount = HUGE;
    [layer pop_addAnimation:baseAnimation forKey:nil];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
