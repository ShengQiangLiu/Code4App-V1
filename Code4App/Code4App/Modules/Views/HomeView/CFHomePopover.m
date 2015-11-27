//
//  CFHomePopover.m
//  Code4App
//
//  Created by admin on 15/11/20.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFHomePopover.h"
#import <DXPopover/DXPopover.h>

CGFloat const PopoverWidth = 220.0;
CGFloat const PopoverCellHight = 40.0;

//static CGFloat randomFloatBetweenLowAndHigh(CGFloat low, CGFloat high)
//{
//    CGFloat diff = high - low;
//    return (((CGFloat)rand() / RAND_MAX) * diff) + low;
//}


@interface CFHomePopover () <UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _popoverWidth;
    CGSize _popoverArrowSize;
    CGFloat _popoverCornerRadius;
    CGFloat _animationIn;
    CGFloat _animationOut;
    BOOL _animationSpring;
    
}
@property (nonatomic, strong) DXPopover *popover;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *configs;

@end

@implementation CFHomePopover

- (instancetype)initWithConfigs:(NSArray *)configs {
    if (self = [super init]) {
        self.configs = configs;
        CGFloat PopoverHight = self.configs.count * PopoverCellHight;
        if (self.configs.count * PopoverCellHight > kViewHeight)
        {
            PopoverHight = kViewHeight - 113;
        }
        
        self.frame = CGRectMake(0, 0, PopoverWidth, PopoverHight);
        self.tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:self.tableView];
        self.popover = [DXPopover new];
    }
    return self;
}

- (void)showPopoverAtStartView:(UIView *)view
{
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(view.frame), CGRectGetMaxY(view.frame) + 18);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionDown
              withContentView:self.tableView
                       inView:kWindow];
    
    __weak typeof(self) weakSelf = self;
    self.popover.didDismissHandler = ^{
        [weakSelf bounceTargetView:view];
    };

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.configs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.configs[indexPath.row];
    
    return cell;
}

//static int i = 0;
//static int j = 1;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(popover:didSelectRowAtIndex:)]) {
        [self.delegate popover:self didSelectRowAtIndex:indexPath.row];
    }
    
//    if (indexPath.row == 0)
//    {
//        int c = i % 3;
//        if (c == 0)
//        {
//            _popoverWidth = 160.0;
//        }
//        else if (c == 1)
//        {
//            _popoverWidth = 250.0;
//        }
//        else if (c == 2)
//        {
//            _popoverWidth = 300.0;
//        }
//        i++;
//    }
//    else if (indexPath.row == 1)
//    {
//        CGSize arrowSize = self.popover.arrowSize;
//        arrowSize.width += randomFloatBetweenLowAndHigh(3.0, 5.0);
//        arrowSize.height += randomFloatBetweenLowAndHigh(3.0, 5.0);
//        self.popover.arrowSize = arrowSize;
//    }
//    else if (indexPath.row == 2)
//    {
//        self.popover.cornerRadius += randomFloatBetweenLowAndHigh(0.0, 1.0);
//    }
//    else if (indexPath.row == 3)
//    {
//        self.popover.animationIn = randomFloatBetweenLowAndHigh(0.4, 2.0);
//    }
//    else if (indexPath.row == 4)
//    {
//        self.popover.animationOut = randomFloatBetweenLowAndHigh(0.4, 2.0);
//    }
//    else if (indexPath.row == 5)
//    {
//        self.popover.animationSpring = !self.popover.animationSpring;
//    } else if (indexPath.row == 6)
//    {
//        self.popover.maskType = j % 2;
//        j++;
//    }
    [self.popover dismiss];
}

- (void)updateTableViewFrame
{
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = _popoverWidth;
    self.tableView.frame = tableViewFrame;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = [UIColor whiteColor];
}

- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}


@end
