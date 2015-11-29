//
//  CFFriendsViewController.m
//  Code4App
//
//  Created by Sniper on 15/11/29.
//  Copyright © 2015年 ShengQiangLiu. All rights reserved.
//

#import "CFFriendsViewController.h"
#import "CFChatServerManager.h"

@interface CFFriendsViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    NSFetchedResultsController *_fetchedResultController;
    XMPPUserCoreDataStorageObject *_currentUser;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation CFFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initSubviews];
    
}

- (void)dealloc
{
    _fetchedResultController.delegate = nil;
}

- (void)initSubviews
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.frame = self.view.frame;
    
}

//获取好友列表的结果控制对象
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultController == nil)
    {
        NSManagedObjectContext *moc = [[CFChatServerManager sharedManager] rosterContext];
        
        //数据存储实体（表）
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                                  inManagedObjectContext:moc];
        
        //设置结果的排序规则
        NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
        NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
        
        NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
        
        //数据请求
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:entity];
        [fetchRequest setSortDescriptors:sortDescriptors];
        [fetchRequest setFetchBatchSize:10];
        
        _fetchedResultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                       managedObjectContext:moc
                                                                         sectionNameKeyPath:@"sectionNum"
                                                                                  cacheName:nil];
        [_fetchedResultController setDelegate:self];
        
        
        NSError *error = nil;
        //开始请求数据
        if (![_fetchedResultController performFetch:&error])
        {
            NSLog(@"Error performing fetch: %@", error);
        }
        
    }
    
    return _fetchedResultController;
}


//数据改变
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[[self fetchedResultsController] sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sections = [[self fetchedResultsController] sections];
    id <NSFetchedResultsSectionInfo> sectionInfo = [sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //获取用户信息
    XMPPUserCoreDataStorageObject *user = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    cell.textLabel.text = user.jid.user;
    if (user.photo != nil) {
        cell.imageView.image = user.photo;
    }
    else
    {
        //获取头像数据
        NSData *photoData = [[[CFChatServerManager sharedManager] avatarModule] photoDataForJID:user.jid];
        
        if (photoData != nil)
        {
            cell.imageView.image = [UIImage imageWithData:photoData];
        }
        else
        {
            cell.imageView.image = [UIImage imageNamed:@"Friends_head"];
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
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
