//
//  ThirdViewController.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ThirdViewController.h"
#import <POP.h>
#import <objc/runtime.h>

@interface ThirdViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *middleView;

@end

@implementation ThirdViewController
static char overviewKey;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bottomView.layer.cornerRadius = 100;
    [self.bottomView.layer setMasksToBounds:YES];
    
    
    self.middleView.layer.cornerRadius = 100;
    [self.middleView.layer setMasksToBounds:YES];

    objc_setAssociatedObject(self.bottomView, &overviewKey, @"haha", OBJC_ASSOCIATION_RETAIN);
    
    CAGradientLayer *topShadowLayer = [CAGradientLayer layer];
    
    topShadowLayer.frame = CGRectMake(0, 0, 200, 200);
    topShadowLayer.colors =  @[(__bridge id)[UIColor whiteColor].CGColor,
                               (__bridge id)[UIColor blackColor].CGColor];
    topShadowLayer.startPoint = CGPointMake(0.5, 0);
    topShadowLayer.endPoint = CGPointMake(0.5, 1.);
    topShadowLayer.opacity = 0.1;
    [self.bottomView.layer addSublayer:topShadowLayer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)startAnimation:(id)sender {
    
    NSString *string = objc_getAssociatedObject(self.bottomView, &overviewKey);
    NSLog(@"%@", string);
    [self.bottomView.layer removeAllAnimations];
    
    [self animation];
    
    return;
    POPBasicAnimation *bAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotationX];
    bAnimation.toValue = @(-M_PI);
    bAnimation.duration = 3;
    bAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    bAnimation.removedOnCompletion = NO;
    
    [self.bottomView.layer pop_addAnimation:bAnimation forKey:nil];
//    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"content" initializer:^(POPMutableAnimatableProperty *prop) {
//        prop.readBlock = ^(CALayer *layer, CGFloat values[]) {
//            values[0] = [layer.contents floatValue];
//        };
//        prop.writeBlock = ^(CALayer *layer, CGFloat const values[]) {
//            layer.contents = [NSString stringWithFormat:@"%f", values[0]];
//        };
//    }];
//    
//    POPBasicAnimation *cAnimation = [POPBasicAnimation animation];
//    cAnimation.property = property;
//    cAnimation.fromValue = (id)[UIImage imageNamed:@"r_icon"].CGImage;
//    cAnimation.toValue = (id)[UIImage imageNamed:@"r_hamburger"].CGImage;
//    cAnimation.duration = 0.1;
//    cAnimation.beginTime = CACurrentMediaTime() + 1.5;
//    cAnimation.removedOnCompletion = NO;
//    [self.bottomView.layer pop_addAnimation:cAnimation forKey:nil];
    CABasicAnimation *cAnimation = [CABasicAnimation animationWithKeyPath:@"contents"];
    cAnimation.fromValue = (id)[UIImage imageNamed:@"r_icon"].CGImage;
    cAnimation.toValue = (id)[UIImage imageNamed:@"r_hamburger"].CGImage;
    cAnimation.duration = 0.1;
    cAnimation.beginTime = CACurrentMediaTime() + 1.5;
    cAnimation.removedOnCompletion = NO;
    cAnimation.fillMode = kCAFillModeForwards;
    [cAnimation setDelegate:self];
    [self.bottomView.layer addAnimation:cAnimation forKey:nil];
    
    
    
}

- (void)animation
{
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    basicAnimation.duration = 2.0f;
    basicAnimation.fillMode = kCAFillModeForwards;

    basicAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_2, 1, 0, 0)];
    basicAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0, 0, 0, 0)];
    
    [self.bottomView.layer addAnimation:basicAnimation forKey:nil];
    

    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
