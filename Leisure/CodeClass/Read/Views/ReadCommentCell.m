//
//  ReadCommentCell.m
//  Leisure
//
//  Created by lanou on 16/4/8.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "ReadCommentCell.h"

@implementation ReadCommentCell

- (void)setModel:(ReadCommentModel *)model {
    _model = model;
    [self.iconImagView sd_setImageWithURL:[NSURL URLWithString:model.userinfo.icon] placeholderImage:PLACEHOLDERIMAGE];
    self.unameLabel.text = [NSString stringWithFormat:@"%@", model.userinfo.uname];
    self.addtime_fLabel.text = [NSString stringWithFormat:@"%@", model.addtime_f];
    self.contentLabel.text = [NSString stringWithFormat:@"%@", model.content];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
