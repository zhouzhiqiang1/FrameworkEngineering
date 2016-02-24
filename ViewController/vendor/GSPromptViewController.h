//
//  YDPromptViewController.h
//  Demo
//
//  Created by r_zhou on 15/7/15.
//  Copyright (c) 2015年 r_zhou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSPromptViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *wholeView;
@property (strong, nonatomic) IBOutlet UILabel *label;

-(void)label:(NSString *)labelText;

@end
