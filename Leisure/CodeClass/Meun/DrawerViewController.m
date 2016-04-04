//
//  DrawerViewController.m
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "DrawerViewController.h"
#import "CustomNavigationBar.h"
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kLeftWidth 280.0f
@interface DrawerViewController ()
{
    /** 判断左菜单是否能显示*/
    BOOL canShowLeft;
    /** 判断是否正在显示*/
    BOOL showingLeftView;
}
@end


@implementation DrawerViewController

@synthesize leftVC = _left;
@synthesize rootVC = _root;


//实现初始化方法
- (instancetype)initWithController:(UIViewController *)controller{
    if (self = [super init]) {
        _root = controller;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavController:_root];
    if (!_tap) {
        UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapG:)];
        tapG.delegate = (id<UIGestureRecognizerDelegate>)self;
        [self.view addGestureRecognizer:tapG];
        [tapG setEnabled:NO];
        _tap = tapG;
    }
    
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark  --手势
- (void)tapG:(UITapGestureRecognizer *)tap{
    [tap setEnabled:NO];
    [self showRootController:YES];
}
//手势代理方法
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (gestureRecognizer == _tap) {
        if (_root && showingLeftView) {
            // 设置单击手势能够响应的范围
            return CGRectContainsPoint(_root.view.frame, [gestureRecognizer locationInView:self.view]);
        }
        return NO;
    }
    return YES;
}

- (void)setNavButtons{
    // 如果根视图控制器为空  直接跳出
    if (!_root) {
        return;
    }
    
    // 设置根视图控制器
    UIViewController *topController = nil;
    if ([_root isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController*)_root;
        if ([[navController viewControllers] count] > 0) {
            topController = [[navController viewControllers] objectAtIndex:0];
        }
    } else {
        topController = _root;
    }
    
    // 在根视图导航栏上添加左按钮
    if (canShowLeft) {
        [topController.navigationController setNavigationBarHidden:YES];
        if (![@"TopicViewController" isEqualToString:NSStringFromClass([topController class])]) {
            CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
            [topController.view addSubview:bar];
            [bar.menuBtu setBackgroundImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
            [bar.menuBtu addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
            if ([@"ReadViewController" isEqualToString:NSStringFromClass([topController class])]) {
                bar.titleLabel.text = @"阅读";
            } else if ([@"RadioViewController" isEqualToString:NSStringFromClass([topController class])]) {
                bar.titleLabel.text = @"电台";
            } else if ([@"ProductViewController" isEqualToString:NSStringFromClass([topController class])]) {
                bar.titleLabel.text = @"良品";
            }
        } else {
            CustomNavigationBar *bar = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth / 2, 44)];
            [topController.view addSubview:bar];
            [bar.menuBtu setBackgroundImage:[UIImage imageNamed:@"菜单"] forState:UIControlStateNormal];
            [bar.menuBtu addTarget:self action:@selector(showLeft:) forControlEvents:UIControlEventTouchUpInside];
            bar.titleLabel.text = @"话题";
        }
    } else {
        topController.navigationItem.leftBarButtonItem = nil;
    }
}

// 显示 左菜单栏
- (void)showLeft:(id)sender{
    [self showLeftView:YES];
    
}

#pragma mark  ---显示视图

- (void)showRootController:(BOOL)animated{
    [_tap setEnabled:NO]; // 让单击手势不能响应
    // 设置根视图能够响应
    _root.view.userInteractionEnabled = YES;
    
    CGRect frame = _root.view.frame;
    frame.origin.x = 0.0f;
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        if (_left && _left.view.superview) {
            [_left.view removeFromSuperview];
        }
        showingLeftView = NO;
    }];
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
}

- (void)showLeftView:(BOOL)animated{
    //  如果菜单不能显示， 直接跳出
    if (!canShowLeft) {
        return;
    }
    // 设置菜单正在显示的标记为yes
    showingLeftView = YES;
    
    UIView *view = self.leftVC.view;
    CGRect frame = self.view.bounds;
    frame.size.width = kScreenWidth;
    frame.origin.y = 30;
    view.frame = frame;
    [self.view insertSubview:view atIndex:0];
    
    [self.leftVC viewWillAppear:animated];
    
    frame = _root.view.frame;
    frame.origin.x = CGRectGetMaxX(view.frame) - (kScreenWidth - kLeftWidth);
    
    BOOL _enabled = [UIView areAnimationsEnabled];
    if (!animated) {
        [UIView setAnimationsEnabled:NO];
    }
    
    _root.view.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3 animations:^{
        _root.view.frame = frame;
    } completion:^(BOOL finished) {
        [_tap setEnabled:YES];  // 激活单击手势
    }];
    
    if (!animated) {
        [UIView setAnimationsEnabled:_enabled];
    }
    
    
}


#pragma mark  ---设置根视图控制器对象和左菜单视图控制器对象
- (void)setLeftVC:(UIViewController *)leftVC{
    _left = leftVC;
    canShowLeft = (_left!= nil);
    [self setNavButtons];
}

- (void)setNavController:(UIViewController *)controller{
    UIViewController *tempRoot = _root;
    _root = controller;
    if (_root) {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
        UIView *view = _root.view;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
    } else {
        if (tempRoot) {
            [tempRoot.view removeFromSuperview];
            tempRoot = nil;
        }
    }
    [self setNavButtons];
}



- (void)setNavController:(UIViewController *)controller animated:(BOOL)animated{
    
    if (!controller) {
        [self setNavController:controller];
        return;
    }
    
    if (showingLeftView) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        __block DrawerViewController *selfRef = self;
        __block UIViewController *rootRef = _root;
        
        CGRect frame = rootRef.view.frame;
        frame.origin.x = rootRef.view.bounds.size.width;
        
        [UIView animateWithDuration:.1 animations:^{
            rootRef.view.frame = frame;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [selfRef setNavController:controller];
            _root.view.frame = frame;
            [selfRef showRootController:animated];
        }];
        
    } else {
        [self setNavController:controller];
        [self showRootController:animated];
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
