//
//  ProductViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"

@interface ProductViewController ()

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;

@property (assign, nonatomic)NSInteger start;
@property (assign, nonatomic)NSInteger limit;

@end

@implementation ProductViewController

- (NSMutableArray *)listArr {
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)requestListData {
    [NetWorkRequesManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
        for (NSDictionary *listDic in dic[@"data"][@"list"]) {
            ProductListModel *listModel = [[ProductListModel alloc]init];
            [listModel setValuesForKeysWithDictionary:listDic];
            [self.listArr addObject:listModel];
        }
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self requestListData];
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
