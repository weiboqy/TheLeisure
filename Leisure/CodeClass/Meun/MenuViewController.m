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
#import "ReadViewController.h"
#import "ProductViewController.h"
#import "TopicViewController.h"
#import "DrawerViewController.h"


@interface MenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)NSMutableArray *menu;
@property (strong, nonatomic)UITableView *tableView;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.menu= [[NSMutableArray alloc]initWithCapacity:0];
    [self.menu addObject:@"阅读"];
    [self.menu addObject:@"电台"];
    [self.menu addObject:@"良品"];
    [self.menu addObject:@"话题"];
    
    self.tableView = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}
//返回有多少个TableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.menu count];
}
//设置行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

//设置cell的每一条数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    cell.textLabel.text = self.menu[indexPath.row];
    return  cell;
}

//cell点击方法
-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerVC;
    
    if (indexPath.row == 0) { // 设置阅读为抽屉的根视图

        [self setRootViewController:[[ReadViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 1) { // 设置电台为抽屉的根视图

        [self setRootViewController:[[RadioViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 2) { // 设置话题为抽屉的根视图

        [self setRootViewController:[[TopicViewController alloc] init] menuController:menuController];
        
    } else if (indexPath.row == 3) { // 设置良品为抽屉的根视图

        [self setRootViewController:[[ProductViewController alloc] init] menuController:menuController];
        
    }
}

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
