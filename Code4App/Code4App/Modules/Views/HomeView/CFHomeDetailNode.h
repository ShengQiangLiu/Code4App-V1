//
//  CFHomeDetailNode.h
//  Code4App
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "CodeDetailModel.h"

@interface CFHomeDetailNode : ASCellNode
- (instancetype)initWithDetailMode:(CodeDetailModel *)model;
@end
