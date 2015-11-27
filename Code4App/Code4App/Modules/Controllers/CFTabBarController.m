//
//  CFTabBarController.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFTabBarController.h"
#import <RDVTabBarController/RDVTabBarItem.h>
#import "CFHomeViewController.h"
#import "CFNewCodeViewController.h"
#import "CFForumViewController.h"
#import "CFProfileViewController.h"
#import "TextStyles.h"

@interface CFTabBarController ()

@end

@implementation CFTabBarController

#pragma mark - View lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupViewControllers];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupViewControllers {
    UIViewController *firstViewController = [[CFHomeViewController alloc] init];
    UIViewController *firstNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:firstViewController];
    
//    UIViewController *secondViewController = [[CFNewCodeViewController alloc] init];
//    UIViewController *secondNavigationController = [[UINavigationController alloc]
//                                                    initWithRootViewController:secondViewController];
    
    CFForumViewController *thirdViewController = [[CFForumViewController alloc] init];
    UIViewController *thirdNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:thirdViewController];
    
    UIViewController *profileViewController = [[CFProfileViewController alloc] init];
    UIViewController *profileNavigationController = [[UINavigationController alloc]
                                                   initWithRootViewController:profileViewController];
    
    [self setViewControllers:@[firstNavigationController, thirdNavigationController,
                                           profileNavigationController]];
    
    [self customizeTabBar];
}

- (void)customizeTabBar {
//    UIImage *finishedImage = [UIImage imageNamed:@"tabbar_selected_background"];
//    UIImage *unfinishedImage = [UIImage imageNamed:@"tabbar_normal_background"];
//    NSArray *tabBarItemImages = @[@"first", @"second", @"third"];
    
    
    UIImage *finishedImage = [UIImage imageWithColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5]];
    UIImage *unfinishedImage = [UIImage imageWithColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:0.5]];
    NSArray *tabBarItemTitles = @[@"Home", @"Forum", @"Profile"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        [item setBackgroundSelectedImage:finishedImage withUnselectedImage:unfinishedImage];
//        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",
//                                                      [tabBarItemImages objectAtIndex:index]]];
//        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@_normal",
//                                                        [tabBarItemImages objectAtIndex:index]]];
//        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        item.title = tabBarItemTitles[index];
        item.selectedTitleAttributes = [TextStyles tabBarTitleSelectedStyle];
        item.unselectedTitleAttributes = [TextStyles tabBarTitleUnselectedStyle];
        index++;
    }
}

- (void)tabBarController:(RDVTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"aaa");
}



@end
