//
//  TopicNotPicViewCell.m
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "TopicNotPicViewCell.h"

@implementation TopicNotPicViewCell

- (void)setModel:(TopicListModel *)model {
    self.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    self.contentLabel.text = [NSString stringWithFormat:@"%@", model.content];
    self.addtime_f.text = [NSString stringWithFormat:@"%@", model.addtime_f];
    self.commentLabel.text = [NSString stringWithFormat:@"%@", model.counterList.comment];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
