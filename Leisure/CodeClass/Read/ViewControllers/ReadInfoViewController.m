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
#import "ReadDetailDB.h"
#import "LoginViewController.h"

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
    [likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢1"] forState:UIControlStateNormal];
    [likeButton addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //查询本条消息是否已经存储， 如果已经存储的话，按钮显示已经收藏状态
    ReadDetailDB *db = [[ReadDetailDB alloc]init];
    NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
    for (ReadDetailModel *model in array) {
        if ([model.title isEqualToString:_detailModel.title]) {
            [likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢2"] forState:UIControlStateNormal];
            break;
        }
    }
    
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
//评论功能的实现
- (void)commentClick {
    ReadCommentViewController *commentVC = [[ReadCommentViewController alloc]init];
    commentVC.contentid = _contentid;
    [self.navigationController pushViewController:commentVC animated:YES];
}

//收藏功能的实现
- (void)likeClick:(id)sender {
    UIButton *likeButton = (UIButton *)sender;
    
    //如果用户已经登陆 直接收藏 ，没有登陆就弹出登陆页面
    if (![[UserInfoManager getUserID] isEqualToString:@" "]) {
        //创建数据表
        ReadDetailDB *db = [[ReadDetailDB alloc]init];
        [db createDataTable];
        
        //查询数据是否存储， 如果存储就取消存储
        NSArray *array = [db findWithUserID:[UserInfoManager getUserID]];
        for (ReadDetailModel *model  in array) {
            if ([model.title isEqualToString:_detailModel.title]) {
                [db deleteDetailWithTitle:_detailModel.title];
                [likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢1"] forState:UIControlStateNormal];
                return ;
            }
        }
        //否则的话，调用保存方法进行存储
        [db saveDetailModel:_detailModel];
        [likeButton setBackgroundImage:[UIImage imageNamed:@"喜欢2"] forState:UIControlStateNormal];
    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:@"你还未登陆,是否现在登陆" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self presentViewController:loginVC animated:YES completion:nil];
            
        }];
        [alertController addAction:action1];
        [alertController addAction:action2];
        [self presentViewController:alertController animated:YES completion:nil];

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
