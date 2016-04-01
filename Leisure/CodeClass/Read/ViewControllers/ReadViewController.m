//
//  ReadViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadListModel.h"
#import "ReadCarouseModel.h"
#import "ReadListModelCell.h"
#import "FactoryCollectionViewCell.h"
#import "ReadDetailViewController.h"
#import <SDCycleScrollView.h>
#import "ReadCollectionHeaderView.h"
#import "ReadCollectionFootView.h"


@interface ReadViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, SDCycleScrollViewDelegate>

/**列表数据源*/
@property (strong, nonatomic)NSMutableArray *readListArr;
/**滚动视图数据源*/
@property (strong, nonatomic)NSMutableArray *carouseArr;

/**列表*/
@property (strong, nonatomic)UICollectionView *collction;
/**轮播图*/
@property (strong, nonatomic)SDCycleScrollView *scrollView;
/**轮播图片*/
@property (strong, nonatomic)NSMutableArray *imageArr;

/**头视图*/
@property (strong, nonatomic)ReadCollectionHeaderView *headerView;

@end

@implementation ReadViewController

#pragma mark ---懒加载
- (NSMutableArray *)readListArr{
    if (!_readListArr) {
        _readListArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _readListArr;
}
- (NSMutableArray *)carouseArr{
    if (!_carouseArr) {
        self.carouseArr = [NSMutableArray array];
    }
    return _carouseArr;
}


- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        self.imageArr = [NSMutableArray array];
    }
    return _imageArr;
}

#pragma mark ---加载数据
- (void)parseLoad {
    [NetWorkRequesManager requestWithType:GET urlString:READLIST_URL parDic:nil finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //列表数据
        for (NSDictionary *dic1  in [[dic objectForKey:@"data"] objectForKey:@"list"]) {
            ReadListModel *readModel = [[ReadListModel alloc]init];
            [readModel setValuesForKeysWithDictionary:dic1];
            [self.readListArr addObject:readModel];
            
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collction reloadData];
        });
        
        //轮播图数据
        for (NSDictionary *dic2 in dic[@"data"][@"carousel"]) {
            ReadCarouseModel *carouseModel = [[ReadCarouseModel alloc]init];
            [carouseModel setValuesForKeysWithDictionary:dic2];
            [self.carouseArr addObject:carouseModel];
            [self.imageArr addObject:carouseModel.img];
           
        }
        //回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collction reloadData];
            //创建滚动列表视图
            [self creatScrollView];
        });
        
    } error:^(NSError *error) {
        NSLog(@"error = %@", error);
    }];
}

#pragma  mark  ---创建列表显示

//利用第三方类库SDCyclScrollView创建轮播图
- (void)creatScrollView{
    
    SDCycleScrollView *scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 44, ScreenWidth, 200) shouldInfiniteLoop:YES imageNamesGroup:self.imageArr];
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
    scrollView.delegate = self;
    [_headerView addSubview:scrollView];
}

//创建列表显示的collectionView
- (void)creatListView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //设置行直接的最小间隔
    layout.minimumInteritemSpacing = 2;
    //设置列之间的最小间隔
    layout.minimumLineSpacing = 2;
    //设置item的大小
    CGFloat layoutW = (ScreenWidth - 30 ) / 3;
    CGFloat layoutH = layoutW;
    layout.itemSize = CGSizeMake(layoutW, layoutH);
    //滚动方向
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置分区上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(0, 240);
    layout.footerReferenceSize = CGSizeMake(0,layoutH);
    
    //去除顶端空白区域(自动调整滚动视图)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.collction = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 22, ScreenWidth, ScreenHeight - 22) collectionViewLayout:layout];
    
    self.collction.dataSource = self;
    self.collction.delegate = self;
    self.collction.backgroundColor = [UIColor clearColor];
    
    //注册cell,头视图，尾视图
    [self.collction registerNib:[UINib nibWithNibName:@"ReadListModelCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ReadListModel class])];
    [self.collction registerClass:[ReadCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ReadCollectionHeaderView class])];
    [self.collction registerClass:[ReadCollectionFootView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ReadCollectionFootView class])];

    //添加子视图
    [self.view addSubview:self.collction];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建列表视图
    [self creatListView];
    
    //加载数据
    [self parseLoad];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark  ----Collction代理方法
//item的数量
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.readListArr.count;
}

//设置item的显示内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadListModel *ReadListModel =self.readListArr[indexPath.row];
    
    BaseCollectionViewCell *cell = [FactoryCollectionViewCell creatCollectionViewCell:ReadListModel collection:collectionView indexPath:indexPath];
    
    [cell setDataWithModel:ReadListModel];
    
    return cell;
}

//点击item的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"1111");
    ReadDetailViewController *detailVC = [[ReadDetailViewController alloc]init];
    ReadListModel *model = self.readListArr[indexPath.row];
    detailVC.typeID = model.type;
    [self.navigationController pushViewController:detailVC animated:YES];
}
//表视图 、 尾视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([ReadCollectionHeaderView class]) forIndexPath:indexPath];
        [self creatScrollView];
        return _headerView;
    }else {
        ReadCollectionFootView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([ReadCollectionFootView class]) forIndexPath:indexPath];
        return footView;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
