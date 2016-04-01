//
//  ReadDetailModel.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadDetailModel.h"

@implementation ReadDetailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        self.contentID = value;
    }
}

@end
