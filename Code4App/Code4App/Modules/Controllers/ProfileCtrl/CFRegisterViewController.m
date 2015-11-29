//
//  CFRegisterViewController.m
//  Code4App
//
//  Created by Sniper on 15/11/28.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFRegisterViewController.h"
#import "CFChatServerManager.h"
#import "UserInfo.h"

@interface CFRegisterViewController ()
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *registerBtn;

@end

@implementation CFRegisterViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.navigationController.navigationItem.title = @"注册";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];
    [self layoutSubviews];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initSubviews
{
    self.usernameField = [[UITextField alloc] init];
    self.usernameField.placeholder = @"请输入用户名";
    [self.view addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.placeholder = @"请输入密码";
    [self.view addSubview:self.passwordField];
    
    self.registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.registerBtn.backgroundColor = [UIColor blackColor];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
}

- (void)layoutSubviews
{
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usernameField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(20);
        make.right.equalTo(self.view.mas_right).with.offset(-20);
        make.height.mas_equalTo(40);
    }];
    
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).with.offset(10);
        make.left.equalTo(self.view.mas_left).with.offset(40);
        make.right.equalTo(self.view.mas_right).with.offset(-40);
        make.height.mas_equalTo(50);
    }];

}

- (void)registerBtnClick:(UIButton *)sender
{
    UserInfo *user = [[UserInfo alloc] init];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    [[CFChatServerManager sharedManager] registerUser:user];
}

@end
