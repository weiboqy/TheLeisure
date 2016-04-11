//
//  KeyBoardView.h
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KeyBoardView;

@protocol KeyBoardViewDelegate <NSObject>

//键盘输入完成的协议方法
- (void)keyBoardViewHide:(KeyBoardView *)keyBoardView textView:(UITextView *)contentView;

@end

@interface KeyBoardView :UIView

@property (strong, nonatomic)UITextView *textView;
@property (assign, nonatomic)id<KeyBoardViewDelegate>delegate;


@end
