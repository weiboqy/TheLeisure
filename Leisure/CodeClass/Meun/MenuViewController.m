//
//  MenuViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "RadioViewController.h"
#import "DrawerViewController.h"
#import "ProductViewController.h"
#import "ReadViewController.h"
#import "TopicViewController.h"
#import "MenuFootView.h"
#import "MenuHeaderView.h"
#import "LoginViewController.h"
#import "UserInfoManager.h"
#import "UserCollectViewController.h"


@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *menu;
@property (strong, nonatomic)UITableView *tableView;

@property (strong, nonatomic)MenuHeaderView *headerView;
@property (strong, nonatomic)MenuFootView *footView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.menu= [[NSMutableArray alloc]initWithCapacity:0];
    [self.menu addObject:@"阅读"];
    [self.menu addObject:@"电台"];
    [self.menu addObject:@"话题"];
    [self.menu addObject:@"良品"];
    
    
    //创建列表展示
    [self createListView];
    // Do any additional setup after loading the view from its nib.
}

//创建列表
- (void)createListView {
    self.headerView = [[MenuHeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_headerView.name addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerView.loveButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.headerView];
    self.footView = [[MenuFootView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 90, ScreenWidth, 90)];
    [self.view addSubview:self.footView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, ScreenHeight - 150 - 90) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.tableView];
}


//当登陆成功后，将"登陆/注册"换成用户名
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "] ) {
        [_headerView.name setTitle:[NSString stringWithFormat:@"%@", [UserInfoManager getUserName]] forState:UIControlStateNormal];
//        _headerView.iconImage.image = [UIImage imageNamed:[UserInfoManager getUsercoverimg]];
    }else {
        return;
    }
}

//登陆按钮的实现
- (void)loginClick {
    //已经登陆 ，取消登陆
    if (![[UserInfoManager getUserAuth] isEqualToString:@" "]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:@"你已经登陆,是否取消登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [UserInfoManager cancelUserAuth];
            [UserInfoManager cancelUserID];
            [_headerView.name setTitle:@"登陆/注册" forState:UIControlStateNormal];
        }];
        [alertController addAction:action];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:nil];
   
}

//收藏按钮的实现
- (void)likeClick {
    UserCollectViewController *collectVC = [[UserCollectViewController alloc]init];
    [self presentViewController:collectVC animated:YES completion:nil];
}


#pragma mark  ---UITableViewDelegate \ UITableViewDataSource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menu count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = self.menu[indexPath.row];
    cell.backgroundColor = [UIColor grayColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerVC;
    
    if (indexPath.row == 0) {
        // 设置阅读为抽屉的根视图
        [self setRootViewController:[[ReadViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 1) {
        // 设置电台为抽屉的根视图
        [self setRootViewController:[[RadioViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 2) {
        // 设置话题为抽屉的根视图
        [self setRootViewController:[[TopicViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 3) {
        // 设置良品为抽屉的根视图
        [self setRootViewController:[[ProductViewController alloc] init] menuController:menuController];
    }
}
//封装
- (void)setRootViewController:(BaseViewController *)viewController menuController:(DrawerViewController *)menuController {
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [menuController setNavController:navigationController animated:YES];
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
