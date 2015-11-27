//
//  CFBaseViewController.m
//  Code4App
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFBaseViewController.h"
#import "CFTabBarController.h"

@interface CFBaseViewController ()

@end

@implementation CFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:NO animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:YES animated:YES];
}

//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:YES animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
