//
//  RYGFeedThreadsViewController.m
//  shoumila
//
//  Created by 贾磊 on 15/9/18.
//  Copyright (c) 2015年 如意谷. All rights reserved.
//

#import "RYGFeedThreadsViewController.h"
#import "RYGHttpRequest.h"
#import "RYGCommentModel.h"
#import "RYGDynamicFrame.h"
#import "RYGThreadsParam.h"
#import "RYGCommentView.h"
#import "UMChatToolBar.h"
#import "UMFeedbackViewController.h"
#import "UMOpenMacros.h"
#import "Emoji.h"
#import "RYGHttpRequest.h"
#import "RYGCommentParam.h"
#import "MBProgressHUD+MJ.h"
#import "FacialView.h"

#define Time  0.25
#define  keyboardHeight 272
#define TextViewTop 110

const CGFloat kMessagesInputToolbarHeightDefalt1 = 48.0f;
static void * kJSQMessagesKeyValueObservingContext = &kJSQMessagesKeyValueObservingContext;

@interface RYGFeedThreadsViewController ()<facialViewDelegate,UITextViewDelegate>
@property(nonatomic,strong) UITableView *threadTableView;
@property(nonatomic,strong) NSMutableArray *commentList;
@property(nonatomic,strong) RYGCommentView *commentView;
@property(nonatomic,strong)RYGFeedDetailCommentFrame *commentFrame;
@property (strong, nonatomic) UMChatToolBar *inputToolBar;
@property (nonatomic) CGFloat topViewOffset;
@property (strong, nonatomic) UIColor *titleColor;
@property(nonatomic, weak) id <ChatViewDelegate> delegate;
@property (assign, nonatomic) BOOL isKeyboardShow;
@property (assign, nonatomic) BOOL isObserving;
@end

@implementation RYGFeedThreadsViewController{
    UIScrollView    *scrollView;
    UIPageControl   *pageControl;
    UIView       *toolBar;
    UIBarButtonItem *item;
    BOOL            keyboardIsShow;
    RYGDynamicModel *model;
    RYGCommentModel *commentModel;
    RYGThreadModel  *threadModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _commentList = [NSMutableArray array];
    [self loadData];
    _commentView = [[RYGCommentView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    __weak RYGFeedThreadsViewController *weakSelf = self;
    _commentView.reloadBlock = ^{
        [weakSelf loadData];
    };
    [self.view addSubview:_commentView];
    [self setUpKeyBoard];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setUpFacialView];
    [self jsq_addObservers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowAction:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideAction:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [self.inputToolBar.inputTextView becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self jsq_removeObservers];
}

- (void)loadData{
    RYGThreadsParam *param = [RYGThreadsParam param];
    param.comment_id = _comment_id;
    param.feed_id = _feed_id;
    __weak RYGFeedThreadsViewController *weakSelf = self;
    [RYGHttpRequest getWithURL:Feed_threads params:[param keyValues] success:^(id json) {
        NSMutableDictionary *dic = [json valueForKey:@"data"];
        NSArray *commentList = [dic valueForKey:@"comment_list"];
       
        RYGCommentModel *model1 = [RYGCommentModel objectWithKeyValues:commentList];
        RYGFeedDetailCommentFrame *commentFrame = [[RYGFeedDetailCommentFrame alloc]init];
        commentFrame.isNeedFooter = NO;
        commentFrame.commentModel = model1;
        _commentView.commentFrame = commentFrame;
        _commentView.tableViewSelectedBlock = ^(RYGThreadModel *model1){
            weakSelf.inputToolBar.inputTextView.placeholder = [NSString stringWithFormat:@"回复:%@",model1.name];
            threadModel = model1;
        };
        _commentView.msgBtnBlock = ^{
            threadModel = nil;
            weakSelf.inputToolBar.inputTextView.placeholder = @"回复";
        };
    } failure:^(NSError *error) {
        
    }];
}


-(void)setUpKeyBoard{
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 216, SCREEN_WIDTH, 216)];
        scrollView.backgroundColor = [UIColor whiteColor];
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, 0);
    scrollView.pagingEnabled=YES;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, SCREEN_HEIGHT - 30, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
    
    self.inputToolBar = [[UMChatToolBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-kMessagesInputToolbarHeightDefalt1 - 66, self.view.width, kMessagesInputToolbarHeightDefalt1)];
    self.inputToolBar.inputTextView.delegate = self;
    self.inputToolBar.inputTextView.returnKeyType=UIReturnKeySend;
    [self.view addSubview:self.inputToolBar];
    
    [self.inputToolBar.plusButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    self.inputToolBar.rightButton.hidden = YES;
    self.inputToolBar.plusButton.hidden = NO;
    self.inputToolBar.inputTextView.placeholder = UM_Local(@"回复");
    if (self.titleColor) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.titleColor};
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self.inputToolBar name:UITextViewTextDidChangeNotification object:nil];
}

