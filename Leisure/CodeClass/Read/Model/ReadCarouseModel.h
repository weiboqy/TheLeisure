//
//  carouseModel.h
//  Leisure
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "BaseModel.h"

@interface ReadCarouseModel : BaseModel

/**图片*/
@property (copy, nonatomic)NSString *img;
/**内容网址*/
@property (copy, nonatomic)NSString *url;

@end
