//
//  CFHomeViewController.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFHomeViewController.h"
#import "CFHomeCellNode.h"
#import "CodeListModel.h"
#import "YYPhotoGroupView.h"
#import "YYFPSLabel.h"
#import "CFHomePopover.h"
#import "CFAppDataManager.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CFHomeDetailViewController.h"
#import "CFTabBarController.h"

@interface CFHomeViewController () <ASTableViewDataSource, ASTableViewDelegate, CFHomeCellNodeDelegate, CFHomePopoverDelegate>
{
    CFHomePopover *_popover;

}

@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, strong) ASTableView *tableView;
@property (nonatomic, assign) NSInteger categoryIndex;

@end
@implementation CFHomeViewController


#pragma mark - View lifecycle
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.navigationItem.title = @"Home";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分类" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonClick:)];
        [self initSubviews];
        self.categoryIndex = 0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"%s", __func__);

}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [self fetchHomeDataSource];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:NO animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:YES animated:YES];
//}


#pragma mark - Private method
- (void)rightBarButtonClick:(id)sender
{
    NSArray *configs = @[
                         @"指示器(Activitylndicator)",
                         @"提醒对话框(AlertView)",
                         @"按钮(Button)",
                         @"日历(Calendar)",
                         @"相机(Camera)",
                         @"透明指示器(HUD)",
                         @"图像(Image)",
                         @"键盘(Keyboard)",
                         @"标签(Label)",
                         @"地图(Map)",
                         @"菜单(Menu)",
                         @"导航条(Navigation Bar)",
                         @"选择器(Picker)",
                         @"进度条(Progress)",
                         @"滚动视图(ScrollView)",
                         @"分段选择(Segment)",
                         @"滑杆(Slider)",
                         @"状态栏(Status Bar)",
                         @"开关(Switch)",
                         @"选项卡(Tab Bar)",
                         @"列表(Table)",
                         @"文字输入框(TextField)",
                         @"文字视图(TextView)",
                         @"网页(Webview)"
                         ];
    
    _popover = [[CFHomePopover alloc] initWithConfigs:configs];
    _popover.delegate = self;
    UIBarButtonItem *item = sender;
    UIView *view = [item valueForKey:@"view"];
    [_popover showPopoverAtStartView:view];
    
}




//AutoLayout
-(void)viewWillLayoutSubviews
{
    //更正尺寸
    _tableView.frame = self.view.bounds;
}

- (void)initSubviews
{
    _tableView = [[ASTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain asyncDataFetching:YES];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.asyncDataSource = self;
    _tableView.asyncDelegate = self;
    
}


- (void)fetchHomeDataSource {

    // 观察数据变化
    @weakify(self);
    [self.KVOController observe:[CFAppDataManager sharedInstance] keyPath:@"codeList" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial block:^(id observer, id object, NSDictionary *change)
    {
            if (![change[NSKeyValueChangeNewKey] isKindOfClass:[NSNull class]])
            {
                @strongify(self);
                self.modelArray = change[NSKeyValueChangeNewKey];
                [self.tableView reloadData];
                
            }
    }];
    
    
    // 上拉刷新
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        @strongify(self);
        self.categoryIndex++;
        [[CFAppDataManager sharedInstance] refreshCategoryList:self.categoryIndex result:^(id result)
        {
            if (result) {
                self.modelArray = result;
                
                NSUInteger rowCount = [self.tableView numberOfRowsInSection:0];
                NSMutableArray *indexPaths = [NSMutableArray array];
                for (NSInteger i = 1; i <= self.modelArray.count - rowCount; i++) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i+rowCount-1 inSection:0];
                    [indexPaths addObject:indexPath];
                }
                // 插入新的数组
                [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"没有更多了"];
            }
            // 停止上拉刷新
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }];
    
}

#pragma mark - CFHomePopoverDelegate
- (void)popover:(CFHomePopover *)popover didSelectRowAtIndex:(NSInteger)index
{

    NSArray *type = @[@"activityindicator",@"alertview",@"button",@"calendar",
                      @"camera",@"hud",@"imageview",@"keyboard",@"label",
                      @"mapview",@"menu",@"navigationbar",@"picker",@"progress",
                      @"scrollview",@"segment",@"slider",@"statusbar",@"switch",
                      @"tabbar",@"tableview",@"textfield",@"textview",@"webview"
                      ];
    self.navigationItem.title = type[index];
    // 分类切换，分类索引置为0
    self.categoryIndex = 0;
    // 分类数据
    @weakify(self);
    [[CFAppDataManager sharedInstance] categoryListModeWithType:type[index] result:^(id result)
    {
        @strongify(self);
        self.modelArray = result;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableViewDataSource

- (ASCellNode *)tableView:(ASTableView *)tableView nodeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFHomeCellNode *node = [[CFHomeCellNode alloc] initWithListMode:self.modelArray[indexPath.row]];
    node.delegate = self;
    node.view.tag = indexPath.row;
    return node;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", indexPath.row);
//    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    [tabBarController setTabBarHidden:YES animated:YES];
    
    CFHomeDetailViewController *detailCtrl = [[CFHomeDetailViewController alloc] init];
    CodeListModel *model = self.modelArray[indexPath.row];
    detailCtrl.href = [model.href copy];
    detailCtrl.naviTitle = [model.title copy];
    [self.navigationController pushViewController:detailCtrl animated:YES];
}

#pragma mark - CFHomeCellNodeDelegate
- (void)node:(CFHomeCellNode *)node didPhoto:(ASNetworkImageNode *)imageNode atIndex:(NSInteger)index
{
    
    NSLog(@"node index : %ld", index);
    NSMutableArray *photoArray = [NSMutableArray array];
    for (CodeListModel *model in self.modelArray) {
        [photoArray addObject:model.photo?model.photo:@""];
    }
    
    
//    UIImageView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    for (NSUInteger i = 0, max = self.modelArray.count; i < max; i++) {
        CodeListModel *model = self.modelArray[index];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
//        item.thumbView = (UIView *)imageNode.image;
        item.largeImageURL = [NSURL URLWithString:model.photo];
        item.largeImageSize = CGSizeMake(130, 240);
        [items addObject:item];
        if (i == index) {
//            [fromView setImageURL:[NSURL URLWithString:model.photo]];
        }
    }
    
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:@[items[index]]];
    [v presentFromImageView:nil toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
}

- (void)node:(CFHomeCellNode *)node didLinkUrl:(NSURL *)url
{
        [[UIApplication sharedApplication] openURL:url];
}


@end
