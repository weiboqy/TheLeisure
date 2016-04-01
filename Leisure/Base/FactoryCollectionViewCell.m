//
//  FactoryCollectionViewCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "FactoryCollectionViewCell.h"

@implementation FactoryCollectionViewCell

+ (BaseCollectionViewCell *)creatCollectionViewCell:(BaseModel *)model collection:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath {
    //1.根据 Model类名 转换成字符串
    NSString *name = NSStringFromClass([model class]);
    
    //2.字符串转换成 cell类名
//    Class cellClass = NSClassFromString([NSString stringWithFormat:@"%@Cell", name]);
    
    //3.创建cell
    BaseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:name forIndexPath:indexPath];
    
    //返回
    return cell;
}

@end
