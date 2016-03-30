//
//  DrawerViewController.h
//  Leisure
//
//  Created by lanou on 16/3/28.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"

@interface DrawerViewController : UIViewController
/** 抽屉的根视图控制器 */
@property (strong, nonatomic)UIViewController *rootVC;
/** 抽屉的左菜单视图控制器 */
@property (strong, nonatomic)UIViewController *leftVC;
/** 当菜单栏成为第一响应者，通过点击手机进行返回 */
@property (strong, nonatomic)UITapGestureRecognizer *tap;
/** 自定义初始化方法，在自定义方法中设置根视图控制器对象 */
- (instancetype)initWithController:(UIViewController *)controller;
/** 设置根视图控制器 */
- (void)setNavController:(UIViewController *)controller animated:(BOOL)animated;
/** 显示左边菜单视图 */
- (void)showLeftView:(BOOL)animated;
/** 显示根视图 */
- (void)showRootController:(BOOL)animated;


@end
