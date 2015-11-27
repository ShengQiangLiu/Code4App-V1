//
//  CFHomeCellNode.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFHomeCellNode.h"
#import "CodeListModel.h"
#import "TextStyles.h"

@interface CFHomeCellNode () <ASTextNodeDelegate>
{
    CodeListModel *_model;
    ASDisplayNode *_dividerNode;
    ASNetworkImageNode *_photoNode;
    ASTextNode *_titleNode;
    ASTextNode *_linkNode;
    ASTextNode *_authorNode;
    ASTextNode *_descNode;
    ASTextNode *_categoryNode;
    ASTextNode *_lookNumberNode;
    ASTextNode *_downloadNumberNode;
    ASTextNode *_timeNode;
    
}
@end

@implementation CFHomeCellNode

- (instancetype)initWithListMode:(CodeListModel *)model
{
    if (self = [super init])
    {
        _model = model;

        _titleNode  = [[ASTextNode alloc] init];
        _titleNode.attributedString = [[NSAttributedString alloc] initWithString:_model.title attributes:[TextStyles titleStyle]];
        _titleNode.maximumLineCount = 1;
        [self addSubnode:_titleNode];
        
        _categoryNode = [[ASTextNode alloc] init];
        _categoryNode.attributedString = [[NSAttributedString alloc] initWithString:_model.category attributes:[TextStyles titleStyle]];
        _categoryNode.maximumLineCount = 1;
        [self addSubnode:_categoryNode];
        
        NSString *authorString = [NSString stringWithFormat:@"%@ 发布在github", _model.author];
        _authorNode = [[ASTextNode alloc] init];
        _authorNode.attributedString = [[NSAttributedString alloc] initWithString:authorString attributes:[TextStyles usernameStyle]];
        _authorNode.maximumLineCount = 1;
        _authorNode.flexShrink = YES;
        _authorNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_authorNode];
        
        _descNode = [[ASTextNode alloc] init];
        NSString *kLinkAttributeName = @"TextLinkAttributeName";
        if(![_model.desc isEqualToString:@""]) {
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:_model.desc attributes:[TextStyles postStyle]];
            NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
            [urlDetector enumerateMatchesInString:attrString.string options:kNilOptions range:NSMakeRange(0, attrString.string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop){
                
                if (result.resultType == NSTextCheckingTypeLink) {
                    
                    NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:[TextStyles postLinkStyle]];
                    linkAttributes[kLinkAttributeName] = [NSURL URLWithString:result.URL.absoluteString];
                    
                    [attrString addAttributes:linkAttributes range:result.range];
                }
                
            }];
            
            // configure node to support tappable links
            _descNode.delegate = self;
            _descNode.userInteractionEnabled = NO;
            _descNode.linkAttributeNames = @[ kLinkAttributeName ];
            _descNode.attributedString = attrString;
        }
        [self addSubnode:_descNode];
        
        _linkNode = [[ASTextNode alloc] init];
