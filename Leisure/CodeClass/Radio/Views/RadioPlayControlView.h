//
//  RadioPlayControlView.h
//  Leisure
//
//  Created by lanou on 16/4/7.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioPlayControlView : UIView
/**上一首*/
@property (strong, nonatomic)UIButton *aboveButton;
/**播放/暂停*/
@property (strong, nonatomic)UIButton *playButton;
/**下一首*/
@property (strong, nonatomic)UIButton *belowButton;
@end
