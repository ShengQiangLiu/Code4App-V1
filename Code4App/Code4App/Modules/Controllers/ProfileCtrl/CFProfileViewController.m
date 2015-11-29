//
//  CFProfileViewController.m
//  Code4App
//
//  Created by admin on 15/11/19.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFProfileViewController.h"
#import "CFRegisterViewController.h"
#import "ShareManager.h"
#import "CFLoginViewController.h"
#import "CFAddFriendViewController.h"

@interface CFProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CFProfileViewController

#pragma mark - View Lifecycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationItem.title = @"Profile";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initsubviews];

    
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [[ShareManager sharedInstance] showMenu];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    self.tableView.frame = self.view.frame;
}

#pragma mark - Private Method
- (void)initsubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    [self.view addSubview:self.tableView];

}
#pragma mark - UITableView
#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

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
    if (indexPath.section == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"aaaa %@", @"注册"];
    }
    else if (indexPath.section ==0)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"aaaa %@", @"登录"];
    }
    else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"aaaa %@", @"添加好友"];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section: %ld, row: %ld", indexPath.section, indexPath.row);
    if (indexPath.section == 1)
    {
        CFRegisterViewController *registerViewCtrl = [[CFRegisterViewController alloc] init];
        [self.navigationController pushViewController:registerViewCtrl animated:YES];
    }
    else if (indexPath.section == 0)
    {
        CFLoginViewController *loginViewCtrl = [[CFLoginViewController alloc] init];
        [self.navigationController pushViewController:loginViewCtrl animated:YES];
    }
    else
    {
        CFAddFriendViewController *addFriendViewCtrl = [[CFAddFriendViewController alloc] init];
        [self.navigationController pushViewController:addFriendViewCtrl animated:YES];
    }
  
}

@end
