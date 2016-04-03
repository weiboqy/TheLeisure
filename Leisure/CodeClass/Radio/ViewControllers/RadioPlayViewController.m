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
    self.navigationItem.rightBarButtonItems = @[
                                                [UIBarButtonItem itemWithImage:@"时" selectImage:nil target:self action:@selector(timeAction)],
                                                [UIBarButtonItem itemWithImage:@"享" selectImage:nil target:self action:@selector(share)],
                                                [UIBarButtonItem itemWithImage:@"藏" selectImage:nil target:self action:@selector(collect)],
                                                [UIBarButtonItem itemWithImage:@"循" selectImage:nil target:self action:@selector(circulation)]
                                                ];
    // Do any additional setup after loading the view from its nib.
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
