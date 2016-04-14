//
//  ReadDetailViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadDetailViewController.h"
#import "ReadDetailModel.h"
#import "FactoryTableViewCell.h"
#import "ReadInfoViewController.h"


@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/**请求数据的类型*/  //0最新 1热门
@property (assign, nonatomic)NSInteger requestSort;

/**请求开始位置 */
@property (assign, nonatomic)NSInteger startAddtime;
@property (assign, nonatomic)NSInteger startHot;

/**每次请求的数据条数*/
@property (assign, nonatomic)NSInteger limit; //默认是10

/**热门数据源*/
@property (strong, nonatomic)NSMutableArray *hotListArr;
/**最新数据源*/
@property (strong, nonatomic)NSMutableArray *addtimeListArr;

/**列表*/
@property (strong, nonatomic)UIScrollView *rootScrollView;
@property (strong, nonatomic)UITableView *addTableView;
@property (strong, nonatomic)UITableView *hotTableView;


/**导航条按钮*/
@property (strong, nonatomic)UIButton *NEW;
@property (strong, nonatomic)UIButton *HOT;


@end

@implementation ReadDetailViewController

- (NSMutableArray *)hotListArr {
    if (!_hotListArr) {
        self.hotListArr = [NSMutableArray array];
    }
    return _hotListArr;
}
- (NSMutableArray *)addtimeListArr {
    if (!_addtimeListArr) {
        self.addtimeListArr = [NSMutableArray array];
    }
    return _addtimeListArr;
}

- (void)requestDataWithSort:(NSString *)sort {
    //添加指示器
    [SVProgressHUD show];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    parDic[@"sort"] = sort;
    if ([sort isEqualToString:@"hot"]) {
        parDic[@"start"] = @(_startHot);
    }else {
        parDic[@"start"] = @(_startAddtime);
    }
    parDic[@"limit"] = @(_limit);
    parDic[@"typeid"] = _typeID;
    [NetWorkRequesManager requestWithType:POST urlString:READDETAILLIST_URL parDic:parDic finish:^(NSData *data) {
        if (data == nil) return ;
        if (_startAddtime == 0) {
            [self.addtimeListArr removeAllObjects];
        }
        if (_startHot == 0) {
            [self.hotListArr removeAllObjects];
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        QYLog(@"%@", dic);
        //获取详情列表里的数据源
        for (NSDictionary *listDic in dic[@"data"][@"list"]) {
            ReadDetailModel *detailModel = [[ReadDetailModel alloc] init];
            [detailModel setValuesForKeysWithDictionary:listDic];
            
            //判断添加热门还是最新
            if ([sort isEqualToString:@"hot"]) {
                [self.hotListArr addObject:detailModel];
            }else {
                [self.addtimeListArr addObject:detailModel];
            }
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.requestSort == 0) {
                
                [self.addTableView reloadData];
                //停止刷新;
                [self.addTableView.mj_header endRefreshing];
                [self.addTableView.mj_footer endRefreshing];
                [self.hotTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
            }else {
               
                [self.hotTableView reloadData];
                //停止刷新
                [self.hotTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
                [self.addTableView.mj_header endRefreshing];
                [self.addTableView.mj_footer endRefreshing];
            }
            //请求结束 关闭指示器
            [SVProgressHUD dismiss];
            
        });
    } error:^(NSError *error) {
        //请求失败
        [SVProgressHUD showErrorWithStatus:@"请求数据失败"];
    }];
}


- (void)creatListTable {
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44)];
    self.rootScrollView.contentSize = CGSizeMake(ScreenWidth * 2, 0);
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    self.rootScrollView.delegate = self;
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.bounces = NO;
    self.rootScrollView.showsHorizontalScrollIndicator = NO;
    
    //最新列表
    self.addTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, ScreenHeight - 60) style:UITableViewStylePlain];
    self.addTableView.delegate = self;
    self.addTableView.dataSource = self;
    
    //热门列表
    self.hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 10, ScreenWidth, ScreenHeight - 60) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    
    //注册cell
    [self.addTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    [self.rootScrollView addSubview:self.addTableView];
    [self.rootScrollView addSubview:self.hotTableView];
    [self.view addSubview:self.rootScrollView];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //默认请求列表是addtime
    _requestSort = 0;
    
//    [self requestDataWithSort:@"addtime"]; 启用第三方
    //默认显示
    [self loadNewAddtimeData];
    
    [self creatListTable];
    
    //以导航条左下角为原点
    self.navigationController.navigationBar.translucent = NO;
    
    //自定义导航条按钮
    [self addCustomNavigationBar];
    
    [self refreshHeader];
}
#pragma mark ---使用第三方MJRefresh类库
- (void)refreshHeader {
    //下拉刷新
    self.hotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewHotData)];
    self.addTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewAddtimeData)];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    
    //上拉加载更多
    self.hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreHotData)];
    self.addTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreAddtimeData)];
    
    // 马上进入刷新状态
