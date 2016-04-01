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

@property (strong, nonatomic)UIViewController *rootVC;
@property (strong, nonatomic)UIViewController *leftVC;
@property (strong, nonatomic)UITapGestureRecognizer *tap;

- (instancetype)initWithController:(UIViewController *)controller;

- (void)setNavController:(UIViewController *)controller animated:(BOOL)animated;

- (void)showLeftView:(BOOL)animated;

- (void)showRootController:(BOOL)animated;


@end
