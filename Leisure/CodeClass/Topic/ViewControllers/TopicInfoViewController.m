//
//  TopicInfoViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "TopicInfoViewController.h"

@interface TopicInfoViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TopicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.model.title;
    
    [self addCustomNavigationBar];
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
