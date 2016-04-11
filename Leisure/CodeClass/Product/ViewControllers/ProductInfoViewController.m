//
//  ProductInfoViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ProductInfoViewController.h"
#import "ProductInfoModel.h"

@interface ProductInfoViewController ()

@property (strong, nonatomic)UIWebView *webView;

@end

@implementation ProductInfoViewController


- (void)parseDetailData {
    [NetWorkRequesManager requestWithType:POST urlString:@"http://api2.pianke.me/group/posts_info" parDic:@{@"contentid" : _contentid} finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        QYLog(@"%@", dic);
        
        //获取良品的详细html内容
//        QYLog(@"hhhtml = %@", dic[@"data"][@"postsinfo"][@"html"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
           //获取良品的详细html内容
            NSString *html = dic[@"data"][@"postsinfo"][@"html"];
            //把原来的html通过importStyleWithHtmlString进行替换，修好html的布局/
            NSString *newHtml = [NSString importStyleWithHtmlString:html];
            //baseURL可以让界面加载的时候按照本地的样式去加载
            NSURL *baseURL = [NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath];
            [_webView loadHTMLString:newHtml baseURL:baseURL];
            [self.view addSubview:_webView];
        });
        
    } error:^(NSError *error) {
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //详情列表加载
    [self parseDetailData];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    
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
    QYLogFunc;
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
