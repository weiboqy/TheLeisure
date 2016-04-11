//
//  RadioDetailViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "RadioDetailListModel.h"
#import "RadioInfoModel.h"
#import "UIImageView+WebCache.h"
#import "RadioDetailTableViewCell.h"
#import "RadioUserInfoModel.h"
#import "RadioPlayViewController.h"
#import "RadioDetailHeader.h"
#import "RadioPlayInfo.h"
#import "RadioPlayInfo.h"
#import "RadioShareInfo.h"



@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
//@property (strong, nonatomic)NSMutableArray *playListArr;

/**列表*/
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)RadioDetailHeader *headerView;

/**请求参数*/
@property (assign, nonatomic)NSInteger start;
@property (assign, nonatomic)BOOL isFrefresh;
@property (assign, nonatomic)NSInteger limit;


@end

@implementation RadioDetailViewController

static NSInteger count = 0;

#pragma mark  ----懒加载
- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArr;
}

//- (NSMutableArray *)playListArr {
//    if (_playListArr == nil) {
//        _playListArr = [[NSMutableArray alloc]initWithCapacity:0];
//    }
//    return _playListArr;
//}

#pragma mark   ----数据加载
- (void)loadNewData{
    //添加指示器
    [SVProgressHUD show];
    
      [NetWorkRequesManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:@{@"radioid" : _radioid} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
//          QYLog(@"==!=%@", dataDic);
          if (data == nil) {
              return ;
          }else {
              [self.listArr removeAllObjects];
          }
        //获取列表信息
        for (NSDictionary *listDic in dataDic[@"data"][@"list"]) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:listDic];
            
            // 创建playinfo
            RadioPlayInfo *playInfo = [[RadioPlayInfo alloc] init];
            [playInfo setValuesForKeysWithDictionary:listDic[@"playInfo"]];
//            QYLog(@"webUrl =====%@", playInfo.webview_url);
            
            // 创建authorinfo
            RadioUserInfoModel *authorInfo = [[RadioUserInfoModel alloc] init];
            [authorInfo setValuesForKeysWithDictionary:listDic[@"playInfo"][@"authorinfo"]];
            playInfo.authorinfo = authorInfo;
            
            // 创建shareinfo
            RadioShareInfo *shareInfo = [[RadioShareInfo alloc] init];
            [shareInfo setValuesForKeysWithDictionary:listDic[@"playInfo"][@"shareinfo"]];
            playInfo.shareinfo = shareInfo;
            
            // 创建userinfo
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:listDic[@"playInfo"][@"userinfo"]];
            playInfo.userInfo = userInfo;
            
            listModel.playInfo = playInfo;
            
            [self.listArr addObject:listModel];
            
        };
        
        //获取头视图信息
        NSDictionary *headDict = dataDic[@"data"][@"radioInfo"];
        RadioInfoModel *model =[[RadioInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:headDict];
        RadioUserInfoModel *userModel = [[RadioUserInfoModel alloc]init];
        NSDictionary *userDic = headDict[@"userinfo"];
        [userModel setValuesForKeysWithDictionary:userDic];
        model.userInfoModel = userModel;
         
        dispatch_async(dispatch_get_main_queue(), ^{
            //给头视图内部控件赋值
            self.headerView.model = model;
            //刷新tableview
            [self.tableView reloadData];
            //刷新NavigationBar标题
            [self addCustomNavigationBar];
            
            //停止刷新
            [self.tableView.mj_header endRefreshing];
            
            //显示 上拉刷新
            self.tableView.mj_footer.hidden = NO;
        });          //请求结束 关闭指示器
          

          [SVProgressHUD dismiss];
        
    } error:^(NSError *error) {
        //请求失败
        [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
    }];
}

