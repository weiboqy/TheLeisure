//
//  RadioPlayViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioPlayViewController.h"
#import "RadioPlayTableViewCell.h"
#import "RadioDetailListModel.h"
#import "RadioCover.h"
#import "RadioPlayControlView.h"



@interface RadioPlayViewController ()<UITableViewDataSource, UITableViewDelegate>

/**根视图*/
@property (strong, nonatomic)UIScrollView *rootScrollView;

/**上一首*/
@property (strong, nonatomic)UIButton *aboveButton;
/**播放/暂停*/
@property (strong, nonatomic)UIButton *playButton;
/**下一首*/
@property (strong, nonatomic)UIButton *belowButton;

@property (strong, nonatomic)UITableView *tableView;
//封面
@property (strong, nonatomic)RadioCover *coverView;
//详情
@property (strong, nonatomic)UIWebView *webView;
@property (strong, nonatomic)RadioPlayControlView *controlView;


@end

@implementation RadioPlayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSMutableArray *)playListArr {
    if (_playListArr == nil) {
        _playListArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _playListArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //加载数据
    //不过可以通过上一个界面传来模型数组 也没必要在重新加载一次数据
//    [self reloadData];  //.放弃
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    //添加毛玻璃的效果
    [self addGlassImage];
    
    //创建列表
    [self createListView];
    
    //创建播放器
    [self createPlayVideo];
    
    //创建详情列表
    [self createDetailView];
    
//    [self createUser];
    
    //监听全局的播放过程，如果结束就执行方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish:) name:@"playFinish" object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark  ---创建播放器-

- (void) createPlayVideo {
    //创建播放器管理器对象
    PlayerManager *manager = [PlayerManager defaultManager];
    manager.playIndex =  _seleteIndex;
    
    NSMutableArray *playListArr = [NSMutableArray array];
    for (RadioDetailListModel *model in self.playListArr) {
        [playListArr addObject:model.musicUrl];
    }
    //传入播放数组中
    [manager setMusicArray:playListArr];
    
    //播放
    [manager play];
    
    //创建计时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(playing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    //进度条添加方法
    [_coverView.sliderView addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    
}
//进度条  更改显示 刷新
- (void)changeValue:(id)sender{
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager seekToNewTime:_coverView.sliderView.value];
    //立即播放
    [manager play];
    if (_coverView.sliderView.value == manager.totalTime) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [self refreshUIWithIndex:manager.playIndex];
       });
    }
}

- (void)playFinish:(NSNotification *)notification {
    QYLog(@"%@", notification.name);
    [self refreshUIWithIndex:[PlayerManager defaultManager].playIndex];
}
#pragma mark  ---计时器方法实现
- (void)playing {
    PlayerManager *manager = [PlayerManager defaultManager];
    _coverView.sliderView.minimumValue = 0;
    _coverView.sliderView.maximumValue = manager.totalTime;
    _coverView.sliderView.value = manager.currentTime;
    
    //剩余时间显示
    _coverView.timeLabel.text = [NSString stringWithFormat:@"%02lld:%02lld", (int64_t)(manager.totalTime - manager.currentTime) / 60, (int64_t)(manager.totalTime - manager.currentTime) % 60];
    //如果当前播放时间与总时长相等，就调用播放结束的方法
    if (manager.currentTime == manager.totalTime && manager.totalTime != 0) {
        [manager playerDidFinish];
    }
}

