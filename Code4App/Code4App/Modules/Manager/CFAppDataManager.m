//
//  CFAppDataManager.m
//  Code4App
//
//  Created by admin on 15/11/21.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFAppDataManager.h"
#import "CFAppAPIManager.h"
#import "HtmlHandler.h"
#import "CodeListModel.h"
#import "CodeDetailModel.h"

@interface CFAppDataManager ()
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSString *currentType;

@end

@implementation CFAppDataManager
+ (instancetype)sharedInstance
{
    static CFAppDataManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CFAppDataManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _tempArray = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)codeList
{
    if (!_codeList)
    {
        [[CFAppAPIManager sharedInstance] getCodeListSuccess:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSArray *parserArray =  [[[HtmlHandler alloc] init] codeListWithHtml:responseObject];
            NSMutableArray *modelArray = [NSMutableArray array];
            for (NSDictionary *dict in parserArray)
            {
                [modelArray addObject:[CodeListModel modelWithDictionary:dict]];
            }
            self.codeList = modelArray;
            // 保存一份首页数据到temp中
            [self.tempArray addObjectsFromArray:self.codeList];
        }
        failure:^(NSURLSessionDataTask *task, NSError *error)
        {
            NSLog(@"%@",error.description);
        }];
    }
    return _codeList;
}



- (void)categoryListModeWithType:(NSString *)type result:(Result)result
{
    // 当前类型和传入进来的类型不一致，tempArray清空
    if (![self.currentType isEqualToString:type]) {
        [self.tempArray removeAllObjects];
    }
    self.currentType = type;
    
    @weakify(self);
    [[CFAppAPIManager sharedInstance] getCategoryCodeListWithCategoryType:self.currentType index:0 success:^(NSURLSessionDataTask *task, id responseObject)
    {
        @strongify(self);
        NSArray *parserArray =  [[[HtmlHandler alloc] init] codeListWithHtml:responseObject];
        NSMutableArray *modelArray = [NSMutableArray array];
        for (NSDictionary *dict in parserArray)
        {
            [modelArray addObject:[CodeListModel modelWithDictionary:dict]];
        }
        [self.tempArray addObjectsFromArray:modelArray];
        result(self.tempArray);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        NSLog(@"%@",error.description);
    }];
}

- (void)refreshCategoryList:(NSInteger)index result:(Result)result
{
    @weakify(self);
    [[CFAppAPIManager sharedInstance] getCategoryCodeListWithCategoryType:self.currentType index:index success:^(NSURLSessionDataTask *task, id responseObject)
     {
         @strongify(self);
         NSArray *parserArray =  [[[HtmlHandler alloc] init] codeListWithHtml:responseObject];
         NSMutableArray *modelArray = [NSMutableArray array];
         for (NSDictionary *dict in parserArray)
         {
             [modelArray addObject:[CodeListModel modelWithDictionary:dict]];
         }
         [self.tempArray addObjectsFromArray:modelArray];
         result(self.tempArray );
     }
     failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error.description);
     }];
}

- (void)codeDetailModelWithUrl:(NSString *)url result:(Result)result
{
    [[CFAppAPIManager sharedInstance] getCodeDetailWithUrl:url success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSDictionary *parserDict =  [[[HtmlHandler alloc] init] codeDetailWithHtml:responseObject];
        CodeDetailModel *model = [CodeDetailModel modelWithDictionary:parserDict];
        result(model);
    }
    failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        
    }];
}


@end
