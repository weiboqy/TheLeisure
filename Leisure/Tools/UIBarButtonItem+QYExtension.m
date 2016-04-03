//
//  UIBarButtonItem+QYExtension.m
//  百思不得其姐
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "UIBarButtonItem+QYExtension.h"

@implementation UIBarButtonItem (QYExtension)


+ (instancetype)itemWithImage:(NSString *)image selectImage:(NSString *)selectImage target:(id)target action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:selectImage] forState:UIControlStateHighlighted];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
    
}

@end
