//
//  RadioViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioViewController.h"
#import "RadioListModel.h"
#import "RadioCarouseModel.h"
#import "RadioDetailViewController.h"

@interface RadioViewController ()
/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
/**轮播图数据源*/
@property (strong, nonatomic)NSMutableArray *carouselArr;
/**热门列表数据源*/
@property (strong, nonatomic)NSMutableArray *hotArr;

/**start*/
@property (assign, nonatomic)NSInteger start;
/**limit*/
@property (assign, nonatomic)NSInteger limit;

@end

@implementation RadioViewController

- (NSMutableArray *)listArr {
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (NSMutableArray *)carouselArr{
    if (!_carouselArr) {
        _carouselArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _carouselArr;
}

- (NSMutableArray *)hotArr {
    if (_hotArr == nil) {
        _hotArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _hotArr;
}
//首次请求
- (void)requestFirstData {
    [NetWorkRequesManager requestWithType:POST urlString:RADIOLIST_URL parDic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//        NSLog(@"%@", dic);
        
        //获取所以电台列表信息
        for (NSDictionary *listDic in dic[@"data"][@"allList"]) {
            RadioListModel *listModel = [[RadioListModel alloc]init];
            RadioUserInfoModel *userInfoModel = [[RadioUserInfoModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:listDic];
            [userInfoModel setValuesForKeysWithDictionary:listDic[@"userinfo"]];
            
            listModel.userinfo = userInfoModel;
            
            [self.listArr addObject:listModel];
            
        }
        //获取轮播图数据
        NSArray *carouselArr = dic[@"data"][@"carousel"];
        for (NSDictionary *carouselDic in carouselArr) {
            RadioCarouseModel *carouseModel = [[RadioCarouseModel alloc]init];
            [carouseModel setValuesForKeysWithDictionary:carouselDic];
            [self.carouselArr addObject:carouseModel];
        }
        
        //获取热们电台数据
        for (NSDictionary *hotDic in dic[@"data"][@"hotlist"]) {
            RadioListModel *listModel = [[RadioListModel alloc]init];
            RadioUserInfoModel *userInfoModel = [[RadioUserInfoModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:hotDic];
            [userInfoModel setValuesForKeysWithDictionary:hotDic[@"userinfo"]];
            
            listModel.userinfo = userInfoModel;
            [self.hotArr addObject:listModel];
        }
        
        //回到主线程 刷新数据 操作UI视图
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

//上拉刷新请求
- (void)requestRefresh {
    [NetWorkRequesManager requestWithType:POST urlString:RADIOLISTMORE_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", dic);
        
        for (NSDictionary *refreshDic in dic[@"data"][@"list"]) {
            RadioListModel *listModel = [[RadioListModel alloc]init];
            RadioUserInfoModel *userInfoModel = [[RadioUserInfoModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:refreshDic];
            [userInfoModel setValuesForKeysWithDictionary:refreshDic[@"userinfo"]];
            
            listModel.userinfo = userInfoModel;
            
            [self.listArr addObject:listModel];
        }
       
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            RadioDetailViewController *detailVC = [[RadioDetailViewController alloc]init];
            RadioListModel *listModel = [self.listArr objectAtIndex:0];
            detailVC.radioid = listModel.radioid;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    //首次请求 列表数据
    [self requestFirstData];
    //上拉刷新数据
    [self requestRefresh];
    // Do any additional setup after loading the view from its nib.
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
