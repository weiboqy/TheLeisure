//
//  LoginViewController.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "UserInfoManager.h"
#import "MenuHeaderView.h"

@interface LoginViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *headerImageView;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passworldTF;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomNavigationBar];
    
    //用户交互 如果想使用手势 就一定要开启这个 默认是关闭 不然手势不生效
    _headerImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    tap.numberOfTapsRequired = 2;
    tap.numberOfTouchesRequired = 1;
    [_headerImageView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)tapClick {
    QYLog(@"点击到了");
    //创建提醒视图
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //判断设备是否存在摄像头，有就调用系统相机，没有，就提醒用户
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //创建相机
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            //文件由来
            picker.sourceType = UIImagePickerControllerSourceTypeCamera; //指定数据来源来自于相机
            picker.delegate  = self;// 指定代理
            picker.allowsEditing = YES; //允许编辑
            
            //模态弹出
            [self presentViewController:picker animated:YES completion:nil];
        }else{
            //没有摄像头，提醒用户 您的设备没有摄像头
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您的设备没有摄像头" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:nil];
            [alertController addAction:alertAction1];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    [alertController addAction:alertAction];
    UIAlertAction *alertAction2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
        pickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//指定数据来源为相册
        pickerC.delegate = self;  //指定代理
        pickerC.allowsEditing = YES;  // 允许编辑
        [self presentViewController:pickerC animated:YES completion:nil];
    }];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

//选取图片之后执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    _headerImageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];

}

#pragma mark  -----自定义导航条
- (void)addCustomNavigationBar {
    CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 44)];
    [bar.menuBtu addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    bar.titleLabel.text = @"登陆";
    
    [self.view addSubview:bar];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerAction:(id)sender {
    RegisterViewController *registerVC = [[RegisterViewController alloc]init];
    [self presentViewController:registerVC animated:YES completion:nil];
}


- (IBAction)loginAction:(id)sender {
    [SVProgressHUD show];
    NSMutableDictionary *parDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    parDic[@"email"] = _emailTF.text;
    parDic[@"passwd"] = _passworldTF.text;
    [NetWorkRequesManager requestWithType:POST urlString:@"http://api2.pianke.me/user/login" parDic:parDic finish:^(NSData *data) {
        NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        QYLog(@"%@", dataDic);
        
       dispatch_async(dispatch_get_main_queue(), ^{
           
           if ([dataDic[@"result"] intValue] == 0) {//登陆失败
               NSString *msg = dataDic[@"data"][@"msg"];
               QYLog(@"msg = %@", msg);
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒...." message:[NSString stringWithFormat:@"%@", msg] preferredStyle:UIAlertControllerStyleAlert];
               UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
               [alertController addAction:action];
               [self presentViewController:alertController animated:YES completion:nil];
           }else { //登陆成功
               //保存用户的auth
               [UserInfoManager conserveUserAuth:dataDic[@"data"][@"auth"]];
               //保持用户的id
               [UserInfoManager conserveUserID:dataDic[@"data"][@"uid"]];
               //保存用户的name
               [UserInfoManager conserveUserName:dataDic[@"data"][@"uname"]];
               //保存用户头像
               [UserInfoManager conserveUsercoverimg:dataDic[@"data"][@"coverimg"]];
               [self dismissViewControllerAnimated:YES completion:nil];
               [SVProgressHUD dismiss];
           }
          
       });
        dispatch_async(dispatch_get_main_queue(), ^{
            MenuHeaderView *headerView = [[MenuHeaderView alloc]init];
            [headerView.name setTitle:[NSString stringWithFormat:@"%@", dataDic[@"data"][@"uname"]] forState:UIControlStateNormal];
            QYLog(@"%@", dataDic[@"data"][@"uname"]);
        });
        
    } error:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    }];
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
