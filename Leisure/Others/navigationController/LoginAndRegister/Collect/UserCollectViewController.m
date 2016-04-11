//
//  UserCollectViewController.m
//  Leisure
//
//  Created by lanou on 16/4/11.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "UserCollectViewController.h"
#import "ReadDetailListModelCell.h"
#import "ReadDetailDB.h"
#import "FactoryTableViewCell.h"
#import "ReadInfoViewController.h"

@interface UserCollectViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *dataArr;

@end

@implementation UserCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadDetailListModelCell class]) bundle:nil] forCellReuseIdentifier:@"ReadDetailModel"];
    
    [self findDB];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----自定义导航条按钮
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.titleLabel.text = @"收藏";
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}


//查询数据
- (void)findDB {
    ReadDetailDB *db = [[ReadDetailDB alloc]init];
    self.dataArr = [db findWithUserID:[UserInfoManager getUserID]];
    QYLog(@"dataArr = %@", self.dataArr);
    [_tableView reloadData];
}


#pragma mark ---UITableViewDelegate \ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 210;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailModel *model = self.dataArr[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadDetailModel *model = self.dataArr[indexPath.row];
    ReadInfoViewController *infoVC = [[ReadInfoViewController alloc]init];
    infoVC.contentid = model.contentID;
    infoVC.detailModel = model;
    QYLog(@"点击到了");
    [self presentViewController:infoVC animated:NO completion:nil];
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
