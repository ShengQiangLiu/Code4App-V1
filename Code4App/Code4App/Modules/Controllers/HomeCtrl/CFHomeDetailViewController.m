//
//  CFHomeDetailViewController.m
//  Code4App
//
//  Created by admin on 15/11/22.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFHomeDetailViewController.h"
#import "CFAppDataManager.h"
#import "CodeDetailModel.h"
#import "CFHomeDetailNode.h"

@interface CFHomeDetailViewController () <UIWebViewDelegate>
@property (nonatomic, strong) CodeDetailModel *model;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CFHomeDetailViewController

#pragma mark - View lifeCycle
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // * 如果在init方法里面做self.view 的操作，会先调用viewDidLoad。
        self.navigationController.title = self.naviTitle;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSubviews];
    [self fetchDetailDataShource];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Method
- (void)initSubviews
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview:self.webView];

}

//AutoLayout
-(void)viewWillLayoutSubviews
{
    //更正尺寸
    _webView.frame = self.view.bounds;
}

- (void)fetchDetailDataShource
{
    @weakify(self);
    [[CFAppDataManager sharedInstance] codeDetailModelWithUrl:self.href result:^(id result) {
        @strongify(self);
        self.model = result;
        NSString *html = [NSString stringWithFormat:@"\
                          <html>\
                          <head>\
                          <style type=\"text/css\">\
                          h1{\
                                font-size: 18px;\
                                max-width: 320px;\
                          };\
                          div{\
                                max-width: 320px;\
                                font-size: 18px;\
                          };\
                            \
                          </style>\
                          </head>\
                          <body>\
                            <div>%@<br>%@<br>%@</div>\
                          </body>\
                          </html>", self.model.codeintro, self.model.codeenv, self.model.codeusage];
        [self.webView loadHTMLString:html baseURL:nil];
        NSLog(@"%@", self.model.codeusage);
    }];
}


@end
