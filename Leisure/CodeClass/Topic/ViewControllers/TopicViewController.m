//
//  TopicViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "TopicViewController.h"
#import "TopicListModel.h"
#import "TopicTableViewCell.h"
#import "TopicInfoViewController.h"
#import "TopicNotPicViewCell.h"

@interface TopicViewController ()<UITableViewDataSource, UITableViewDelegate>

/**判断数据列表*/
@property (assign, nonatomic)NSInteger requestSort; //0 addtime  1 hot

//请求参数
/**请求开始位置 */
@property (assign, nonatomic)NSInteger startAddtime;
@property (assign, nonatomic)NSInteger startHot;
@property (assign, nonatomic)NSInteger limit;
@property (assign, nonatomic)BOOL isHot;
@property (assign, nonatomic)BOOL isAddtime;

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
/**最新数据源*/
@property (strong, nonatomic)NSMutableArray *addtimeListArr;
/**热门数据源*/
@property (strong, nonatomic)NSMutableArray *hotListArr;

/**UItableView*/
@property (strong, nonatomic)UITableView *tableView;
/**导航条按钮*/
@property (strong, nonatomic)UIButton *NEW;
@property (strong, nonatomic)UIButton *HOT;


/**根列表*/
@property (strong, nonatomic)UIScrollView *rootScrollView;
/**最新列表*/
@property (strong, nonatomic)UITableView *addTableView;
/**热门列表*/
@property (strong, nonatomic)UITableView *hotTableView;


@end

@implementation TopicViewController


#pragma mark  ---懒加载
- (NSMutableArray *)listArr{
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}
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

#pragma mark ---加载数据
- (void)reloadData:(NSString *)sort {
    //添加指示器
    [SVProgressHUD show];
    
    _limit = 10;
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    parDic[@"sort"] = sort;
    if ([sort isEqualToString:@"hot"]) {
        parDic[@"start"] = @(_startHot);
    }else {
        parDic[@"start"] = @(_startAddtime);
    }
    parDic[@"limit"] = @(_limit);
    [NetWorkRequesManager requestWithType:POST urlString:TOPICLIST_URL parDic:parDic finish:^(NSData *data) {
        if (_isAddtime == 0) {
            [self.addtimeListArr removeAllObjects];
        }
        if (_isHot == 0) {
            [self.hotListArr removeAllObjects];
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        QYLog(@"%@", dic);
        
        for (NSDictionary *listDic  in dic[@"data"][@"list"]) {
            TopicListModel *listModel = [[TopicListModel alloc]init];
            TopicCounterListModel *counterModel = [[TopicCounterListModel alloc]init];
            TopicUserInfoModel *userInfoModel = [[TopicUserInfoModel alloc]init];
            [listModel setValuesForKeysWithDictionary:listDic];
            [counterModel setValuesForKeysWithDictionary:listDic[@"counterList"]];
            [userInfoModel setValuesForKeysWithDictionary:listDic[@"userinfo"]];
            
            listModel.userinfo = userInfoModel;
            listModel.counterList = counterModel;
            
            if ([sort isEqualToString:@"hot"]) {
                [self.hotListArr addObject:listModel];
                QYLog(@"hot");
            }else {
                [self.addtimeListArr addObject:listModel];
                QYLog(@"addtime");
            }
            
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_requestSort == 0) {
                _isAddtime = 1;
               [self.addTableView reloadData];
                [self.addTableView.mj_header endRefreshing];
                [self.addTableView.mj_footer endRefreshing];
            }else {
                _isHot = 1;
                [self.hotTableView reloadData];
                [self.hotTableView.mj_header endRefreshing];
                [self.hotTableView.mj_footer endRefreshing];
            }
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
    //默认列表为addtime
    _requestSort = 0;
    
    //加载数据
//    [self reloadData:@"addtime"];
    
    //创建列表展示
    [self creatListTable];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    //使用第三方类库 实现刷新功能
    [self refreshHeader];
    
    // Do any additional setup after loading the view from its nib.
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
    [self.addTableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicTableViewCell class])];
    [self.addTableView registerNib:[UINib nibWithNibName:@"TopicNotPicViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicNotPicViewCell class])];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicTableViewCell class])];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"TopicNotPicViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicNotPicViewCell class])];
    
    [self.rootScrollView addSubview:self.addTableView];
    [self.rootScrollView addSubview:self.hotTableView];
    [self.view addSubview:self.rootScrollView];
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
    [self.addTableView.mj_header beginRefreshing];
    [self.hotTableView.mj_header beginRefreshing];
    [self.addTableView.mj_footer beginRefreshing];
    [self.hotTableView.mj_footer beginRefreshing];
    //默认显示
    [self loadNewAddtimeData];
    
}
- (void)loadNewAddtimeData {
    //隐藏上拉
    self.addTableView.mj_footer.hidden = YES;
    _startAddtime = 0;
    [self reloadData:@"addtime"];
}
- (void)loadNewHotData {
    //隐藏上拉
    self.addTableView.mj_footer.hidden = YES;
    _startHot = 0;
    [self reloadData:@"hot"];
}
- (void)loadMoreAddtimeData {
    //显示上拉
    self.addTableView.mj_footer.hidden = NO;
    _startAddtime += 10;
    [self reloadData:@"addtime"];
}
- (void)loadMoreHotData {
    //显示上拉
    self.addTableView.mj_footer.hidden = NO;
    _startHot += 10;
    [self reloadData:@"hot"];
    
}

