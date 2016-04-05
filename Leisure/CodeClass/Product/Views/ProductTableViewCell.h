//
//  ProductTableViewCell.h
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductListModel.h"

@interface ProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *coverimgImag;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *buyUrlLabel;
@property (strong, nonatomic)ProductListModel *model ;

@end
