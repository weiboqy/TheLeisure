
//
//  BaseNavigtionViewController.m
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseNavigtionViewController.h"

@interface BaseNavigtionViewController ()

@end

@implementation BaseNavigtionViewController

- (void)initNavigationBar {
    //隐藏自带的NavigationBar
    [self setNavigationBarHidden:YES];
    //设置view的大小
    UIView *naView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    naView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:naView];
    
    //创建自定义的NavigationBar
    _navigatonBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    _navigatonBar.titleLabel.text = @"阅读";
    [self.view addSubview:_navigatonBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加自定义的NavigationBar
    [self initNavigationBar];
    // Do any additional setup after loading the view.
}

/**
 *  可以在这个方法中芥蓝所有push进来的控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 如果push进来的不是第一个控制器
    if (self.childViewControllers.count > 0) {
        [_navigatonBar.menuBtu setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_navigatonBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _navigatonBar.titleLabel.text = @"";
    }
    
    // 这句super的push要放在后面，让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
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
