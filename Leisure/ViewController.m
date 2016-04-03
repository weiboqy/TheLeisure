//
//  ViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ViewController.h"
#import "BaseViewController.h"
#import "ReadViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (assign, nonatomic)BOOL showLeft;
@property (strong, nonatomic)NSArray *VCName;
@property (strong, nonatomic)BaseViewController *baseVC;
@property  UINavigationController *naVC;
@property (strong, nonatomic)NSArray *arr;
@property (strong, nonatomic)UILabel *nameLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    self.VCName = @[@"ReadViewController", @"RadioViewController", @"TopicViewController", @"ProductViewController"];
    
    self.baseVC = [[ReadViewController alloc]init];
    self.naVC = [[UINavigationController alloc]initWithRootViewController:self.baseVC];
    
    //标题
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 27, 42, 30)];
    self.nameLabel.text = @"阅读";
    [self.naVC.view addSubview:self.nameLabel];
    
    //导航条按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftShow:)];
    self.baseVC.navigationItem.leftBarButtonItem = left;
    
    [self.view addSubview:self.naVC.view];
    
    
    //手势 用来取消左视图
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.baseVC.view addGestureRecognizer:tap];
    [self.naVC.view addGestureRecognizer:tap];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark ---手势方法 左视图取消-
- (void)tap:(UITapGestureRecognizer *)tap{
    //激活手势功能
    [tap setEnabled:YES];
    
    //查找导航控制器的根视图
    UIView *rootView = nil;
    for (UIView *view  in self.view.subviews) {
        if (view == self.naVC.view) {
            rootView = view;
        }
    }
    // 显示菜单的标示为YES时 表示菜单为显示状态，需要隐藏菜单视图；
    if (self.showLeft == YES) {
        CGRect frame = CGRectMake(0 , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            rootView.frame = frame;
        } completion:^(BOOL finished) {
            self.showLeft = NO;
            QYLog(@"点击到了");
            
        }];
    }
}
//创建tabbleView
- (void)createTableView{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y + 10, self.view.frame.size.width / 3 * 2, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self.view addSubview:self.tableView];
}

- (void)createNavigationController:(NSIndexPath*)index{
    //不管子视图是否存在，都要移除子视图，如果没有子视图，则表明不起作用
    [self.naVC.view removeFromSuperview];
    
    NSString *name = self.VCName[index.row];
    Class class = NSClassFromString(name);
    self.baseVC = [[class alloc] init];
    self.naVC = [[UINavigationController alloc]initWithRootViewController:self.baseVC];
    //创建标题
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 27, 42, 30)];
    nameLabel.text = self.arr[index.row];
    [self.naVC.view addSubview:nameLabel];
    
    //创建导航条按钮
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStylePlain target:self action:@selector(leftShow:)];
    self.baseVC.navigationItem.leftBarButtonItem = left;
//    NSLog(@"%@", self.naVC.navigationBar.subviews);  //导航条子视图
    
    self.naVC.view.frame = CGRectMake(self.view.frame.size.width / 3 * 2, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:.3 animations:^{
        self.naVC.view.frame = self.view.bounds;
    } completion:^(BOOL finished) {
        self.showLeft = NO;
    }];
    
    [self.view addSubview:self.naVC.view];
    
}
- (void)leftShow:(id)sender {
    //查找导航控制器的根视图
    UIView *rootView = nil;
    for (UIView *view  in self.view.subviews) {
        if (view == self.naVC.view) {
            rootView = view;
        }
    }
    // 显示菜单的标示为YES时 表示菜单为显示状态，需要隐藏菜单视图；
    if (self.showLeft == YES) {
        CGRect frame = CGRectMake(0 , self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            rootView.frame = frame;
        } completion:^(BOOL finished) {
            self.showLeft = NO;// 将显示菜单的标示修改成NO，表示菜单未显示
        }];
    }else{
        // 显示菜单的标示为NO时 表示菜单为未显示状态，需要显示菜单视图；
        // 动画修改导航控制器的根视图的frame，往右偏移屏幕的2/3
        CGRect frame = CGRectMake(self.view.frame.size.width / 3 * 2, self.view.frame.origin.y, self.view.frame.size.width , self.view.frame.size.height);
        [UIView animateWithDuration:.3 animations:^{
            rootView.frame = frame;
        } completion:^(BOOL finished) {
            self.showLeft = YES;
        }];
    }
}


#pragma mark ----tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.VCName.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuse = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
    }
    self.arr = @[@"阅读",@"电台",@"话题", @"良品"];
    cell.textLabel.text = self.arr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 如果选中的cell是当前的cell，就不用创建新的视图，相当于点了一下左按钮
    if ([self.baseVC isKindOfClass:NSClassFromString(self.VCName[indexPath.row])]) {
        [self leftShow:nil];
        return;
    }
    [self createNavigationController:indexPath];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
