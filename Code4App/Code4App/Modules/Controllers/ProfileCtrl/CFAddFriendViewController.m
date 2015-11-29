//
//  CFAddFriendViewController.m
//  Code4App
//
//  Created by Sniper on 15/11/29.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFAddFriendViewController.h"
#import "UserInfo.h"
#import "CFChatServerManager.h"

@interface CFAddFriendViewController ()
@property (nonatomic, strong) UITextField *userField;
@property (nonatomic, strong) UIButton *addBtn;
@end

@implementation CFAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.userField = [[UITextField alloc] init];
    self.userField.placeholder = @"朋友账号";
    self.userField.frame = CGRectMake(10, 70, 200, 40);
    [self.view addSubview:self.userField];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    self.addBtn.frame = CGRectMake(self.userField.frame.size.width + 10, self.userField.frame.origin.y, 50, 50);
    [self.addBtn addTarget:self action:@selector(didAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addBtn];
 
//    [self.userField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).with.offset(100);
//        make.left.equalTo(self.view.mas_left).with.offset(20);
//        make.right.equalTo(self.view.mas_right).with.offset(-20);
//        make.height.mas_equalTo(40);
//    }];
//    
//    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.userField.mas_bottom).with.offset(10);
//        make.left.equalTo(self.view.mas_left).width.offset(20);
//        make.right.equalTo(self.view.mas_right).width.offset(-20);
//        make.height.mas_equalTo(50);
//    }];
    
}

- (void)didAddBtn:(UIButton *)sender
{
    if (self.userField.text.length) {
        UserInfo *user = [[UserInfo alloc] init];
        user.username = self.userField.text;
        [[CFChatServerManager sharedManager] addFriend:user];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
