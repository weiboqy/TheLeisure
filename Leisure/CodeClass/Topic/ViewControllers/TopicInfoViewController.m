//
//  TopicInfoViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "TopicInfoViewController.h"


@interface TopicInfoViewController ()

@property (strong, nonatomic)UIWebView *webView;

@property (strong, nonatomic)NSMutableArray *listArr;

@end

@implementation TopicInfoViewController

- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArr;
}

- (void)loadNewData {
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    parDic[@"contentid"] = _contentid;
    parDic[@"auth"] = @"XMdnEiW0m3qxDCMVzGMTikDJxQ8aoNbKF8W1rUDRicWP23tB NQhpd6fw";
    parDic[@"deviceid"] = @"63A94D37-33F9-40FF-9EBB-481182338873";
    
    [SVProgressHUD show];
   [NetWorkRequesManager requestWithType:POST urlString:TOPICINFO_URL parDic:parDic finish:^(NSData *data) {
       NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//       for (NSDictionary *dic in dataDic[@"data"][@"postsinfo"]) {
//           TopicDetailModel *model = [[TopicDetailModel alloc]init];
//           [model setValuesForKeysWithDictionary:dic];
//           [self.listArr addObject:model];
//           QYLog(@"url ===%@", model.html);
//       }
       NSMutableDictionary *dic  = dataDic[@"data"][@"postsinfo"];
       NSString *url = dic[@"url"];
//       [self.listArr addObject:url];
       NSLog(@"list = %@", url);

       QYLog(@"%@", dataDic);
       
       NSDictionary *postsDict = dataDic[@"data"][@"postsinfo"];
       TopicDetailModel *model = [[TopicDetailModel alloc] init];
       [model setValuesForKeysWithDictionary:postsDict];
       // 设置HTML图片尺寸;
       NSString *str = [NSString stringWithFormat:@"<head><style>img{width:340px !important;}</style></head>%@",model.html];
       str = [NSString stringWithFormat:@"<div id=\"webview_content_wrapper\">%@</div>",str];
       [_webView loadHTMLString:str baseURL:nil];
       
       
       dispatch_async(dispatch_get_main_queue(), ^{
           //刷新webView
           [_webView reload];
           
           //创建列表展示
//           [self createListView];
       });
       [SVProgressHUD dismiss];
   } error:^(NSError *error) {
       [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
   }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    [self loadNewData];
   
    self.navigationItem.rightBarButtonItems = @[
                                                [UIBarButtonItem itemWithImage:@"其他" selectImage:nil target:self action:@selector(othersClick)],
                                                [UIBarButtonItem itemWithImage:@"喜欢123" selectImage:nil target:self action:@selector(likeClick)],
                                                [UIBarButtonItem itemWithImage:@"评论12" selectImage:nil target:self action:@selector(commentClick)]
                                                ];
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark  ----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark  ----状态栏按钮实现
- (void)othersClick {
    QYLogFunc;
}
- (void)likeClick {
    QYLogFunc;
}
- (void)commentClick {
    QYLogFunc;
}

- (void)createListView {
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
//    tTopicDetailModel *model = self.listArr[_selecteIndex];
//    NSString *url = model.html;
    NSString *url = self.listArr[0];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
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
