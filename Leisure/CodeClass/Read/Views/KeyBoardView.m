//
//  KeyBoardView.m
//  Leisure
//
//  Created by lanou on 16/4/9.
//  Copyright © 2016年 xqy. All rights reserved.
//

#import "KeyBoardView.h"
#define kStartLocation 20

@interface KeyBoardView()<UITextViewDelegate>

@property (assign, nonatomic)CGFloat textViewWidth;
@property (assign, nonatomic)BOOL isChange;
@property (assign, nonatomic)BOOL reduce;
@property (assign, nonatomic)CGRect originalKey;
@property (assign, nonatomic)CGRect originalText;

@end

@implementation KeyBoardView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initTextView:frame];
    }
    return self;
}

- (void)initTextView:(CGRect)frame {
    self.textView = [[UITextView alloc]init];
    self.textView.delegate = self;
    CGFloat textX = kStartLocation * 0.5;
    self.textViewWidth = frame.size.width - 2 * textX;
    self.textView.frame = CGRectMake(textX, kStartLocation * 0.2, self.textViewWidth, frame.size.height - 2 * kStartLocation * 0.2);
    self.textView.backgroundColor = [UIColor colorWithRed:223 / 255.0 green:223 / 255.0 blue:223 / 255.0 alpha:1.0];
    self.textView.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if ([self.delegate respondsToSelector:@selector(keyBoardViewHide:textView:)]) {
            [self.delegate keyBoardViewHide:self textView:self.textView];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *content = textView.text;
    CGSize contextSize  = [content sizeWithAttributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:20.0]forKey:NSFontAttributeName]];
    
    if (contextSize.width > self.textViewWidth) {
        if (!self.isChange) {
            CGRect keyFrame = self.frame;
            self.originalKey = keyFrame;
            keyFrame.size.height += keyFrame.size.height;
            keyFrame.origin.y -= keyFrame.size.height * 0.25;
            self.frame = keyFrame;
            
            CGRect textFrame = self.textView.frame;
            self.originalText = textFrame;
            textFrame.size.height += textFrame.size.height * 0.5 + kStartLocation;
            self.textView.frame = textFrame;
            self.isChange = YES;
            self.reduce = YES;
        }
    }
    
    if (contextSize.width <= self.textViewWidth) {
        if (self.reduce) {
            self.frame = self.originalKey;
            self.textView.frame = self.originalText;
            self.isChange = NO;
            self.reduce = NO;
        }
    }
}


@end
