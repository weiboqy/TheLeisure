//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductInfoModel.h"

@interface ProductInfoViewController ()

@end

@implementation ProductInfoViewController


- (void)parseDetailData {
    [NetWorkRequesManager requestWithType:POST urlString:@"http://api2.pianke.me/group/posts_info" parDic:@{@"contentid" : _contentid} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        QYLog(@"%@", dic);
        ProductInfoModel *infoModel = [[ProductInfoModel alloc]init];
        [infoModel setValuesForKeysWithDictionary:dic];
        QYLog(@" html == %@", infoModel.title);
    } error:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //详情列表加载
    [self parseDetailData];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark  -----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [bar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//    bar.titleLabel.text = _headerView.model.title;
    [self.view addSubview:bar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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
