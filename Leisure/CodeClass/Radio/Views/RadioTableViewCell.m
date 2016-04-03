//
//  RadioTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/4/2.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioTableViewCell.h"

@implementation RadioTableViewCell

- (void)setDataWithModel:(RadioListModel *)model {
    [self.coverimgImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:PLACEHOLDERIMAGE];
    self.titleLabel.text = model.title;
    self.radioidLabel.text = [NSString stringWithFormat:@"%@", model.userinfo.uname];
    self.descLabel.text = [NSString stringWithFormat:@"%@", model.desc];
    self.countLabel.text = [NSString stringWithFormat:@"%@", model.count];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
