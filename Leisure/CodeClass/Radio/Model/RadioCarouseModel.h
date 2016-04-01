//
//  RadioCarouseModel.h
//  Leisure
//
//  Created by lanou on 16/3/30.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface RadioCarouseModel : BaseModel

/**图片地址*/
@property (copy, nonatomic)NSString *img;
/**跳转地址*/
@property (copy, nonatomic)NSString *url;

@end
