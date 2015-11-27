//
//  TextStyles
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextStyles : NSObject

+ (NSDictionary *)titleStyle;
+ (NSDictionary *)usernameStyle;
+ (NSDictionary *)timeStyle;
+ (NSDictionary *)postStyle;
+ (NSDictionary *)postLinkStyle;
+ (NSDictionary *)cellControlStyle;
+ (NSDictionary *)cellControlColoredStyle;

+ (NSDictionary *)tabBarTitleSelectedStyle;
+ (NSDictionary *)tabBarTitleUnselectedStyle;

@end
