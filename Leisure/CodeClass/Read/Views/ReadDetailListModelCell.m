//
//  ReadDetailListModelCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadDetailListModelCell.h"
#import "ReadDetailModel.h"
#import "UIImageView+WebCache.h"

@implementation ReadDetailListModelCell


- (void)setDataWithModel:(ReadDetailModel *)model {
    self.titleLabel.text = model.title;
    self.contenLabel.text = model.content;
    [self.coveingImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:PLACEHOLDERIMAGE];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
