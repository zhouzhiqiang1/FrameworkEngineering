//
//  YDSSViewController.m
//  ViewController
//
//  Created by r_zhou on 15/8/26.
//  Copyright (c) 2015年 r_zhou. All rights reserved.
//

#import "YDSSViewController.h"
#import "YDSViewController.h"

@interface YDSSViewController ()

@end

@implementation YDSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)btnClick:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    YDSViewController *sView = [storyboard instantiateViewControllerWithIdentifier:@"YDSViewController"];
    sView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sView animated:YES];
}

@end
