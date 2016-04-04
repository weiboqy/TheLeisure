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


@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
/**头视图图片数据源*/
@property (strong, nonatomic)NSMutableArray *headerArr;

/**列表*/
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)RadioDetailHeader *headerView;

@end

@implementation RadioDetailViewController

#pragma mark  ----懒加载
- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArr;
}
- (NSMutableArray *)headerArr {
    if (_headerArr == nil) {
        _headerArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _headerArr;
}

- (void)reloadData{
    [NetWorkRequesManager requestWithType:POST urlString:RADIODETAILLIST_URL parDic:@{@"radioid" : _radioid} finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        QYLog(@"===%@", dataDic);
        //获取列表信息
        for (NSDictionary *listDic in dataDic[@"data"][@"list"]) {
            RadioDetailListModel *listModel = [[RadioDetailListModel alloc] init];
            [listModel setValuesForKeysWithDictionary:listDic];
            [self.listArr addObject:listModel];
            QYLog(@"%@", self.listArr);
        };
        
        //获取头视图信息
        NSDictionary *headDict = dataDic[@"data"][@"radioInfo"];
        RadioInfoModel *model =[[RadioInfoModel alloc] init];
        [model setValuesForKeysWithDictionary:headDict];
        RadioUserInfoModel *userModel = [[RadioUserInfoModel alloc]init];
        NSDictionary *userDic = headDict[@"userinfo"];
        [userModel setValuesForKeysWithDictionary:userDic];
        model.userInfoModel = userModel;
        QYLog(@"==== %@, uname = %@", model.desc, userModel.uname);
        dispatch_async(dispatch_get_main_queue(), ^{
            //给头视图内部控件赋值
            self.headerView.model = model;
            //刷新tableview
            [self.tableView reloadData];
            
        });
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    [self reloadData];
    
    //已导航条左下角为原点
    
    self.navigationController.navigationBar.translucent = YES;
    
    //创建视图列表
    [self creatListView];
    
    //自定义导航条
    [self addCustomNavigationBar];
    // Do any additional setup after loading the view from its nib.
}
//自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [bar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    bar.titleLabel.text = _headerView.model.title;
    
    [self.view addSubview:bar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatListView {
    //初始化头视图
    self.headerView = [[RadioDetailHeader alloc]init];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 260);
    
    self.tableView  = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioDetailTableViewCell class])];
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
    [cell setDataWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc]init];
    [self.navigationController pushViewController:playVC animated:YES];
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
