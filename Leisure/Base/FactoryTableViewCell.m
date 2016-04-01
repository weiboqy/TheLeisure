//
//  FactoryTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "FactoryTableViewCell.h"

@implementation FactoryTableViewCell


+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model {
    //1.将 model类名 转换成字符串
    NSString *name = NSStringFromClass([model class]);
    
    //2.获取要创建的cell名
    Class cellClass =  NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);//拼接Cell
    //3.创建cell
    BaseTableViewCell *cell = [[cellClass alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
    //4.返回
    return cell;
}


+ (BaseTableViewCell *)creatTableViewCell:(BaseModel *)model tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    //1.将 model类名 转换成字符串
    NSString *name = NSStringFromClass([model class]);
    
    //2.获取要创建的cell名
//    Class cellClass =  NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);//拼接Cell
    
    //3.创建cell
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:name forIndexPath:indexPath];
    //4.返回
    return cell;
}

@end
