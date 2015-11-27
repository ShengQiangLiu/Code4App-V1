//
//  HtmlHandler.h
//  Code4App
//
//  Created by admin on 15/11/17.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlHandler : NSObject

- (NSArray *)codeListWithHtml:(NSData *)html;
- (NSDictionary *)codeDetailWithHtml:(NSData *)html;
@end
