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
#import "RadioHeader.h"
#import "RadioTableViewCell.h"
#import "RadioCollectionViewCell.h"



@interface RadioViewController ()<SDCycleScrollViewDelegate, UITableViewDataSource, UITableViewDelegate>
/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
/**轮播图数据源*/
@property (strong, nonatomic)NSMutableArray *carouselArr;
/**热门列表数据源*/
@property (strong, nonatomic)NSMutableArray *hotArr;


/**轮播图图片*/
@property (strong, nonatomic)NSMutableArray *imageArr;  //之后删除


/**start*/
@property (assign, nonatomic)NSInteger start;
/**limit*/
@property (assign, nonatomic)NSInteger limit;

/** 列表展示 */
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)RadioHeader *header;
@property (strong, nonatomic)UICollectionView *collection;


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

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _imageArr;
}
//首次请求
- (void)requestFirstData {
    [NetWorkRequesManager requestWithType:POST urlString:RADIOLIST_URL parDic:@{} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
//           QYLog(@"%@", dic);
        
        //获取所以电台列表信息
        for (NSDictionary *listDic in dic[@"data"][@"allList"]) {
            RadioListModel *listModel = [[RadioListModel alloc]init];
            RadioUserInfoModel *userInfoModel = [[RadioUserInfoModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:listDic];
            [userInfoModel setValuesForKeysWithDictionary:listDic[@"userinfo"]];
            [self.imageArr addObject:listModel.coverimg];
            listModel.userinfo = userInfoModel;
            
            [self.listArr addObject:listModel];
            
        }
        //获取轮播图数据
        NSArray *carouselArr = dic[@"data"][@"carousel"];
        for (NSDictionary *carouselDic in carouselArr) {
            RadioCarouseModel *carouseModel = [[RadioCarouseModel alloc]init];
            [carouseModel setValuesForKeysWithDictionary:carouselDic];
            [self.imageArr addObject:carouseModel.img];
            QYLog(@"%@", carouseModel.img);
            [self.carouselArr addObject:carouseModel];
        }
        
        //获取热门电台数据
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
            [self.tableView reloadData];
            [self.collection reloadData];
            [self creatScrollViewView];
            [self setupHeadViewBtnByBackGroundImage];
        });
        
    } error:^(NSError *error) {
        
    }];
}

//上拉刷新请求
- (void)requestRefresh {
    [NetWorkRequesManager requestWithType:POST urlString:RADIOLISTMORE_URL parDic:@{@"start" : @(_start), @"limit" : @(_limit)} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        
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
          
            [self.tableView reloadData];
            [self.collection reloadData];
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //首次请求 列表数据
    [self requestFirstData];
    //上拉刷新数据
    [self requestRefresh];
    
    //展示列表
    [self creatListView];
    
    self.navigationController.navigationBar.translucent = NO;
}

#pragma  mark  ---创建列表显示

- (void)creatListView {
    // 初始化headView
    _header = [[RadioHeader alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, 300)];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioTableViewCell class])];
    self.tableView.tableHeaderView = _header;
    [self.view addSubview:self.tableView];
    [self creatScrollViewView];
}
#pragma mark -tableView的headview中的按钮实现

//  给表头按钮添加背景图片

- (void)setupHeadViewBtnByBackGroundImage {
    [self setupBtn:_header.leftBtn tag:101 index:0];
    [self setupBtn:_header.midBtn tag:102 index:1];
    [self setupBtn:_header.rightBtn tag:103 index:2];
}

- (void)setupBtn:(UIButton *)button tag:(int)tag index:(int)index {
    RadioListModel *model = self.hotArr[index];
    button.tag = tag;
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    [button sd_setBackgroundImageWithURL:[NSURL URLWithString:model.coverimg] forState:UIControlStateNormal placeholderImage:PLACEHOLDERIMAGE];
}


// 表头按钮的点击方法

- (void)btnClick:(UIButton *)button {
    int index = (int)button.tag - 101;
    RadioListModel *model = self.hotArr[index];
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
    detailVC.radioid = model.radioid;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//利用第三方类库SDCyclScrollView创建轮播图

- (void)creatScrollViewView{
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 150) imageURLStringsGroup:_imageArr];
    // 分页控件的位置
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    // 翻页样式
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    // 自动翻滚时间
    scrollView.autoScrollTimeInterval = 5;
    scrollView.delegate = self;
    [_header.scrollView addSubview:scrollView];
}

//  第三方自动轮播图代理方法，点击选中事件

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc] init];
    RadioCarouseModel *model = self.carouselArr[index];
    detailVC.radioid = [model.url substringFromIndex:12];
    [self.navigationController pushViewController:detailVC animated:YES];
}



#pragma mark  --UITableViewDelegate \ UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RadioTableViewCell class]) forIndexPath:indexPath];
    RadioListModel *model = self.listArr[indexPath.row];
    [cell setDataWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailViewController *detailVC = [[RadioDetailViewController alloc]init];
    RadioListModel *model = self.listArr[indexPath.row];
    detailVC.radioid = model.radioid;
    [self.navigationController pushViewController:detailVC animated:YES];
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
