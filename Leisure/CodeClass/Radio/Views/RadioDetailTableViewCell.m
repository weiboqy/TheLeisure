//
//  RadioDetailTableViewCell.m
//  Leisure
//
//  Created by lanou on 16/4/3.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "RadioDetailTableViewCell.h"
#import "PlayerManager.h"

@implementation RadioDetailTableViewCell

- (void)setDataWithModel:(RadioDetailListModel *)model {
    [self.coverimgImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.coverimg]] placeholderImage:PLACEHOLDERIMAGE];
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.title];
    self.musicVisitLabel.text = [NSString stringWithFormat:@"%@", model.musicVisit];

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
