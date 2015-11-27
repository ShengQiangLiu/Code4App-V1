//
//  CFHomeCellNode.h
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class CodeListModel;
@class CFHomeCellNode;

@protocol CFHomeCellNodeDelegate <NSObject>
@optional
- (void)node:(CFHomeCellNode *)node didLinkUrl:(NSURL *)url;
- (void)node:(CFHomeCellNode *)node didPhoto:(ASNetworkImageNode *)imageNode atIndex:(NSInteger)index;
@end



@interface CFHomeCellNode : ASCellNode

- (instancetype)initWithListMode:(CodeListModel *)model;
@property (nonatomic, weak) id<CFHomeCellNodeDelegate> delegate;

@end
