//
//  YDRootBarViewController.m
//  ViewController
//
//  Created by r_zhou on 15/7/6.
//  Copyright (c) 2015年 r_zhou. All rights reserved.
//

#import "YDRootBarViewController.h"

@interface YDRootBarViewController ()

@end

@implementation YDRootBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    

    /**
     试图控制器中添加  storyboard 视图
     */
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, 0.5f)];
    [self.tabBar addSubview:lineView];
    
    NSMutableArray *viewControlles = [NSMutableArray arrayWithArray:self.viewControllers];
    
    UIStoryboard *homeStoryboard = [UIStoryboard storyboardWithName:@"Home" bundle:nil];
    UINavigationController *homeNavController = [homeStoryboard instantiateInitialViewController];
    [viewControlles replaceObjectAtIndex:2 withObject:homeNavController];
    
    
    UIStoryboard *messageStoryboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    UINavigationController *messageNavControler = [messageStoryboard instantiateInitialViewController];
    [viewControlles replaceObjectAtIndex:1 withObject:messageNavControler];
    
    [self setViewControllers:viewControlles];
    

}
@end
