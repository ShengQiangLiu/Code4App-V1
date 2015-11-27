//
//  NSString+Filter.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "NSString+Filter.h"

@implementation NSString (Filter)
+ (NSString *)filterString:(NSString *)string {
    if (!string) {
        return @"";
    }
    NSString *temp = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@" " withString:@""];
    return temp;
}
@end
