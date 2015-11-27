//
//  CFAppDataManager.h
//  Code4App
//
//  Created by admin on 15/11/21.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CodeDetailModel;

typedef void (^Result)(id);

@interface CFAppDataManager : NSObject
+ (instancetype)sharedInstance;

// 首页数据
@property (nonatomic, strong) NSArray *codeList;
// 分类列表数据
- (void)categoryListModeWithType:(NSString *)type result:(Result)result;
// 刷新数据
- (void)refreshCategoryList:(NSInteger)index result:(Result)result;
// 详情页
- (void)codeDetailModelWithUrl:(NSString *)url result:(Result)result;
@end
