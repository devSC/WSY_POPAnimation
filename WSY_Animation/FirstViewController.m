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
    CGFloat _endAngle;
}
@property (weak, nonatomic) IBOutlet UIImageView *likeImageView;
@property (weak, nonatomic) IBOutlet UIView *redView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIView *circleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.redView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.redView.layer.shadowOffset = CGSizeMake(0, 1);
    self.redView.layer.shadowOpacity = 0.4;
    
    
    self.circleView = [[UIView alloc] init];
    [self.circleView setFrame:CGRectMake(0, 0, 50, 50)];
    [self.circleView setCenter:CGPointMake(self.view.center.x, 200)];
    
    [self.circleView.layer setCornerRadius:25];
    [self.circleView setBackgroundColor:[UIColor greenColor]];
    [self.circleView.layer setMasksToBounds:YES];
    self.circleView.layer.transform = CATransform3DIdentity;
    
    [self.view addSubview:_circleView];
    
//    UIBezierPath *circlePath = [UIBezierPath bezierPath];
////    [circlePath moveToPoint:CGPointMake(self.circleView.center.x, 0)];
//    [circlePath addArcWithCenter:self.circleView.center radius:25 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
//    
//    
//    CAShapeLayer *circleLayer = [CAShapeLayer layer];
//    circleLayer.lineWidth = 2;
//    circleLayer.strokeEnd = 1;
//    circleLayer.strokeColor = [UIColor redColor].CGColor;
//    circleLayer.lineJoin = kCALineJoinRound;
//    circleLayer.lineCap = kCALineCapRound;
//    circleLayer.path = circlePath.CGPath;
//    circleLayer.fillColor = [UIColor clearColor].CGColor;
//    
//    [self.circleView.layer addSublayer:circleLayer];

    
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
    
    [self applyNumberLabelAnimation];
    [self applyTableViewAnimation];
    [self applyCircleViewLayer];
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

- (void)applyNumberLabelAnimation
{
    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"numberAnimation" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(UILabel *label, CGFloat values[]){
            values[0] = label.description.floatValue;
        };
        prop.writeBlock = ^(UILabel *label, const CGFloat values[]) {
            [label setText:[NSString stringWithFormat:@"%.1f", values[0]]];
        };
    }];
    
    POPBasicAnimation *animation = [POPBasicAnimation animation];
    animation.property = property;
    animation.fromValue = @(0.0);
    animation.toValue = @(100);
    animation.duration = 4;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
    
    [self.numberLabel pop_addAnimation:animation forKey:nil];
    
}

- (void)applyTableViewAnimation
{
    CGFloat value = _liked? -1000:self.view.center.y;
    
    POPSpringAnimation *baseAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    baseAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, value)];
    [self.tableView pop_addAnimation:baseAnimation forKey:nil];

}
- (void)applyCircleViewLayer
{
//    _liked?[self scaleCircle] : [self blowUpScale];

   
}

- (void)scaleCircle
{
    [self.circleView.layer pop_removeAllAnimations];
    for (CALayer *layer in self.circleView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(25, 25)];
    [path addLineToPoint:CGPointMake(575, 25)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
    shapeLayer.strokeEnd = 0;
    shapeLayer.lineWidth = 26;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.path = path.CGPath;
    
    [self.circleView.layer addSublayer:shapeLayer];
    
    POPSpringAnimation *boundsAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 600, 50)];
    boundsAnimation.springBounciness = 20;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.3, 0.3)];
    scaleAnimation.springBounciness = 5;
    
    [boundsAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        UIGraphicsBeginImageContextWithOptions(self.circleView.frame.size, NO, 0.0);
        POPBasicAnimation *baseAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
        baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        baseAnimation.duration = 2.0;
        baseAnimation.fromValue = @(0.0);
        baseAnimation.toValue = @(1.0);
        [shapeLayer pop_addAnimation:baseAnimation forKey:nil];
        [baseAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
            if (finished) {
//                UIGraphicsEndImageContext();
            }
        }];
    }];
    
    [self.circleView.layer pop_addAnimation:boundsAnimation forKey:nil];
    [self.circleView.layer pop_addAnimation:scaleAnimation forKey:nil];


}
- (void)blowUpScale
{
    [self.circleView.layer pop_removeAllAnimations];
    for (CALayer *layer in self.circleView.layer.sublayers) {
        [layer removeFromSuperlayer];
    }
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath addArcWithCenter:self.circleView.center radius:25 startAngle:-M_PI_4 endAngle:M_PI_4 *7 clockwise:YES];
    
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = 1;
    circleLayer.strokeEnd = 0;
    circleLayer.strokeColor = [UIColor redColor].CGColor;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.path = circlePath.CGPath;
    
    [self.view.layer addSublayer:circleLayer];
    
    
    POPSpringAnimation *boundsAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    boundsAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, 200, 50, 50)];
    boundsAnimation.springBounciness = 5;
    [self.circleView.layer pop_addAnimation:boundsAnimation forKey:nil];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1, 1)];
    scaleAnimation.springBounciness = 7;
    [self.circleView.layer pop_addAnimation:scaleAnimation forKey:nil];
    
    scaleAnimation.completionBlock = ^(POPAnimation *animation, BOOL finished) {
        if (finished) {
            POPBasicAnimation *baseAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
            baseAnimation.fromValue = @0.0;
            baseAnimation.toValue = @1.0;
            baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            baseAnimation.duration = 2.0;
            [circleLayer pop_addAnimation:baseAnimation forKey:nil];
        }
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
