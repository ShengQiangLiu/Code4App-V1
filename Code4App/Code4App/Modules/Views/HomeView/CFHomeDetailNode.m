//
//  CFHomeDetailNode.m
//  Code4App
//
//  Created by admin on 15/11/23.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFHomeDetailNode.h"
#import "TextStyles.h"
#import "CodeDetailModel.h"

@interface CFHomeDetailNode () <ASTextNodeDelegate>
{
    CodeDetailModel *_model;
    
    ASTextNode *_introduceNode;
    ASTextNode *_environmentNode;
    ASNetworkImageNode *_photoNode;
    ASTextNode *_usageNode;
    
}
@property (nonatomic, strong) YYAnimatedImageView *webImageView;
@end

@implementation CFHomeDetailNode


- (YYAnimatedImageView *)webImageView
{
    if (!_webImageView) {
        _webImageView = [YYAnimatedImageView new];
    }
    return  _webImageView;
}

- (instancetype)initWithDetailMode:(CodeDetailModel *)model
{
    if (self = [super init]) {
        _model = model;
        
        _introduceNode = [[ASTextNode alloc] init];
        _introduceNode.attributedString = [[NSAttributedString alloc] initWithString:_model.codeintro attributes:[TextStyles titleStyle]];
        [self addSubnode:_introduceNode];
        
        _environmentNode = [[ASTextNode alloc] init];
        _environmentNode.attributedString = [[NSAttributedString alloc] initWithString:_model.codeenv attributes:[TextStyles titleStyle]];
        [self addSubnode:_environmentNode];
        
        _photoNode = [[ASNetworkImageNode alloc] init];
        _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _photoNode.preferredFrameSize = CGSizeMake(153.0, 286.0);
        _photoNode.cornerRadius = 4.0;
        _photoNode.URL = [NSURL URLWithString:_model.codephoto];
        _photoNode.imageModificationBlock = ^UIImage *(UIImage *image)
        {
            UIImage *modifiedImage;
            CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
            
            UIGraphicsBeginImageContextWithOptions(image.size, false, [[UIScreen mainScreen] scale]);
            
            [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:8.0] addClip];
            [image drawInRect:rect];
            modifiedImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            return modifiedImage;
        };
        [self addSubnode:_photoNode];
        
        
        _usageNode = [[ASTextNode alloc] init];
        NSString *kLinkAttributeName = @"TextLinkAttributeName";
        if(![_model.codeusage isEqualToString:@""]) {
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_model.codeusage attributes:[TextStyles postStyle]];
            NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
            [urlDetector enumerateMatchesInString:attrString.string options:kNilOptions range:NSMakeRange(0, attrString.string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                
                if (result.resultType == NSTextCheckingTypeLink) {
                    
                    NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:[TextStyles postLinkStyle]];
                    linkAttributes[kLinkAttributeName] = [NSURL URLWithString:result.URL.absoluteString];
                    
                    [attrString addAttributes:linkAttributes range:result.range];
                }
                
            }];
            
            // configure node to support tappable links
            _usageNode.delegate = self;
            _usageNode.userInteractionEnabled = NO;
            _usageNode.linkAttributeNames = @[ kLinkAttributeName ];
            _usageNode.attributedString = attrString;
        }
        [self addSubnode:_usageNode];
        
    }
    return self;
}

- (void)didLoad
{
    self.layer.as_allowsHighlightDrawing = YES;
    [super didLoad];
}


- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize
{
    ASStackLayoutSpec *indroduceStack;
    indroduceStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:5.0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[_introduceNode, _environmentNode, _photoNode, _usageNode]];
    indroduceStack.alignSelf = ASStackLayoutAlignSelfStretch;
    

    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 10, 10, 10) child:indroduceStack];
        
}

- (void)layout
{
    [super layout];
    _photoNode.frame = CGRectMake(10, 10, 300.0, 286.0);
}

@end
