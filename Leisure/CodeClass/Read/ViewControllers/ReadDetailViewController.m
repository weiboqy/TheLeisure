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


@interface ReadDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>



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

/**列表*/
@property (strong, nonatomic)UIScrollView *rootScrollView;
@property (strong, nonatomic)UITableView *addTableView;
@property (strong, nonatomic)UITableView *hotTableView;

@property (strong, nonatomic)UISegmentedControl *segment;

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
                [self.hotTableView reloadData];
            }else {
                [self.hotTableView reloadData];
                
            }
        });
    } error:^(NSError *error) {
        
    }];
}


- (void)creatListTable {
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, ScreenHeight - 80)];
    self.rootScrollView.contentSize = CGSizeMake(ScreenWidth * 2, ScreenHeight);
    self.rootScrollView.contentOffset = CGPointMake(0, 0);
    self.rootScrollView.delegate = self;
    self.rootScrollView.pagingEnabled = YES;
    self.rootScrollView.bounces = NO;
    self.rootScrollView.showsVerticalScrollIndicator = NO;
    
    self.addTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.addTableView.delegate = self;
    self.addTableView.dataSource = self;
    
    self.hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    self.hotTableView.delegate = self;
    self.hotTableView.dataSource = self;
    
    [self.addTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    [self.hotTableView registerNib:[UINib nibWithNibName:@"ReadDetailListModelCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([ReadDetailModel class])];
    
    [self.rootScrollView addSubview:self.addTableView];
    [self.rootScrollView addSubview:self.hotTableView];
    [self.view addSubview:self.rootScrollView];
}

- (void)segmentValueChanged:(id)sender {
    UISegmentedControl *segment = sender;
    CGPoint offset = CGPointMake(segment.selectedSegmentIndex * 2 * ScreenWidth, 0);
    self.rootScrollView.contentOffset = offset;
    if (segment.selectedSegmentIndex == 0) {
        self.requestSort = 0;
        if (self.addtimeListArr.count != 0) {
            return;
        }
        [self requestDataWithSort:@"addtime"];
    }else {
        self.requestSort = 1;
        if (self.hotListArr.count != 0) {
            return;
        }
        [self requestDataWithSort:@"hot"];
    }
}

#pragma mark  ----UIScrollViewDelegate 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
        int number = (int)(scrollView.contentOffset.x / ScreenWidth);
        if (number == 0) {
            self.requestSort = 0;
            if (self.addtimeListArr.count != 0) {
                return;
            }
            self.segment.selectedSegmentIndex = 0;
            [self requestDataWithSort:@"addtime"];
        }else if(number == 1){
            self.requestSort = 1;
            if (self.hotListArr.count != 0) {
                return;
            }
            self.segment.selectedSegmentIndex = 1;
            [self requestDataWithSort:@"hot"];
        }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestSort = 0;
    
    [self requestDataWithSort:@"addtime"];
   
    [self creatListTable];
    
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"最新", @"热门"]];
    self.segment.frame = CGRectMake(ScreenWidth / 2 -80, 0, 150, 30);
    self.segment.selectedSegmentIndex = 0;
    [self.segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segment];
    
    //以导航条左下角为原点
    self.navigationController.navigationBar.translucent = NO;
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
