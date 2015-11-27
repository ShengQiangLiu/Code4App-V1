//
//  CFAppAPIManager.h
//  Code4App
//
//  Created by admin on 15/11/21.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void (^Success)(NSURLSessionDataTask *task, id responseObject);
typedef void (^Error)(NSURLSessionDataTask *task, NSError *error);

@interface CFAppAPIManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

- (void)getCodeListSuccess:(Success)success failure:(Error)failure;

- (void)getCategoryCodeListWithCategoryType:(NSString *)type index:(NSInteger)index success:(Success)success failure:(Error)failure;

- (void)getCodeDetailWithUrl:(NSString *)url success:(Success)success failure:(Error)failure;

@end
