//
//  CFForumViewController.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFForumViewController.h"
#import "CFChatViewController.h"
#import "CFTabBarController.h"

#import "CFGroupViewController.h"
#import "CFYouViewController.h"
#import "CFFriendsViewController.h"

@interface CFForumViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CFForumViewController

#pragma mark - view lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Forum";
        [self initSubviews];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    

    [self setViewControllers:@[[CFGroupViewController new], [CFFriendsViewController new],[CFYouViewController new]]];
    [self setSelectedViewControllerIndex:0];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method

- (void)initSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)viewDidLayoutSubviews
{
    self.tableView.frame = self.view.frame;
}

#pragma mark - UITableView
#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"AFNetworking";
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CFChatViewController *chatViewCtrl = [[CFChatViewController alloc] init];
    CFTabBarController *tabBarController = (CFTabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [tabBarController setTabBarHidden:YES animated:YES];
    [self.navigationController pushViewController:chatViewCtrl animated:YES];
    
}

@end
