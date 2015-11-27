//
//  TextStyles
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//


#import "TextStyles.h"

@implementation TextStyles

+ (NSDictionary *)titleStyle
{
    return @{
             NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0],
             NSForegroundColorAttributeName: [UIColor blackColor]
    };
}

+ (NSDictionary *)usernameStyle
{
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: [UIColor lightGrayColor]
             };
}

+ (NSDictionary *)timeStyle
{
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: [UIColor grayColor]
             };
}

+ (NSDictionary *)postStyle
{
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:15.0],
             NSForegroundColorAttributeName: [UIColor blackColor]
             };
}

+ (NSDictionary *)postLinkStyle
{
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:15.0],
             NSForegroundColorAttributeName: [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0],
             NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)
             };
}

+ (NSDictionary *)cellControlStyle {
    
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: [UIColor lightGrayColor]
             };
}

+ (NSDictionary *)cellControlColoredStyle {
    
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:13.0],
             NSForegroundColorAttributeName: [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0]
             };
}

+ (NSDictionary *)tabBarTitleSelectedStyle {
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:18.0],
             NSForegroundColorAttributeName: [UIColor colorWithRed:59.0/255.0 green:89.0/255.0 blue:152.0/255.0 alpha:1.0]
             };
}

+ (NSDictionary *)tabBarTitleUnselectedStyle {
    return @{
             NSFontAttributeName : [UIFont systemFontOfSize:14.0],
             NSForegroundColorAttributeName: [UIColor blackColor]
             };
}

@end