//    [self.addTableView.mj_header beginRefreshing];
//    [self.hotTableView.mj_header beginRefreshing];
//    [self.addTableView.mj_footer beginRefreshing];
//    [self.hotTableView.mj_footer beginRefreshing];
    
    
}
- (void)loadNewAddtimeData {
    
    _startAddtime = 0;
    [self requestDataWithSort:@"addtime"];
}
- (void)loadNewHotData {
    
    _startHot = 0;
    [self requestDataWithSort:@"hot"];
}
- (void)loadMoreAddtimeData {
    
    _startAddtime += 10;
    [self requestDataWithSort:@"addtime"];
}
- (void)loadMoreHotData {
    
    _startHot += 10;
    [self requestDataWithSort:@"hot"];
    
}

#pragma mark ----自定义导航条按钮
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.titleLabel.text = _name;
    
    _NEW= [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 14, 15, 30)];
    _NEW.tag = 110;
    _NEW.selected = YES;
    [_NEW setBackgroundImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_NEW addTarget:self action:@selector(NEWAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationBar addSubview:_NEW];
    
    _HOT = [[UIButton alloc] initWithFrame:CGRectMake(_NEW.frame.size.width + _NEW.frame.origin.x + 30, _NEW.frame.origin.y, _NEW.frame.size.width, _NEW.frame.size.height)];
    _HOT.tag = 111;
    
    
    [_HOT setBackgroundImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_HOT addTarget:self action:@selector(HOTAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationBar addSubview:_HOT];
    [self.view addSubview:navigationBar];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)HOTAction {
    [self.hotTableView.mj_header beginRefreshing];
    [_NEW setBackgroundImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_HOT setBackgroundImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    
    CGPoint offset = CGPointMake(ScreenWidth, 0);
    self.rootScrollView.contentOffset = offset;
    self.requestSort = 1;
    _HOT.selected = YES;
    _NEW.selected = NO;
    if (self.hotListArr.count != 0) {
        return;
    }
    [self requestDataWithSort:@"hot"];
    
   //放在后面 会有异常 不起作用
//    [_NEW setBackgroundImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
//    [_HOT setBackgroundImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
}
- (void)NEWAction {
    [self.addTableView.mj_header beginRefreshing];
    [_NEW setBackgroundImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_HOT setBackgroundImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    CGPoint offset = CGPointMake(0, 0);
    self.rootScrollView.contentOffset = offset;
    self.requestSort = 0;
    _HOT.selected = NO;
    _NEW.selected = YES;
    if (self.addtimeListArr.count != 0) {
        return;
    }
    [self requestDataWithSort:@"addtime"];
    
    //放在后面 会有异常 不起作用
//    [_NEW setBackgroundImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
//    [_HOT setBackgroundImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _requestSort == 0 ? self.addtimeListArr.count : self.hotListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == self.requestSort) {
        BaseModel *model = nil;
        model =  self.addtimeListArr[indexPath.row];
        BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
        [cell setDataWithModel:model];
        return cell;
    }else {
        BaseModel *model = nil;
        model =  self.hotListArr[indexPath.row];
        BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
        [cell setDataWithModel:model];
        return cell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc]init];
    if (_requestSort == 0) {
        ReadDetailModel *model = self.addtimeListArr[indexPath.row];
        infoVC.contentid = model.contentID;
        infoVC.detailModel = model;
    }else {
        ReadDetailModel *model = self.hotListArr[indexPath.row];
        infoVC.contentid = model.contentID;
        infoVC.detailModel = model;
    }
    
    [self.navigationController pushViewController:infoVC animated:YES];
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
