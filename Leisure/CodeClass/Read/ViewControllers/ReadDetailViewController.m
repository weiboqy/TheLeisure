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


@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate>



/**请求数据的类型*/  //0最新 1热门
@property (assign, nonatomic)NSInteger requestSort;

/**请求开始位置 */
@property (assign, nonatomic)NSInteger start;
/**每次请求的数据条数*/
@property (assign, nonatomic)NSInteger limit;
/**热门数据源*/
@property (strong, nonatomic)NSMutableArray *hotListArr;
/**最新数据源*/
@property (strong, nonatomic)NSMutableArray *addtimeListArr;

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
    [NetWorkRequesManager requestWithType:POST urlString:READDETAILLIST_URL parDic:@{@"sort" : sort, @"start" : @(_start), @"limit" : @(_limit), @"typeid" : _typeID} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@", dic);
        
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
            UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            
            [tableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
                [self.view addSubview:tableView];
        });
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestSort = 0;
    [self requestDataWithSort:@"addtime"];
    
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _requestSort == 0 ? self.addtimeListArr.count : self.hotListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseModel *model = nil;
    model = (_requestSort == 0) ? self.addtimeListArr[indexPath.row] : self.hotListArr[indexPath.row];
    BaseTableViewCell *cell = [FactoryTableViewCell creatTableViewCell:model tableView:tableView indexPath:indexPath];
    [cell setDataWithModel:model];
    return cell;
    
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
