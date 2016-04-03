//
//  UIBarButtonItem+QYExtension.h
//  百思不得其姐
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (QYExtension)

+ (instancetype)itemWithImage:(NSString *)image selectImage:(NSString *)selectImage target:(id)target action:(SEL)action;

@end
