//
//  CFAppAPIManager.m
//  Code4App
//
//  Created by admin on 15/11/21.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFAppAPIManager.h"
#import "CodeListModel.h"
#import "HtmlHandler.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://www.baidu.com";
static NSString * const HOST = @"http://code4app.com/category";

@implementation CFAppAPIManager
+ (instancetype)sharedInstance {
    static CFAppAPIManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[CFAppAPIManager alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
    });
    return _instance;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url])
    {
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        self.requestSerializer.timeoutInterval = 30.0;
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}


- (void)getCodeListSuccess:(Success)success failure:(Error)failure
{
    [self GET:HOST parameters:nil success:success failure:failure];
}

- (void)getCategoryCodeListWithCategoryType:(NSString *)type index:(NSInteger)index success:(Success)success failure:(Error)failure
{
    NSString *path = nil;
    if (type)
    {
        path = [NSString stringWithFormat:@"%@/%@/%ld", HOST, type, index];
    }
    else
    {   //没有分类类型的时候类型为0
        path = [NSString stringWithFormat:@"%@/%d/%ld", HOST, 0, index];
    }
    [self GET:path parameters:nil success:success failure:failure];
}


- (void)getCodeDetailWithUrl:(NSString *)url success:(Success)success failure:(Error)failure
{
    // url 中带有中文
    NSString *path = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self GET:path parameters:nil success:success failure:failure];
}

@end
