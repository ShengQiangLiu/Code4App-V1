//
//  Macro.h
//  WaO
//
//  Created by admin on 15/9/20.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#ifndef Macro_h
#define Macro_h
// 颜色
#define RGB(r, g, b)                        [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c)                         [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

/*
 宽高适配
 */
#define kWidth ([[UIScreen mainScreen] bounds].size.width/320)
#define kHeight ([[UIScreen mainScreen] bounds].size.height/568)

/*
 屏幕宽高，以及屏幕中心位置
 */
#define kViewWidth [[[UIApplication sharedApplication] delegate] window].frame.size.width
#define kViewHeight [[[UIApplication sharedApplication] delegate] window].frame.size.height
#define kViewCenter [[[UIApplication sharedApplication] delegate] window].center

#define kWindow [[UIApplication sharedApplication].delegate window]
#endif /* Macro_h */
