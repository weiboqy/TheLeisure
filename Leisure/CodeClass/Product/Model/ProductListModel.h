//
//  ProductListModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface ProductListModel : BaseModel

/**购买链接*/
@property (copy, nonatomic)NSString *buyrul;

/**图片*/
@property (copy, nonatomic)NSString *coverimg;

/**标题*/
@property (copy, nonatomic)NSString *titile;

/**产品ID*/
@property (copy, nonatomic)NSString *contentid;

@end
