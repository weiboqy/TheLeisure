//
//  ReadCommentViewController.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadCommentViewController.h"
#import "ReadCommentCell.h"
#import "UserInfoManager.h"
#import "KeyBoardView.h"


@interface ReadCommentViewController()<UITableViewDataSource, UITableViewDelegate, KeyBoardViewDelegate>

@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *listArr;


@property (nonatomic, strong) KeyBoardView *keyView;
@property (nonatomic,assign) CGFloat keyBoardHeight;
@property (nonatomic,assign) CGRect originalKey;
@property (nonatomic,assign) CGRect originalText;

@end

@implementation ReadCommentViewController

static NSString * const ReadCommentCellID = @"ReadCommentCell";

- (NSMutableArray *)listArr {
    if (_listArr == nil) {
        _listArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArr;
}

//获取评论
- (void)getCommentData {
    //添加指示器
    [SVProgressHUD show];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    parDic[@"auth"] = @"XZU7RH7m1861DC8Z8H8HvkTJxQMGoPLGO9zo4XDA0cWP22NdFSh9d7fo";
    parDic[@"contentid"] = _contentid;
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    [NetWorkRequesManager requestWithType:POST urlString:GETCOMMENT_url parDic:parDic finish:^(NSData *data) {
        //如果data为空的话，返回，否则就清空数组
        if (data == nil) return ;
        [self.listArr removeAllObjects];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        QYLog(@"%@",dic);
        for (NSDictionary *listDic in dic[@"data"][@"list"] ) {
            ReadCommentModel *commentModel = [[ReadCommentModel alloc]init];
            ReadUserInfo *userInfoModel = [[ReadUserInfo alloc]init];
            [commentModel setValuesForKeysWithDictionary:listDic];
            [userInfoModel setValuesForKeysWithDictionary:listDic[@"userinfo"]];
            commentModel.userinfo = userInfoModel;
            [self.listArr addObject:commentModel];
            QYLog(@"uname = %@", commentModel.userinfo.uname);
            QYLog(@"%@",self.listArr);

        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //刷新tableView
            [self.tableView reloadData];
        });
        
        //取消指示器
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        //当数据请求失败时
        [SVProgressHUD showErrorWithStatus:@"数据请求失败!"];
    }];
}

//发送评论
- (void)sendCommentData:(NSString *)comment {
    //添加指示器
    [SVProgressHUD show];
    
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] init];
    parDic[@"auth"] = [UserInfoManager getUserAuth];
    parDic[@"contentid"] = _contentid;
    parDic[@"deviceid"] = @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31";
    parDic[@"content"] = comment;
    [NetWorkRequesManager requestWithType:POST urlString:ADDCOMMENT_url parDic:parDic finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers  error:nil];
        QYLog(@"%@",dic);
        NSNumber *result = dic[@"result"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([result intValue] == 1) {
                [self getCommentData];
            }
        });
        
        [SVProgressHUD dismiss];
    } error:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义导航条
    [self addCustomNavigationBar];
    
    //获取评论
    [self getCommentData];
    
    //创建列表展示
    [self createListView];
    
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyBoardShow:(NSNotification *)notification {
    CGRect keyBoardRect = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    self.keyBoardHeight = deltaY;
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}

- (void)keyBoardHide:(NSNotification *)notification {
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.keyView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.keyView.textView.text = @" ";
        [self.keyView removeFromSuperview];
    }];
}

//输入框的代理方法
- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView {
    [contentView resignFirstResponder];
    //发送评论的借口请求
    [self sendCommentData:contentView.text];
}

#pragma mark ----自定义导航条按钮
- (void)addCustomNavigationBar {
    CustomNavigationBar *navigationBar = [[CustomNavigationBar alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [navigationBar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *writeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    writeButton.frame = CGRectMake(ScreenWidth - 40, 14, 20, 20);
    [writeButton setBackgroundImage:[UIImage imageNamed:@"写字123"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(writeClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationBar addSubview:writeButton];
    [self.view addSubview:navigationBar];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeClick {
    QYLogFunc;
    if (self.keyView == nil) {
        self.keyView = [[KeyBoardView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
    }
    
    //设置输入框
    self.keyView.delegate = self;
    [self.keyView.textView becomeFirstResponder];
    self.keyView.textView.returnKeyType = UIReturnKeySend;
    [self.view addSubview:self.keyView];
}

- (void)createListView {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ReadCommentCell class]) bundle:nil] forCellReuseIdentifier:ReadCommentCellID];
    [self.view addSubview:self.tableView];
}


#pragma mark  -----UITableViewDelegate \ UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 113;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ReadCommentCellID forIndexPath:indexPath];
    ReadCommentModel *model = self.listArr[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