-(void)setUpFacialView{
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, 300, 170)];
        fview.backgroundColor = [UIColor whiteColor];
        [fview loadFacialView:i size:CGSizeMake(SCREEN_SCALE*33, 43)];
        fview.delegate=self;
        [scrollView addSubview:fview];
    }
}

-(void)disFaceKeyboard{
    if (!self.isKeyboardShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
        }];
        [self.inputToolBar.inputTextView becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            _inputToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-keyboardHeight-_inputToolBar.frame.size.height,  SCREEN_WIDTH,_inputToolBar.frame.size.height);
        }];
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT-keyboardHeight,SCREEN_WIDTH, keyboardHeight)];
        }];
        [pageControl setHidden:NO];
        [self.inputToolBar.inputTextView resignFirstResponder];
    }
}

#pragma mark - Keybaord Show Hide Notification

- (void)keyboardWillShowAction:(NSNotification *)aNotification {
    [self keyboardAction:aNotification isShow:YES];
    
    CGFloat animationTime = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"键盘即将出现：%@", NSStringFromCGRect(keyBoardFrame));
        self.inputToolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-106,  SCREEN_WIDTH,44);
    }];
    [pageControl setHidden:YES];
}

- (void)keyboardWillHideAction:(NSNotification *)aNotification {
    //        [self keyboardAction:aNotification isShow:NO];
    self.isKeyboardShow = NO;
    if (pageControl.isHidden) {
        self.inputToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-self.inputToolBar.frame.size.height-66,  SCREEN_WIDTH,self.inputToolBar.frame.size.height);
    }
}

- (void)keyboardDidShow {
    self.isKeyboardShow = YES;
}

- (void)keyboardAction:(NSNotification *)aNotification isShow:(BOOL)isShow {
    NSDictionary* userInfo = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    [UIView commitAnimations];
}

- (void)jsq_addObservers
{
    if (self.isObserving) {
        return;
    }
    
    if (UM_IOS_7_OR_LATER) {
        [self.inputToolBar.inputTextView addObserver:self
                                          forKeyPath:NSStringFromSelector(@selector(contentSize))
                                             options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                                             context:kJSQMessagesKeyValueObservingContext];
    }
    
    self.isObserving = YES;
}

- (void)jsq_removeObservers
{
    if (!_isObserving) {
        return;
    }
    
    @try {
        [_inputToolBar.inputTextView removeObserver:self
                                         forKeyPath:NSStringFromSelector(@selector(contentSize))
                                            context:kJSQMessagesKeyValueObservingContext];
    }
    @catch (NSException * __unused exception) { }
    
    _isObserving = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kJSQMessagesKeyValueObservingContext) {
        if (self.inputToolBar.isEditMode) {
            return;
        }
        if (object == self.inputToolBar.inputTextView
            && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
            
            CGSize oldContentSize = [[change objectForKey:NSKeyValueChangeOldKey] CGSizeValue];
            CGSize newContentSize = [[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue];
            
            CGFloat dy = newContentSize.height - oldContentSize.height;
            
            [self adjustInputToolbarForComposerTextViewContentSizeChange:dy];
        }
    }
}

- (BOOL)inputToolbarHasReachedMaximumHeight
{
    return (CGRectGetMinY(self.inputToolBar.frame) == self.topViewOffset);
}

- (void)adjustInputToolbarForComposerTextViewContentSizeChange:(CGFloat)dy
{
    BOOL contentSizeIsIncreasing = (dy > 0);
    //        NSLog(@"offset: %f", self.inputToolBar.inputTextView.contentOffset.y);
    
    if ([self inputToolbarHasReachedMaximumHeight]) {
        BOOL contentOffsetIsPositive = (self.inputToolBar.inputTextView.contentOffset.y > -dy);
        //        NSLog(@"offset: %f", self.inputToolBar.inputTextView.contentOffset.y);
        
        if (contentSizeIsIncreasing || contentOffsetIsPositive) {
            [self scrollComposerTextViewToBottomAnimated:YES];
            return;
        }
        dy += self.inputToolBar.inputTextView.contentOffset.y + 8;
    }
    
    CGFloat toolbarOriginY = CGRectGetMinY(self.inputToolBar.frame);
    CGFloat newToolbarOriginY = toolbarOriginY - dy;
    
    //  attempted to increase origin.Y above topLayoutGuide
    if (newToolbarOriginY <= self.topViewOffset) {
        dy = toolbarOriginY - self.topViewOffset;
        [self scrollComposerTextViewToBottomAnimated:YES];
    }
    
    [self adjustInputToolbarHeightByDelta:dy];
    
    if (dy < 0) {
        [self scrollComposerTextViewToBottomAnimated:NO];
    }
}

