//
//  TopicTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/3/31.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListModel.h"
#import "UIImageView+WebCache.h"

@interface TopicTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *coveimagImage;
@property (strong, nonatomic) IBOutlet UILabel *addtime_f;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel;
@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (strong, nonatomic) IBOutlet UIImageView *commentImage;

@property (strong, nonatomic)TopicListModel *model;

- (void)setModel:(TopicListModel *)model;

@end