#pragma mark ----自定义导航条按钮
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    
    _NEW= [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 90, 14, 15, 30)];
    _NEW.selected = YES;
    [_NEW setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_NEW addTarget:self action:@selector(NEWAction) forControlEvents:(UIControlEventTouchUpInside)];
    _NEW.selected = NO;
    [navigationBar addSubview:_NEW];
    
    _HOT = [[UIButton alloc] initWithFrame:CGRectMake(_NEW.frame.size.width + _NEW.frame.origin.x + 30, _NEW.frame.origin.y, _NEW.frame.size.width, _NEW.frame.size.height)];
    [_HOT setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    [_HOT addTarget:self action:@selector(HOTAction) forControlEvents:(UIControlEventTouchUpInside)];
    [navigationBar addSubview:_HOT];
    [self.view addSubview:navigationBar];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)HOTAction {
    [_NEW setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
    [_HOT setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
    
    CGPoint offset = CGPointMake(ScreenWidth, 0);
    self.rootScrollView.contentOffset = offset;
    _requestSort = 1;
    _HOT.selected = YES;
    _NEW.selected = NO;
    if (self.hotListArr.count != 0) {
        return;
    }
    [self reloadData:@"hot"];
    
    
}
- (void)NEWAction {
    [_NEW setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
    [_HOT setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
    
    CGPoint offset = CGPointMake(0, 0);
    self.rootScrollView.contentOffset = offset;
    _requestSort = 0;
    _HOT.selected = NO;
    _NEW.selected = YES;
    if (self.addtimeListArr.count != 0) {
        return;
    }
    [self reloadData:@"addtime"];
    
}


#pragma mark ----UITableViewDelegate/UITableDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_requestSort == 0) {
        return self.addtimeListArr.count;
    }else {
        return self.hotListArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_requestSort == 0) {
        TopicListModel *model = self.addtimeListArr[indexPath.row];
        if ([model.coverimg isEqualToString:@""]) {
            TopicNotPicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicNotPicViewCell class]) forIndexPath:indexPath];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicTableViewCell class]) forIndexPath:indexPath];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else {
        TopicListModel *model = self.hotListArr[indexPath.row];
        if ([model.coverimg isEqualToString:@""]) {
            TopicNotPicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicNotPicViewCell class]) forIndexPath:indexPath];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicTableViewCell class]) forIndexPath:indexPath];
            cell.model = model;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicInfoViewController *infoVC = [[TopicInfoViewController alloc]init];
    
    
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
