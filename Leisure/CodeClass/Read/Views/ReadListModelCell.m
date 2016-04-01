//
//  ReadListModelCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadListModelCell.h"
#import "ReadListModel.h"
#import "UIImageView+WebCache.h"
@implementation ReadListModelCell


- (void)setDataWithModel:(ReadListModel *)model {
    self.nameLabel.text =  [NSString stringWithFormat:@"%@%@", model.name, model.enname];

    [self.coveringImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
}

@end
