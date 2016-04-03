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


@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;
/**头视图图片数据源*/
@property (strong, nonatomic)NSMutableArray *headerArr;

/**列表*/
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIView *headerView;
@end

@implementation RadioDetailViewController

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
//        for (RadioUserInfoModel *model in dataDic[@"data"][@"radoInfo"][@"userinfo"]) {
//            [self.headerArr addObject:model];
//            QYLog(@"==%@", self.headerArr);
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        //获取头视图的信息
//        for (NSDictionary *dic in dataDic[@"data"][@"radioInfo"]) {
//            RadioInfoModel *infoModel = [[RadioInfoModel alloc]init];
//            RadioUserInfoModel *userInfoModel = [[RadioUserInfoModel alloc]init];
//            [infoModel setValuesForKeysWithDictionary:dic];
//            [userInfoModel setValuesForKeysWithDictionary:dic[@"userinfo"]];
//            infoModel.userInfoModel = userInfoModel;
//            [self.headerArr addObject:infoModel];
//            QYLog(@"title  = %@", infoModel.title);
//        }
        
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadData];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [self creatListView];
    // Do any additional setup after loading the view from its nib.
}
- (void)creatListView {
    self.headerView = [[UIView alloc]init];
    self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 260);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.coverimg]] placeholderImage:PLACEHOLDERIMAGE];
    [self.headerView addSubview:imageView];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 170, 30, 30)];
    [iconImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.model.userinfo.icon]] placeholderImage:PLACEHOLDERIMAGE];
    iconImage.layer.cornerRadius = 15;
    iconImage.layer.masksToBounds = YES;
    [self.headerView addSubview:iconImage];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 180, 100, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@",self.model.userinfo.uname];
    nameLabel.font = [UIFont systemFontOfSize:13];
    nameLabel.textColor = [UIColor blueColor];
    [self.headerView addSubview:nameLabel];
    
    UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 200, 20)];
    descLabel.text = [NSString stringWithFormat:@"%@", self.model.desc];
    [self.headerView addSubview:descLabel];
    
    UIImageView *imageViewVV = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 120, 175, 10, 10)];
    imageViewVV.image = [UIImage imageNamed:@"u58.png"];
    [self.headerView addSubview:imageViewVV];
    
    UILabel *count = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 170, 100, 20)];
    count.text = [NSString stringWithFormat:@"%@", self.model.count];
    count.font = [UIFont systemFontOfSize:12];
    [self.headerView addSubview:count];
    
    self.tableView  = [[UITableView alloc]initWithFrame:[[UIScreen mainScreen]bounds] style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
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
