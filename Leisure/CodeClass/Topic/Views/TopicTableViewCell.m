//
//  TopicTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "TopicTableViewCell.h"

@implementation TopicTableViewCell

- (void)setModel:(TopicListModel *)model {
    self.titleLabel.text = model.title;
    [self.coveimagImage sd_setImageWithURL:[NSURL URLWithString:model.coverimg] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.addtime_f.text = [NSString stringWithFormat:@"%@", model.addtime_f];
    self.contentLabel.text = [NSString stringWithFormat:@"%@", model.content];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", model.counterList.comment];
    self.commentImage.image = [UIImage imageNamed:@"u179"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
