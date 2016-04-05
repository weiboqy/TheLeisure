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
@property (assign, nonatomic)NSInteger start;
@property (assign, nonatomic)NSInteger limit;

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
    _limit = 10;
    [NetWorkRequesManager requestWithType:POST urlString:TOPICLIST_URL parDic:@{@"sort":sort, @"start":@(_start), @"limit":@(_limit)} finish:^(NSData *data) {
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
               [self.addTableView reloadData];
            }else {
                [self.hotTableView reloadData];
            }
//            [self.addTableView reloadData];
//            [self.hotTableView reloadData];
        });
    } error:^(NSError *error) {
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    //默认列表为addtime
    _requestSort = 0;
    
    //加载数据
    [self reloadData:@"addtime"];
    
    //创建列表展示
    [self creatListTable];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    
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

#pragma mark  ----UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    int number = (int)(scrollView.contentOffset.x / ScreenWidth);
//    if (number == 0) {
//        self.requestSort = 0;
//        if (self.addtimeListArr.count != 0) {
//            return;
//        }
//        _NEW.selected = YES;
//        _HOT.selected = NO;
//        [_NEW setImage:[UIImage imageNamed:@"NEW1"] forState:UIControlStateNormal];
//        [_HOT setImage:[UIImage imageNamed:@"HOT2"] forState:UIControlStateNormal];
//        [self reloadData:@"addtime"];
//    }else if(number == 1){
//        self.requestSort = 1;
//        if (self.hotListArr.count != 0) {
//            return;
//        }
//        _HOT.selected = YES;
//        _NEW.selected = NO;
//        [_HOT setImage:[UIImage imageNamed:@"HOT1"] forState:UIControlStateNormal];
//        [_NEW setImage:[UIImage imageNamed:@"NEW2"] forState:UIControlStateNormal];
//        [self reloadData:@"hot"];
//    }
//}

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
