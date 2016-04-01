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
    return  cell;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取抽屉对象
    DrawerViewController *menuController = (DrawerViewController *)((AppDelegate *)[[UIApplication sharedApplication] delegate]).drawerVC;
    
    if (indexPath.row == 0) { // 设置阅读为抽屉的根视图

        ReadViewController *readVC = [[ReadViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:readVC];
        [menuController setNavController:naVC animated:YES];
        
    } else if (indexPath.row == 1) { // 设置电台为抽屉的根视图

        RadioViewController *radioVC = [[RadioViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:radioVC];
        [menuController setNavController:naVC animated:YES];
        
    } else if (indexPath.row == 2) { // 设置话题为抽屉的根视图

        TopicViewController *topicVC = [[TopicViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:topicVC];
        [menuController setNavController:naVC animated:YES];
        
    } else if (indexPath.row == 3) { // 设置良品为抽屉的根视图

        ProductViewController *productVC = [[ProductViewController alloc]init];
        UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:productVC];
        [menuController setNavController:naVC animated:YES];
        
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