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
#import "ProductInfoViewController.h"

@interface ProductViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;


//参数
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
    //添加指示器
    [SVProgressHUD show];
   
    [NetWorkRequesManager requestWithType:POST urlString:SHOPLIST_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        if (_start == 0) {
            [self.listArr removeAllObjects];
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        NSLog(@"%@", dic);
        
        for (NSDictionary *listDic in dic[@"data"][@"list"]) {
            ProductListModel *listModel = [[ProductListModel alloc]init];
            [listModel setValuesForKeysWithDictionary:listDic];
            [self.listArr addObject:listModel];
           
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            
        });
        
        //请求结束 关闭指示器
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        
        //请求失败
        [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self requestListData]; 启用第三方刷新
    
    //列表展示
    [self createListView];
    
    
    //使用第三方MJRefresh类库
    [self refreshHeader];
    
    //数据加载
    [self loadNewData];
    // Do any additional setup after loading the view from its nib.
}

- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ProductTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    
    
}

#pragma mark ---使用第三方MJRefresh类库
- (void)refreshHeader {
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    //
    
    // 马上进入刷新状态
    //    [self.tableView.mj_header beginRefreshing];  //刚进去视图会有一种波动感
    
    //    [self.tableView.mj_footer beginRefreshing];
    //默认显示
    [self loadNewData];
    
}
- (void)loadNewData {
    _start = 0;
    [self requestListData];
    
}

- (void)loadMoreData {
    _start += 10;
    [self requestListData];
    
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductInfoViewController *infoVC = [[ProductInfoViewController alloc]init];
    ProductListModel *model = self.listArr[indexPath.row];
    infoVC.contentid = model.contentid;
    [self.navigationController pushViewController:infoVC animated:YES];
}



- (void)shoping:(UIButton *)button {
    ProductListModel *model = self.listArr[button.tag];
    QYLog(@"%@", self.listArr[button.tag]);
    QYLog(@"%@", model.buyurl);
    //打开程序外的应用
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
