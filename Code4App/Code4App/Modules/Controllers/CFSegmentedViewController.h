//
//  CFSegmentedViewController.h
//  Code4App
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CFSegmentedViewController : UIViewController
@property(nonatomic, assign) NSInteger selectedViewControllerIndex;

- (void)setViewControllers:(NSArray *)viewControllers;
@end
