//
//  HtmlHandler.m
//  Code4App
//
//  Created by admin on 15/11/17.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "HtmlHandler.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "NSString+Filter.h"

@implementation HtmlHandler

- (NSArray *)codeListWithHtml:(NSData *)html {
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithData:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *liTags = [bodyNode findChildrenOfClass:@"codeli"];
    
    NSMutableArray *parserArray = [NSMutableArray array];
    
    for (HTMLNode *liTag in liTags) {

        NSMutableDictionary *tempDict = [NSMutableDictionary dictionary];
        
        NSArray *codeLiPhoto = [liTag findChildrenOfClass:@"codeli-photo"];
        NSArray *codeLiInfo = [liTag findChildrenOfClass:@"codeli-info"];
        
        for (HTMLNode *photoClass in codeLiPhoto) {
            // 框架 gif 图片
//            NSLog(@"%@", [[photoClass findChildTag:@"img"] getAttributeNamed:@"src"]);
            [tempDict setObject:[[photoClass findChildTag:@"img"] getAttributeNamed:@"src"] forKey:@"photo"];
            // 跳转到下一个页面的链接
            [tempDict setObject:[[photoClass findChildTag:@"a"] getAttributeNamed:@"href"] forKey:@"href"];
        }
        
        for (HTMLNode *nameClass in codeLiInfo) {
            // 框架名字
//            NSLog(@"%@", [[[nameClass findChildOfClass:@"codeli-name"] findChildTag:@"a"] contents]);
            [tempDict setObject:[[[nameClass findChildOfClass:@"codeli-name"] findChildTag:@"a"] contents] forKey:@"title"];
            
            for (HTMLNode *aTag in [nameClass findChildrenOfClass:@"codeli-author"]) {
                // 框架作者
//                NSLog(@"%@", [[aTag findChildTags:@"a"][0] getAttributeNamed:@"title"]);
                [tempDict setObject:[[aTag findChildTags:@"a"][0] getAttributeNamed:@"title"] forKey:@"author"];
                
                // 框架 githu 地址
                if ([aTag findChildTags:@"a"].count == 2) { // html 格式太乱才做此保护
                    //                NSLog(@"%@", [[aTag findChildTags:@"a"][1] getAttributeNamed:@"title"]);
                    [tempDict setObject:[[aTag findChildTags:@"a"][1] getAttributeNamed:@"title"] forKey:@"link"];
                } else{
                    [tempDict setObject:@"" forKey:@"link"];
                }
            }
            // 框架描述
//            NSLog(@"%@", [[nameClass findChildOfClass:@"codeli-description"] contents]);
            NSString *filterDesc = [NSString filterString:[[nameClass findChildOfClass:@"codeli-description"] contents]];
            [tempDict setObject:filterDesc forKey:@"desc"];
            
            // Other Info
//            NSLog(@"%@", [[nameClass findChildOfClass:@"otherinfo"]  allContents]);
            NSString *filterInfo = [NSString filterString:[[nameClass findChildOfClass:@"otherinfo"]  allContents]];
            [tempDict setObject:filterInfo forKey:@"otherInfo"];
            NSArray *array = [filterInfo componentsSeparatedByString:@"•"];
            [tempDict setObject:array[0] forKey:@"category"];
            [tempDict setObject:array[1] forKey:@"lookNumber"];
            [tempDict setObject:array[2] forKey:@"downloadNumber"];
            [tempDict setObject:array[3] forKey:@"time"];
            
        }
        [parserArray addObject:tempDict];
    }
    /**
     *  -[__NSArrayM removeObjectAtIndex:]: index 18446744073709551615 beyond bounds for empty array'
     */
    [parserArray removeObjectAtIndex:parserArray.count-1];
    return parserArray;
    
}

- (NSDictionary *)codeDetailWithHtml:(NSData *)html
{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithData:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    NSMutableDictionary *parserDict = [NSMutableDictionary dictionary];
    
    HTMLNode *bodyNode = [parser body];
    NSArray *divs = [bodyNode findChildrenWithAttribute:@"id" matchingName:@"onecode" allowPartial:YES];
    for (HTMLNode *div in divs) {
        // 介绍
        HTMLNode *codeintro = [div findChildWithAttribute:@"id" matchingName:@"codeintro" allowPartial:YES];
        // 测试环境
        HTMLNode *codeenv = [div findChildWithAttribute:@"id" matchingName:@"codeenv" allowPartial:YES];
        // 效果图
        HTMLNode *codephoto = [div findChildWithAttribute:@"id" matchingName:@"codephoto" allowPartial:YES];
        // 使用方法
        HTMLNode *codeusage = [div findChildWithAttribute:@"id" matchingName:@"codeusage" allowPartial:YES];
        // copyright
//        HTMLNode *copyright = [div findChildWithAttribute:@"id" matchingName:@"copyright" allowPartial:YES];

//        NSArray *codeintroArr = [[codeintro allContents] componentsSeparatedByString:@"："];
//        NSString *codeintroStr = [NSString filterString:codeintroArr[1]];
        NSLog(@"%@", [codeintro rawContents] );
    
        [parserDict setObject:[codeintro rawContents] forKey:@"codeintro"];
        
        NSLog(@"%@", [codeenv rawContents]);
//        NSArray *codeenvArr = [[codeenv allContents] componentsSeparatedByString:@"："];
        [parserDict setObject:[codeenv rawContents]  forKey:@"codeenv"];
        
        [parserDict setObject:[[codephoto findChildTag:@"img"] getAttributeNamed:@"src"] forKey:@"codephoto"];
        
        if (codeusage)
        {
//            NSString *str =[NSString filterString:[codeusage rawContents]];
            [parserDict setObject:[NSString filterString:[codeusage rawContents]] forKey:@"codeusage"];
        }
        else
        {
            [parserDict setObject:@"" forKey:@"codeusage"];
        }

        
    }
    return parserDict;
}

/*
 @"•"
 
1.截取字符串

NSString*string =@"sdfsfsfsAdfsdf";
string = [string substringToIndex:7];//截取下标7之前的字符串
NSLog(@"截取的值为：%@",string);
[string substringFromIndex:2];//截取下标2之后的字符串
NSLog(@"截取的值为：%@",string);


2.匹配字符串
NSString*string =@"sdfsfsfsAdfsdf";
NSRangerange = [stringrangeOfString:@"f"];//匹配得到的下标
NSLog(@"rang:%@",NSStringFromRange(range));
string = [string substringWithRange:range];//截取范围类的字符串
NSLog(@"截取的值为：%@",string);


3.分隔字符串
NSString*string =@"sdfsfsfsAdfsdf";

NSArray *array = [string componentsSeparatedByString:@"A"]; //从字符A中分隔成2个元素的数组
NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
*/

@end
