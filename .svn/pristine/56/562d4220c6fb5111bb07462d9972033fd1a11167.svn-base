//
//  UMChatToolBar.m
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMChatToolBar.h"
#import "UMRadialView.h"
#import "UMRecorder.h"
#import "UMOpenMacros.h"
#import "UMFeedback.h"

#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

@interface UMChatToolBar() <RecorderDelegate, UITextViewDelegate>

@property (strong, nonatomic) UITextField *inputTextField;
@property (nonatomic) BOOL isTextMode;

@end

@implementation UMChatToolBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isTextMode = YES;

        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        lineView.backgroundColor = ColorLine;
        [self addSubview:lineView];
        
        if (UM_IOS_7_OR_LATER) {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        } else {
            self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [self.rightButton setTitleColor:ColorRankMenuBackground
                               forState:UIControlStateDisabled];
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.rightButton setEnabled:NO];
        [self addSubview:self.rightButton];
        
        self.plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.plusButton setImage:[UIImage imageNamed:@"message_chat_icon"]
                         forState:UIControlStateNormal];
        self.plusButton.hidden = YES;
        [self addSubview:self.plusButton];

        CGFloat width = 24;
        CGFloat paddingRight = 20;
        self.rightButton.frame = CGRectMake(self.width - width - paddingRight, (self.height - width) / 2 , 30, width);
        self.plusButton.frame = CGRectMake(self.width - width - paddingRight, (self.height - width) / 2 , width, width);
        self.inputTextView = [[UMTextView alloc] initWithFrame:CGRectMake(10, 7, self.width - 20 - 15 - width - 10, self.frame.size.height-14)];
        self.inputTextView.delegate = self;
        self.inputTextView.placeholder = UM_Local(@"回复灿烂");
        self.inputTextView.layer.zPosition = 500;
        [self addSubview:self.inputTextView];
        

        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeTextViewText:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
        self.backgroundColor = ColorRankBackground;
    }
    return self;
}

- (void)setIsEditMode:(BOOL)isEditMode {
    _isEditMode = isEditMode;
    if (isEditMode) {
        if (!_textValid) {
            self.plusButton.hidden = YES;
        }
        [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
    } else {
        // 从编辑联系信息界面切换到文本输入界面，不支持切换到语音输入界面
        self.inputTextView.placeholder = UM_Local(@"回复灿烂");
        [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
        CGRect frame = self.frame;
        frame.size.height = 44;
        self.frame = frame;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 24;
    CGFloat paddingRight = 20;
    self.rightButton.frame = CGRectMake(self.width - width - paddingRight, (self.height - width) / 2 , 30, width);
    self.plusButton.frame = CGRectMake(self.width - width - paddingRight, (self.height - width) / 2 , width, width);
    self.inputTextView.frame = CGRectMake(10, 7, self.width - 20 - 15 - width - 10, self.frame.size.height-14);

    
}

- (NSString *)textContent {
    return [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (void)cleanInputText {
    self.inputTextView.text = @"";
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"] && self.isEditMode) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didChangeTextViewText:(NSNotification *)notification
{
    UMTextView *textView = (UMTextView *)notification.object;
    
    // Skips this it's not the expected textView.
    if (![textView isEqual:self.inputTextView]) {
        return;
    }
    
    [self textDidUpdate:YES];
    
    if ( ! self.isEditMode) {
        return;
    }
}

- (void)textDidUpdate:(BOOL)animated
{
    [self checkRightButton];

    if (self.textValid) {
        self.rightButton.hidden = NO;
        self.plusButton.hidden = YES;
        [self.rightButton setEnabled:YES];
        [self.rightButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:UM_UIColorFromRGB(0, 122.0, 255.0) forState:UIControlStateNormal];
    } else {
        self.plusButton.hidden = _isEditMode ? YES : NO;
        self.rightButton.hidden = _isEditMode ? NO : YES;
    }
}

- (BOOL)checkRightButton
{
    NSString *text = [self.inputTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (text.length > UM_CONTENT_MAX_LENGTH || text.length == 0) {
        self.textValid = NO;
    } else {
        self.textValid = YES;
    }
    return self.textValid;
}

- (void)dealloc {
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
}

@end
