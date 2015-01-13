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
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.redView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.redView.layer.shadowOffset = CGSizeMake(0, 1);
    self.redView.layer.shadowOpacity = 0.4;
}
- (IBAction)pan:(id)sender {
    CGPoint velocity = [(UIPanGestureRecognizer *)sender velocityInView:self.view];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    animation.toValue = [NSValue valueWithCGPoint:velocity];
    [self.likeImageView.layer pop_addAnimation:animation forKey:nil];
    
}
- (IBAction)likeButtonPressed:(id)sender {
    
    _liked = !_liked;
    [self.likeImageView setImage:[UIImage imageNamed:_liked?@"like": @"unlike"]];
    
//    popba
    POPSpringAnimation *likeAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    likeAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    likeAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    likeAnimation.springBounciness = 20;
    
    [self.likeImageView.layer pop_addAnimation:likeAnimation forKey:nil];
    
    [self applyRedViewAnimation];
    
    return;

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.values = @[@(0.1), @(1), @(1.5)];
    animation.keyTimes = @[@(0.0), @(0.5), @(0.75), @(1)];
    animation.calculationMode = kCAAnimationLinear;
//    animation.duration = 1.0;

    
    [self.likeImageView.layer addAnimation:animation forKey:nil];
    
}
- (void)applyRedViewAnimation
{
    CGFloat constant = _liked ? 100: 0;
    POPAnimatableProperty *constantProperty = [POPAnimatableProperty propertyWithName:@"constant" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(NSLayoutConstraint *constraint, CGFloat values[]) {
            values[0] = constraint.constant;
        };
        prop.writeBlock = ^(NSLayoutConstraint *constraint, const CGFloat values[]) {
            [constraint setConstant:values[0]];
        };
        
    }];
    
    POPSpringAnimation *constantAnimation = [POPSpringAnimation animation];
    constantAnimation.property = constantProperty;
    constantAnimation.fromValue = @(_bottomConstraint.constant);
    constantAnimation.toValue = @(constant);
    constantAnimation.springBounciness = 10;
    [_bottomConstraint pop_addAnimation:constantAnimation forKey:nil];
    
    return;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
//    opacityAnimation.beginTime = CACurrentMediaTime() + 0.1;
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue = @(1);
    [self.redView.layer pop_addAnimation:opacityAnimation forKey:nil];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 150)];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height - 200)];
    [self.redView.layer pop_addAnimation:positionAnimation forKey:nil];
    

    POPSpringAnimation *bounceAnimation =[POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    bounceAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];
    bounceAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    bounceAnimation.springBounciness = 10;
    [self.redView.layer pop_addAnimation:bounceAnimation forKey:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
