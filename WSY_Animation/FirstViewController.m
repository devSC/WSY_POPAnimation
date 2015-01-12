//
//  FirstViewController.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/12.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "FirstViewController.h"
#import <POP.h>

@interface FirstViewController ()
{
    BOOL _liked;
}
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)likeButtonPressed:(id)sender {
    _liked = !_liked;
    [self.likeImageView setImage:[UIImage imageNamed:_liked?@"like": @"unlike"]];
    
//    popba
    POPSpringAnimation *likeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    likeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.5, 1.5)];
    likeAnimation.springBounciness = 10;
    
    [self.likeImageView.layer pop_addAnimation:likeAnimation forKey:nil];
    return;

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.75), @(1)];
    animation.calculationMode = kCAAnimationLinear;
//    animation.duration = 1.0;

    
    [self.likeImageView.layer addAnimation:animation forKey:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
