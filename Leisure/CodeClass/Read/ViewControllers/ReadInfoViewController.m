//
//  ReadInfoViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadInfoViewController.h"
#import "ReadInfoModel.h"
#import "ReadCommentViewController.h"

@interface ReadInfoViewController ()

/** 列表数据 */
@property (strong, nonatomic)NSMutableArray *listArr;

@property (strong, nonatomic)UIWebView *webView;

@end

@implementation ReadInfoViewController

- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArr;
}

#pragma mark  ---加载数据
- (void)requestData {
    //添加指示器
    [SVProgressHUD show];
    //解析数据
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    parDic[@"auth"] = @"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo";
    parDic[@"contentid"] = _contentid;
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    parDic[@"version"] = @"3.0.6";
    [NetWorkRequesManager requestWithType:POST urlString:READCONTENT_URL parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        QYLog(@"%@",dataDic);
        ReadInfoModel *infoModel = [[ReadInfoModel alloc]init];
        ReadInfoCounter *counterModel = [[ReadInfoCounter alloc]init];
        ReadShareInfo *shareInfoModel = [[ReadShareInfo alloc] init];
        
        [infoModel setValuesForKeysWithDictionary:dataDic[@"data"]];
        
        NSDictionary *counterDic = dataDic[@"data"][@"counterList"];
        [counterModel setValuesForKeysWithDictionary:counterDic];
        
        NSDictionary *shareDic = dataDic[@"data"][@"shareinfo"];
        [shareInfoModel setValuesForKeysWithDictionary:shareDic];
        
        infoModel.counter = counterModel;
        infoModel.shareInfo = shareInfoModel;
        
        [self.listArr addObject:infoModel];
        
        QYLog(@"====%@", self.listArr);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
            //把原来的html通过importStyleWithHtmlString进行替换，修好html的布局
            NSString *newString = [NSString importStyleWithHtmlString:infoModel.html];
            //baseURL可以让界面加载的时候按照本地的样式去加载
            NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
            [_webView loadHTMLString:newString baseURL:baseURL];
            
            [self.view addSubview:_webView];
        });
        
       
        
        
        
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    [self requestData];
    QYLog(@"%@", _contentid);
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark  -----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [bar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(ScreenWidth - 115, 14, 17, 17);
    [commentButton setBackgroundImage:[UIImage imageNamed:@"评论2"] forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
    [bar addSubview:commentButton];
    
    UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    likeButton.frame = CGRectMake(commentButton.frame.origin.x + commentButton.frame.size.width + 15, 14, 17, 17);
    [likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢2"] forState:UIControlStateNormal];
    [bar addSubview:likeButton];
    
    UIButton *othersButton = [UIButton buttonWithType:UIButtonTypeCustom];
    othersButton.frame = CGRectMake(likeButton.frame.origin.x + likeButton.frame.size.width + 15, 14, 25, 17);
    [othersButton setBackgroundImage:[UIImage imageNamed:@"其他"] forState:UIControlStateNormal];
    [bar addSubview:othersButton];
    
    [self.view addSubview:bar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commentClick {
    ReadCommentViewController *commentVC = [[ReadCommentViewController alloc]init];
    commentVC.contentid = _contentid;
    [self.navigationController pushViewController:commentVC animated:YES];
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
