//
//  YDPromptViewController.m
//  Demo
//
//  Created by r_zhou on 15/7/15.
//  Copyright (c) 2015年 r_zhou. All rights reserved.
//

#import "GSPromptViewController.h"

@interface GSPromptViewController ()

@end

@implementation GSPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self.wholeView layer]setCornerRadius:7];//圆角
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)label:(NSString *)labelText
{
    self.label.text = labelText;
}

- (IBAction)testAction:(id)sender {
    self.view.hidden = YES;
}
@end
