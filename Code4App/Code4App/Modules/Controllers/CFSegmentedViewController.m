//
//  CFSegmentedViewController.m
//  Code4App
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFSegmentedViewController.h"
#import <PPiFlatSegmentedControl/PPiFlatSegmentedControl.h>
#import <FontAwesome+iOS/NSString+FontAwesome.h>

@interface CFSegmentedViewController ()
{
    CGRect containerFrame;
    PPiFlatSegmentedControl *_segmentedControl;
}
@property(nonatomic, strong) UIViewController *selectedViewController;
@property(nonatomic, strong) UIView *viewContainer;

@end

@implementation CFSegmentedViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    containerFrame = _viewContainer.frame;
    for (UIViewController *childViewController in self.childViewControllers) {
        childViewController.view.frame = (CGRect){0,0,containerFrame.size};
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (!_segmentedControl) {
        NSArray *items = @[[[PPiFlatSegmentItem alloc] initWithTitle:@"Segmented1" andIcon:nil],
                           [[PPiFlatSegmentItem alloc] initWithTitle:@"Segmented2" andIcon:nil]
                           ];
        _segmentedControl = [[PPiFlatSegmentedControl alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 40) items:items iconPosition:IconPositionRight andSelectionBlock:^(NSUInteger segmentIndex) {
            [self segmentedControlSelected:segmentIndex];
        } iconSeparation:5];
        _segmentedControl.color=[UIColor colorWithRed:200.0f/255.0 green:200.0f/255.0 blue:200.0f/255.0 alpha:1];
        _segmentedControl.borderWidth=0.5;
        _segmentedControl.borderColor= [UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
        _segmentedControl.selectedColor=[UIColor colorWithRed:88.0f/255.0 green:88.0f/255.0 blue:88.0f/255.0 alpha:1];
        _segmentedControl.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName:[UIColor whiteColor]};
        _segmentedControl.selectedTextAttributes=@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],
                                                   NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.navigationItem.titleView = _segmentedControl;
    } else {
        [_segmentedControl removeAllSubviews];
    }
    
    
    
    if (!_viewContainer) {
        [self setViewContainer:self.view];
    }
    
}

- (void)setViewContainer:(UIView *)viewContainer
{
    _viewContainer = viewContainer;
    containerFrame = _viewContainer.frame;
}


- (void)segmentedControlSelected:(NSInteger )segmentIndex
{
    self.selectedViewControllerIndex = segmentIndex;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    
    for (NSInteger i = 0; i < viewControllers.count; i++) {
        [self pushViewController:viewControllers[i] title:[viewControllers[i] title]];
    }
    [_segmentedControl setSelected:YES segmentAtIndex:0];
    self.selectedViewControllerIndex = 0;
}

- (void)pushViewController:(UIViewController *)viewController title:(NSString *)title
{
    [_segmentedControl setTitle:title forSegmentAtIndex:_segmentedControl.numberOfSegments];
    [self addChildViewController:viewController];
}




- (void)setSelectedViewControllerIndex:(NSInteger)index
{
    if (!_selectedViewController) {
        [self selectViewController:index];
        [_viewContainer addSubview:[_selectedViewController view]];
    } else if (index != _selectedViewControllerIndex){
        [self transitionFromViewController:_selectedViewController toViewController:self.childViewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            [self selectViewController:index];
        }];
    }
}

- (void)selectViewController:(NSInteger)index
{
    _selectedViewController = self.childViewControllers[index];
    [_selectedViewController didMoveToParentViewController:self];
    if (_selectedViewController.navigationItem.rightBarButtonItem) {
        self.navigationItem.rightBarButtonItem = _selectedViewController.navigationItem.rightBarButtonItem;
    }
    if (_selectedViewController.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = _selectedViewController.navigationItem.leftBarButtonItem;
    }
    _selectedViewControllerIndex = index;
}

@end