- (void)createListView {
//    self.automaticallyAdjustsScrollViewInsets = YES;
    //根视图
    _rootScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 128)];
    _rootScrollView.contentSize = CGSizeMake(3 * ScreenWidth, 0);
    _rootScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    _rootScrollView.pagingEnabled = YES;
    _rootScrollView.bounces = YES;
    [self.view addSubview:_rootScrollView];

    
    //分割线
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 55, ScreenWidth, 2)];
    lineView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:lineView];
    
    //上一首
    _aboveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _aboveButton.frame = CGRectMake(60, ScreenHeight - 45, 30, 30);
    [_aboveButton setBackgroundImage:[UIImage imageNamed:@"上一首"] forState:UIControlStateNormal];
    _aboveButton.layer.cornerRadius = 15;
    _aboveButton.layer.masksToBounds = YES;
    [_aboveButton addTarget:self action:@selector(aboveClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_aboveButton];
    
    //播放/暂停
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.frame = CGRectMake(CGRectGetMaxX(_aboveButton.frame) + 77, CGRectGetMaxY(_aboveButton.frame) - 30 - 5, 40, 40);
    [_playButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    _playButton.tag = 3001;
    _playButton.layer.cornerRadius = 20;
    _playButton.layer.masksToBounds = YES;
    [_playButton addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
    
    //下一首
    _belowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _belowButton.frame = CGRectMake(CGRectGetMaxX(_playButton.frame) + 77, CGRectGetMaxY(_playButton.frame) - 40 + 5, 30, 30);
    [_belowButton setBackgroundImage:[UIImage imageNamed:@"下一首"] forState:UIControlStateNormal];
    _belowButton.layer.cornerRadius = 15;
    _belowButton.layer.masksToBounds = YES;
    [_belowButton addTarget:self action:@selector(belowClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_belowButton];
    
    //显示第一页的tableview
    [self createTableView];
    
    //封面
    [self createCoverView];
}

//创建UITableView
- (void)createTableView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 120) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"RadioPlayTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RadioPlayTableViewCell class])];
    
    //默认选中位置
    QYLog(@"seleteIndex = %ld", _seleteIndex);
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:_seleteIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self.rootScrollView addSubview:self.tableView];
}


//封面
- (void)createCoverView {

    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([RadioCover class]) owner:nil options:nil];
    _coverView = [views lastObject];
    _coverView.backgroundColor = [UIColor clearColor];
    
    _coverView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight  - 64);
    [_coverView setListModel:_playListArr[_seleteIndex]];
    [_rootScrollView addSubview:_coverView];
}

#pragma mark  ----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark  ---毛玻璃效果
- (void)addGlassImage {
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    image.image = [UIImage imageNamed:@"毛玻璃"];
    [self.view addSubview:image];
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    blurView.frame = CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64);
    [self.view addSubview:blurView];
}




#pragma mark  ----上一首、暂停/播放、下一首
- (void)aboveClick:(id)sender {
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager lastMusic];
    
    if (_seleteIndex == 0) {
        return;
    }else {
        [self refreshUIWithIndex:_seleteIndex - 1];
    }
}

- (void)playClick:(id)sender {
    PlayerManager *manager = [PlayerManager defaultManager];
    UIButton *radioButton = (UIButton *)sender;
    if (manager.playerState == playerStatePlay) {
        [manager pause];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    }else {
        [manager play];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
    }
}

- (void)belowClick:(id)sender {
    PlayerManager *manager = [PlayerManager defaultManager];
    [manager nextMusic];
   
    if (self.playListArr.count ==  _seleteIndex) {
        return;
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self refreshUIWithIndex:_seleteIndex + 1];
        });
    }
    
}


#pragma mark  ------detail展示
- (void)createDetailView {
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(2 * ScreenWidth, 0, ScreenWidth, ScreenHeight - 64 - 64)];
    _webView.backgroundColor = [UIColor clearColor];
    RadioDetailListModel *detailModel = _playListArr[_seleteIndex];
    NSString *url = detailModel.playInfo.webview_url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
    [self.rootScrollView addSubview:_webView];
}

#pragma mark  ----刷新UI,数据刷新
- (void)refreshUIWithIndex:(NSInteger)index {
    RadioDetailListModel *detailModel = _playListArr[index];
    
    //webView
    NSString *url = detailModel.playInfo.webview_url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:request];
    
    //coverView
    [_coverView setListModel:detailModel];
    
    _seleteIndex = index;
}


#pragma mark ----播放结束时





#pragma mark  ---UITableViewDelegate \ UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioPlayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RadioPlayTableViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selected = UITableViewCellSelectionStyleNone;
    RadioDetailListModel *playInfo = [self.playListArr objectAtIndex:indexPath.row];
    cell.playInfo = playInfo;
    return cell;
}
//点击列表 点击某一首播放
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //通过动画实现过渡效果
    //嗯 不会那么急促显示
    [UIView animateWithDuration:.4 animations:^{
       _rootScrollView.contentOffset = CGPointMake(ScreenWidth, 0);
    }];
    _seleteIndex = indexPath.row;
    [self createPlayVideo];
    
    [self refreshUIWithIndex:indexPath.row];

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
