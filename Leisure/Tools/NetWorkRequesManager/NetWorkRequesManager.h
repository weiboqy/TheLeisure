//
//  NetWorkRequesManager.h
//  Leisure
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

//枚举  GET/POST请求
typedef NS_ENUM(NSInteger, requestWithType){
    GET,
    POST
};


typedef void (^requestFinish) (NSData *data);
typedef void (^requestError) (NSError *error);

@interface NetWorkRequesManager : NSObject

+ (void)requestWithType:(requestWithType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(requestFinish)finish error:(requestError)error;


@end
