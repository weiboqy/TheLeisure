//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioListModel.h"

@interface RadioDetailViewController ()




@end

@implementation RadioDetailViewController


- (void)reloadData{
    NSLog(@"33");
    [NetWorkRequesManager requestWithType:POST urlString:RADIODETAILMORE_URL parDic:@{@"radioid" : _radioid} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSLog(@"详情列表 dataDic = %@", dataDic);
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    NSLog(@"11");
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
