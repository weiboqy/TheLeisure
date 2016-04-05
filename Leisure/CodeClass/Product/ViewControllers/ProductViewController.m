//
//  ProductViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductListModel.h"
#import "ProductTableViewCell.h"

@interface ProductViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;

@property (assign, nonatomic)NSInteger start;
@property (assign, nonatomic)NSInteger limit;

/**列表*/
@property (strong, nonatomic)UITableView *tableView;

@end

@implementation ProductViewController

- (NSMutableArray *)listArr {
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}

- (void)requestListData {
    [NetWorkRequesManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
        for (NSDictionary *listDic in dic[@"data"][@"list"]) {
            ProductListModel *listModel = [[ProductListModel alloc]init];
            [listModel setValuesForKeysWithDictionary:listDic];
            [self.listArr addObject:listModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestListData];
    
    //列表展示
    [self createListView];
    // Do any additional setup after loading the view from its nib.
}

- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductTableViewCell class])];
    [self.view addSubview:self.tableView];
    
}

#pragma mark  ---UITableViewDelegate \ UITableViewDataSoruce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 209;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ProductTableViewCell class])];
    ProductListModel *model = self.listArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    cell.buyUrlLabel.tag = indexPath.row;
    [cell.buyUrlLabel addTarget:self action:@selector(shoping:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)shoping:(UIButton *)button {
    ProductListModel *model = self.listArr[button.tag];
    QYLog(@"%@", self.listArr[button.tag]);
    QYLog(@"%@", model.buyurl);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.buyurl]];
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
