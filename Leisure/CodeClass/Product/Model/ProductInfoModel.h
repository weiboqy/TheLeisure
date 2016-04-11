//
//  ProductInfoModel.h
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfoModel : NSObject

/** 文章id */
@property (copy, nonatomic)NSString *contentid;
/** html */
@property (copy, nonatomic)NSString *html;
/** 标题 */
@property (copy, nonatomic)NSString *title;

@end
