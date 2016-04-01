//
//  NetWorkRequesManager.m
//  Leisure
//
//  Created by lanou on 16/3/29.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "NetWorkRequesManager.h"

@implementation NetWorkRequesManager

+ (void)requestWithType:(requestWithType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(requestFinish)finish error:(requestError)error{
    NetWorkRequesManager *manager = [[NetWorkRequesManager alloc]init];
    [manager requestWithType:type urlString:urlString parDic:parDic finish:finish error:error];
}


- (void)requestWithType:(requestWithType)type urlString:(NSString *)urlString parDic:(NSDictionary *)parDic finish:(requestFinish)finish error:(requestError)error1{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    if (type == POST) {
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[self dataWithParDic:parDic]];
    }
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            finish(data);
        }else{
            error1(error);
        }
    }];
    [task resume];
    
}

- (NSData *)dataWithParDic:(NSDictionary *)parDic{
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *key in parDic) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, parDic[key]];
        [mArr addObject:str];
    }
    NSString *str = [mArr componentsJoinedByString:@"&"];
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}
@end
