//
//  CFHomePopover.h
//  Code4App
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CFHomePopover;

@protocol CFHomePopoverDelegate <NSObject>
@optional
- (void)popover:(CFHomePopover *)popover didSelectRowAtIndex:(NSInteger)index;
@end

@interface CFHomePopover : UIView

- (instancetype)initWithConfigs:(NSArray *)configs;

- (void)showPopoverAtStartView:(UIView *)view;
@property (nonatomic, weak) id<CFHomePopoverDelegate>delegate;
@end
