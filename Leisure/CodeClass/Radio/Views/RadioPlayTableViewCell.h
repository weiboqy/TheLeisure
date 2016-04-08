//
//  RadioPlayTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/4/6.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadioDetailListModel.h"

@interface RadioPlayTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIButton *downButton;

@property (strong, nonatomic)RadioDetailListModel *playInfo;

@end
