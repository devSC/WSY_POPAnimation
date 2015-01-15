//
//  SecondViewController.m
//  WSY_Animation
//
//  Created by 袁仕崇 on 15/1/12.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "SecondViewController.h"
#import "GradientView.h"

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet GradientView *gradientView;


@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
        
}
- (IBAction)progress:(id)sender {
    UISlider *slider =sender;
    [self.gradientView setProgress:slider.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