//        NSString *kLinkAttributeName = @"TextLinkAttributeName";
        if(![_model.link isEqualToString:@""]) {
            NSString *linkString = [NSString stringWithFormat:@"下载地址：%@", _model.link];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:linkString attributes:[TextStyles postStyle]];
            
            NSDataDetector *urlDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
            
            [urlDetector enumerateMatchesInString:attrString.string options:kNilOptions range:NSMakeRange(0, attrString.string.length) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
            {
                
                if (result.resultType == NSTextCheckingTypeLink)
                {
                    
                    NSMutableDictionary *linkAttributes = [[NSMutableDictionary alloc] initWithDictionary:[TextStyles postLinkStyle]];
                    linkAttributes[kLinkAttributeName] = [NSURL URLWithString:result.URL.absoluteString];
                    
                    [attrString addAttributes:linkAttributes range:result.range];
                }
                
            }];
            
            // configure node to support tappable links
            _linkNode.delegate = self;
            _linkNode.userInteractionEnabled = YES;
            _linkNode.linkAttributeNames = @[ kLinkAttributeName ];
            _linkNode.attributedString = attrString;
            
        }
        [self addSubnode:_linkNode];
        
        
        _lookNumberNode = [[ASTextNode alloc] init];
        _lookNumberNode.attributedString = [[NSAttributedString alloc] initWithString:_model.lookNumber attributes:[TextStyles usernameStyle]];
        _lookNumberNode.maximumLineCount = 1;
        _lookNumberNode.flexShrink = YES;
        _lookNumberNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_lookNumberNode];
        
        _downloadNumberNode = [[ASTextNode alloc] init];
        _downloadNumberNode.attributedString = [[NSAttributedString alloc] initWithString:_model.downloadNumber attributes:[TextStyles usernameStyle]];
        _downloadNumberNode.maximumLineCount = 1;
        _downloadNumberNode.flexShrink = YES;
        _downloadNumberNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_downloadNumberNode];
        
        
        _timeNode = [[ASTextNode alloc] init];
        _timeNode.attributedString = [[NSAttributedString alloc] initWithString:_model.time attributes:[TextStyles usernameStyle]];
        _timeNode.maximumLineCount = 1;
        _timeNode.flexShrink = YES;
        _timeNode.truncationMode = NSLineBreakByTruncatingTail;
        [self addSubnode:_timeNode];
        
        
        
        _photoNode = [[ASNetworkImageNode alloc] init];
        _photoNode.backgroundColor = ASDisplayNodeDefaultPlaceholderColor();
        _photoNode.preferredFrameSize = CGSizeMake(65.0, 120.0);
        _photoNode.cornerRadius = 4.0;
        _photoNode.URL = [NSURL URLWithString:_model.photo];
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
        [_photoNode addTarget:self action:@selector(photoNodeClick:) forControlEvents:ASControlNodeEventTouchUpInside];
        [self addSubnode:_photoNode];
        
    
        
        
        _dividerNode = [[ASDisplayNode alloc] init];
        _dividerNode.backgroundColor = [UIColor lightGrayColor];
        [self addSubnode:_dividerNode];
        
        
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
    //Flexible spacer between title and time
    ASLayoutSpec *spacer = [[ASLayoutSpec alloc] init];
    spacer.flexGrow = YES;
    
    ASStackLayoutSpec *titleStack;
    titleStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_titleNode, spacer, _categoryNode]];
    titleStack.alignSelf = ASStackLayoutAlignSelfStretch;
    
    ASStackLayoutSpec *authorStack;
    authorStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_authorNode]];
    authorStack.alignSelf = ASStackLayoutAlignSelfStretch;
    
    ASStackLayoutSpec *otherInfoStack;
    otherInfoStack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:5.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsCenter children:@[_lookNumberNode, spacer, _downloadNumberNode, spacer,  _timeNode]];
    otherInfoStack.alignSelf = ASStackLayoutAlignSelfStretch;
    
    NSMutableArray *mainStackContent = [[NSMutableArray alloc] init];
    [mainStackContent addObject:titleStack];
    [mainStackContent addObject:authorStack];
    [mainStackContent addObject:_descNode];
    [mainStackContent addObject:_linkNode];
    [mainStackContent addObject:otherInfoStack];

    
    ASStackLayoutSpec *contentSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:8.0 justifyContent:ASStackLayoutJustifyContentStart alignItems:ASStackLayoutAlignItemsStart children:mainStackContent];
    
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(10, 85, 10, 10) child:contentSpec];
    
}

- (void)layout
{
    [super layout];
    
    // Manually layout the divider.
    CGFloat pixelHeight = 1.0f / [[UIScreen mainScreen] scale];
    _dividerNode.frame = CGRectMake(0.0f, 0.0f, self.calculatedSize.width, pixelHeight);
    _photoNode.frame = CGRectMake(10, 10, 65.0, 120.0);
    
}

#pragma mark -
#pragma mark ASTextNodeDelegate methods.

- (BOOL)textNode:(ASTextNode *)richTextNode shouldHighlightLinkAttribute:(NSString *)attribute value:(id)value atPoint:(CGPoint)point
{
    // opt into link highlighting -- tap and hold the link to try it!  must enable highlighting on a layer, see -didLoad
    return YES;
}

- (void)textNode:(ASTextNode *)richTextNode tappedLinkAttribute:(NSString *)attribute value:(NSURL *)URL atPoint:(CGPoint)point textRange:(NSRange)textRange
{
    // the node tapped a link, open it
//    [[UIApplication sharedApplication] openURL:URL];
    if ([self.delegate respondsToSelector:@selector(node:didLinkUrl:)]) {
        [self.delegate node:self didLinkUrl:URL];
    }
}

#pragma mark - ASNetworkImageNode
- (void)photoNodeClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(node:didPhoto:atIndex:)]) {
        [self.delegate node:self didPhoto:sender atIndex:self.view.tag];
    }
}

@end