- (void)adjustInputToolbarHeightByDelta:(CGFloat)dy
{
    CGRect frame = self.inputToolBar.frame;
    frame.size.height += dy;
    if (frame.size.height < kMessagesInputToolbarHeightDefalt1) {
        dy = 0;
        frame.size.height = kMessagesInputToolbarHeightDefalt1;
    }
    
    frame.origin.y -= dy;
    self.inputToolBar.frame = frame;
    
    CGRect inputTextViewFrame = self.inputToolBar.inputTextView.frame;
    inputTextViewFrame.size.height += dy;
    self.inputToolBar.inputTextView.frame = inputTextViewFrame;
    [self.inputToolBar.inputTextView scrollsToTop];
    
    //        [self.mTableView setNeedsDisplay];
    CGRect sendButtonFrame = self.inputToolBar.rightButton.frame;
    sendButtonFrame.origin.y += dy;
    self.inputToolBar.rightButton.frame = sendButtonFrame;
    sendButtonFrame = self.inputToolBar.plusButton.frame;
    sendButtonFrame.origin.y += dy;
    self.inputToolBar.plusButton.frame = sendButtonFrame;
    // 当编辑框回位时，重置tableview bottom
}

- (void)scrollComposerTextViewToBottomAnimated:(BOOL)animated
{
    UITextView *textView = self.inputToolBar.inputTextView;
    CGPoint contentOffsetToShowLastLine = textView.contentOffset;
    contentOffsetToShowLastLine.y = textView.contentSize.height - CGRectGetHeight(textView.bounds);
    [textView setContentOffset:contentOffsetToShowLastLine animated:animated];
}

-(void)selectedFacialView:(NSString*)str {
    NSString *newStr;
    if ([str isEqualToString:@"删除"]) {
        if (self.inputToolBar.inputTextView.text.length>0) {
            if ([[Emoji allEmoji] containsObject:[self.inputToolBar.inputTextView.text substringFromIndex:self.inputToolBar.inputTextView.text.length-2]]) {
                NSLog(@"删除emoji %@",[self.inputToolBar.inputTextView.text substringFromIndex:self.inputToolBar.inputTextView.text.length-2]);
                newStr=[self.inputToolBar.inputTextView.text substringToIndex:self.inputToolBar.inputTextView.text.length-2];
            }else{
                newStr=[self.inputToolBar.inputTextView.text substringToIndex:self.inputToolBar.inputTextView.text.length-1];
            }
            self.inputToolBar.inputTextView.text=newStr;
        }
    }else{
        self.inputToolBar.inputTextView.placeholder = @"回复灿烂";
        NSString *newStr=[NSString stringWithFormat:@"%@%@",self.inputToolBar.inputTextView.text,str];
        [self.inputToolBar.inputTextView setText:newStr];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.inputToolBar.inputTextView resignFirstResponder];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 发送评论
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    self.inputToolBar.rightButton.hidden = YES;
    if ([text isEqualToString:@"\n"]){
        RYGCommentParam *param = [RYGCommentParam param];
        param.feed_id = _feed_id;
        param.comment_id = _comment_id;
        param.comment = textView.text;
        if (threadModel) {
            param.comment_id = threadModel.comment_id;
            param.reply_uid =threadModel.uid;
        }
        [RYGHttpRequest getWithURL:Feed_comment params:[param keyValues] success:^(id json) {
            [self clearInputText];
            [self.inputToolBar.inputTextView resignFirstResponder];
            [self loadData];
        } failure:^(NSError *error) {
            
        }];
        return NO;
    }
    if (textView.text.length>250) {
        [MBProgressHUD showError:@"最多可以回复250个字"];
        return NO;
    }
    return YES;
}

- (void)clearInputText{
    self.inputToolBar.inputTextView.text = @"";
}


@end
