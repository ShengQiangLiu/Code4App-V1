//
//  ShareManager.h
//  Code4App
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareManager : NSObject
+ (instancetype)sharedInstance;
- (void)initlizeShareSDKAppKey;
- (void)showMenu;

@end
