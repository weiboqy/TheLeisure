//
//  MenuHeaderView.h
//  Leisure
//
//  Created by lanou on 16/4/4.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuHeaderView : UIView

/** 头像 */
@property (strong, nonatomic)UIImageView *iconImage;
/** 昵称 */
@property (strong, nonatomic)UIButton *name;
/** 下载 */
@property (strong, nonatomic)UIButton *downButton;
/** 喜欢 */
@property (strong, nonatomic)UIButton *loveButton;



@end