//上拉刷新请求
- (void)loadMoreData {
    _start += 10;   //不能使用_start += _limit;  虽然说limit默认就是10，但是就是不能用
   
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    parDic[@"auth"] = @"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo";
    parDic[@"client"] = @"1";
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    parDic[@"radioid"] = _radioid;
    parDic[@"start"] = @(_start);
    [NetWorkRequesManager requestWithType:POST urlString:RADIODETAILMORE_URL parDic:parDic finish:^(NSData *data) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        QYLog(@"=========%@", dic);
        for (NSDictionary *refreshDic in dic[@"data"][@"list"]) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:refreshDic];

            // 创建playinfo
            RadioPlayInfo *playInfo = [[RadioPlayInfo alloc] init];
            [playInfo setValuesForKeysWithDictionary:refreshDic[@"playInfo"]];
            QYLog(@"webUrl =====%@", playInfo.webview_url);
            
            // 创建authorinfo
            RadioUserInfoModel *authorInfo = [[RadioUserInfoModel alloc] init];
            [authorInfo setValuesForKeysWithDictionary:refreshDic[@"playInfo"][@"authorinfo"]];
            playInfo.authorinfo = authorInfo;
            
            // 创建shareinfo
            RadioShareInfo *shareInfo = [[RadioShareInfo alloc] init];
            [shareInfo setValuesForKeysWithDictionary:refreshDic[@"playInfo"][@"shareinfo"]];
            playInfo.shareinfo = shareInfo;
            
            // 创建userinfo
            RadioUserInfoModel *userInfo = [[RadioUserInfoModel alloc] init];
            [userInfo setValuesForKeysWithDictionary:refreshDic[@"playInfo"][@"userinfo"]];
            playInfo.userInfo = userInfo;
            
            listModel.playInfo = playInfo;
            
           
          listModel.total = [refreshDic[@"data"][@"total"] integerValue];
            [self.listArr addObject:listModel];
            count += self.listArr.count;
        }
        
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RadioDetailListModel *model = self.listArr[self.listArr.count - 1];
            
            if (model.total == count) {
                QYLog(@"结束");
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
                QYLog(@"total = %ld, count = %ld", model.total, count);
                QYLog(@"还有");
            }
            
            [self.tableView reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    count = 0;
    //加载数据
//    [self reloadData]; 启用第三方
    [self loadNewData];
    
    //已导航条左下角为原点
    self.navigationController.navigationBar.translucent = YES;
    
    //创建视图列表
    [self creatListView];
    
    //自定义导航条
    [self addCustomNavigationBar];
    [self loadMoreData];
}

#pragma mark  -----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [bar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    bar.titleLabel.text = _headerView.model.title;
    [self.view addSubview:bar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

//创建视图列表
- (void)creatListView {
    //初始化头视图
    self.headerView = [[RadioDetailHeader alloc]init];
    self.headerView.frame = CGRectMake(0, 44, ScreenWidth, 260);
    
    self.tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailTableViewCell class])];
    
#pragma mark ---使用第三方MJRefresh类库
    
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    //上拉加载更多
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.view addSubview:self.tableView];
    
    
}

#pragma mark ----UITableViewDelegate \ UITableDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RadioDetailTableViewCell class])];
    RadioDetailListModel *model = self.listArr[indexPath.row]
    ;
    [cell.actionButton addTarget:self action:@selector(actionPlay) forControlEvents:UIControlEventTouchUpInside];

//    [self actionPlay:indexPath.row];
    [cell setDataWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc]init];
    playVC.seleteIndex = indexPath.row;
    playVC.playListArr = self.listArr;
    [self.navigationController pushViewController:playVC animated:YES];
}

- (void)actionPlay {
    //创建播放器管理器对象
//    PlayerManager *manager = [PlayerManager defaultManager];
//   
//    NSMutableArray *playListArr = [NSMutableArray array];
//    RadioDetailListModel *model = self.playListArr[self.tableView.indexPathForSelectedRow.row];
//    [playListArr addObject:model.musicUrl];
//    
//    //传入播放数组中
//    [manager setMusicArray:playListArr];
////     manager.playIndex = self.tableView.indexPathForSelectedRow.row;
//    //播放
//    [manager play];
    QYLog(@".....");
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
