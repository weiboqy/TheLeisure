//
//  UserInfoManager.h
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoManager : NSObject

+ (instancetype)defaultManager;


/** 保存用户的auth */
+ (void)conserveUserAuth:(NSString *)userAuth;
/** 获取用户的auth */
+ (NSString *)getUserAuth;
/** 取消用户的auth */
+ (void)cancelUserAuth;

/** 保存用户的name*/
+ (void)conserveUserName:(NSString *)userName;
/** 获取用户的name */
+ (NSString *)getUserName;

/** 保存用户的id */
+ (void)conserveUserID:(NSString *)userID;
/** 获取用户的id */
+ (NSString *)getUserID;
/** 取消用户的id */
+ (void)cancelUserID;

/** 保存用户的icon */
+ (void)conserveUserIcon:(NSString *)userIcon;
/** 获取用户的icon */
+ (NSString *)getUserIcon;

/** 保存用户的coverimg */
+ (void)conserveUsercoverimg:(NSString *)coverimg;
/** 获取用户的coverimg */
+ (NSString *)getUsercoverimg;

@end
