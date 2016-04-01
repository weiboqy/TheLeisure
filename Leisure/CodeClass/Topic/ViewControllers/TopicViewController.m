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
#import "TopicHeaderView.h"
#import "TopicInfoViewController.h"

@interface TopicViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (assign, nonatomic)NSInteger start;
@property (assign, nonatomic)NSInteger limit;

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *listArr;

/**UItableView*/
@property (strong, nonatomic)UITableView *tableView;



@end

@implementation TopicViewController

#pragma mark  ---懒加载
- (NSMutableArray *)listArr{
    if (!_listArr) {
        self.listArr = [NSMutableArray array];
    }
    return _listArr;
}


#pragma mark ---加载数据
- (void)reloadData:(NSString *)sort {
    [NetWorkRequesManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(_start), @"limit":@(_limit)} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
        for (NSDictionary *listDic  in dic[@"data"][@"list"]) {
            TopicListModel *listModel = [[TopicListModel alloc]init];
            TopicCounterListModel *counterModel = [[TopicCounterListModel alloc]init];
            TopicUserInfoModel *userInfoModel = [[TopicUserInfoModel alloc]init];
            
            [listModel setValuesForKeysWithDictionary:listDic];
            [counterModel setValuesForKeysWithDictionary:listDic[@"counterList"]];
            [userInfoModel setValuesForKeysWithDictionary:listDic[@"userinfo"]];
            
            listModel.userinfo = userInfoModel;
            listModel.counterList = counterModel;
            
            [self.listArr addObject:listModel];
        }
        
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)creatTableView {
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //tableView头视图
    TopicHeaderView *headerView = [[TopicHeaderView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 55, 150, 30)];
    self.tableView.tableHeaderView = headerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TopicTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TopicTableViewCell class])];
    [self.tableView registerClass:[TopicHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([TopicHeaderView class])];
    
    
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self reloadData:@"hot"];
    
    [self creatTableView];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----UITableViewDelegate/UITableDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TopicTableViewCell class]) forIndexPath:indexPath];
    TopicListModel *model = self.listArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicInfoViewController *infoVC = [[TopicInfoViewController alloc]init];
    TopicListModel *model = self.listArr[indexPath.row];
    infoVC.model = model;
    [self.navigationController pushViewController:infoVC animated:YES];
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
