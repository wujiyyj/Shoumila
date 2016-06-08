//
//  UMChatToolBar.h
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMTextView.h"
#import "UMRecorder.h"

@class UMTextView;
@class UMRadialView;
@interface UMChatToolBar : UIView

@property (strong, nonatomic) UMTextView *inputTextView;

@property (strong, nonatomic) UIButton *rightButton;
@property (strong, nonatomic) UIButton *plusButton;
@property (nonatomic) BOOL textValid;

@property (nonatomic) BOOL isEditMode;
@property (strong, nonatomic) NSMutableDictionary *contactInfo;

- (NSString *)textContent;

- (void)cleanInputText;
@end
