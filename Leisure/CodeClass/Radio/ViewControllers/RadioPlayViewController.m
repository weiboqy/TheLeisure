//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioPlayViewController.h"

@interface RadioPlayViewController ()

@end

@implementation RadioPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    //添加毛玻璃的效果
    [self addGlassImage];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark  ----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark  ---毛玻璃效果
- (void)addGlassImage {
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    image.image = [UIImage imageNamed:@"毛玻璃"];
    [self.view addSubview:image];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    [self.view addSubview:blurView];
}


#pragma mark  ---item的功能实现
- (void)circulation {
    QYLog(@"%s", __func__);
}
- (void)collect {
    QYLog(@"%s", __func__);
}
- (void)share {
    QYLog(@"%s", __func__);
}
- (void)timeAction {
    QYLog(@"%s", __func__);
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
