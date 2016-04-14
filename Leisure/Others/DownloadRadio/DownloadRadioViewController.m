//
//  DownloadRadioViewController.m
//  Leisure
//
//  Created by lanou on 16/4/13.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "DownloadRadioViewController.h"
#import "RadioDetailTableViewCell.h"
#import "RadioDetailListDB.h"
#import "Download.h"
#import "RadioDetailListModel.h"
#import "RadioPlayViewController.h"

@interface DownloadRadioViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic)NSArray *dataArr ;

@end

@implementation DownloadRadioViewController

static NSString * const TableCellID  = @"radioDetailCell";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义导航条
    [self addCustomNavigationBar];
    
    //tableView配置
    [self setupSubViews];
    
    //获取数据
    [self findData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark ----自定义导航条按钮
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    navigationBar.titleLabel.text = @"下载管理";
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupSubViews {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RadioDetailTableViewCell class]) bundle:nil] forCellReuseIdentifier:TableCellID];
}

- (void)findData {
    RadioDetailListDB *db = [[RadioDetailListDB alloc] init];
    
    self.dataArr = [db findWithUserID:[UserInfoManager getUserID]];
    QYLog(@"data Arr = %@", self.dataArr);
}
#pragma  mark  ----UITableViewDelegate \ UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 96;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellID forIndexPath:indexPath];
    RadioDetailListModel *model = self.dataArr[indexPath.row];
    // 将播放按钮变成删除按钮
    [cell.actionButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    
    // 删除按钮的实现
    [cell.actionButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
//    QYLog( @"title = %@", model.title);
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayViewController *playVC = [[RadioPlayViewController alloc]init];
    playVC.seleteIndex = indexPath.row;
    playVC.playListArr = (NSMutableArray *)self.dataArr;
    [self presentViewController:playVC animated:YES completion:nil];
}

- (void)deleteClick {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:@"你确定要删除吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        RadioDetailListDB *db = [[RadioDetailListDB alloc]init];
        RadioDetailListModel *model = self.dataArr[self.tableView.indexPathForSelectedRow.row];
        [db deleteDetailWithTitle:model.title];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:cancel];
    [alertController addAction:confirm];
    [self presentViewController:alertController animated:YES completion:nil];
    // 刷新tableView
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
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
