//
//  UMFeedbackViewController.m
//  Feedback
//
//  Created by amoblin on 14/7/30.
//  Copyright (c) 2014年 umeng. All rights reserved.
//

#import "UMFeedbackViewController.h"
#import "UMOpenMacros.h"
#import "UMChatToolBar.h"
#import "UMChatTableViewCell.h"
#import "UMPostTableViewCell.h"
#import "UMRadialView.h"
#import "UMFeedback.h"
#import "UMFullScreenPhotoView.h"
#import "RYGSingleton.h"
#import "RYGDateUtility.h"
#import "FacialView.h"
#import <AVFoundation/AVFoundation.h>

#define Time  0.25
#define  keyboardHeight 272

static void * kJSQMessagesKeyValueObservingContext = &kJSQMessagesKeyValueObservingContext;
const CGFloat kMessagesInputToolbarHeightDefault = 48.0f;

@interface UMFeedbackViewController () <UITableViewDataSource, UITableViewDelegate, UMFeedbackDataDelegate, UINavigationBarDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate, UINavigationControllerDelegate,facialViewDelegate>
{
    UIScrollView    *scrollView;
     UIPageControl   *pageControl;
}

@property(nonatomic, weak) id <ChatViewDelegate> delegate;

@property (nonatomic) CGFloat topViewOffset;

@property (strong, nonatomic) UITableView *mTableView;
@property (strong, nonatomic) UMChatToolBar *inputToolBar;

@property (strong, nonatomic) NSIndexPath *currentIndexPath;

@property (strong, nonatomic) UMFeedback *feedback;
@property (nonatomic) UIBarStyle previousBarStyle;
@property (strong, nonatomic) UIColor *titleColor;

@property (assign, nonatomic) BOOL isObserving;
@property (assign, nonatomic) BOOL isKeyboardShow;

@property (strong, nonatomic) UMFullScreenPhotoView *fullScreenView;

// 存储时间
@property (nonatomic,strong) NSMutableDictionary *dicTime;
// 存储行高
@property (nonatomic,strong) NSMutableArray *rowHeights;
// 是否显示时间0不显示，1显示
@property (nonatomic,strong) NSMutableArray *showTimes;

@end

@implementation UMFeedbackViewController

- (id)init {
    self = [super init];
    if (self) {
        self.title = UM_Local(@"收米小助手");
        _feedback = [UMFeedback sharedInstance];
        _delegate = (id<ChatViewDelegate>)self.feedback;
        
        self.topViewOffset = 64;
        _dicTime = [[NSMutableDictionary alloc]init];
        _rowHeights = [[NSMutableArray alloc]init];
        _showTimes = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.mTableView = [[UITableView alloc]
                       initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - self.topViewOffset - kMessagesInputToolbarHeightDefault)];

    [self.mTableView registerClass:[UMPostTableViewCell class]
            forCellReuseIdentifier:@"postCellId"];
    [self.mTableView registerClass:[UMChatTableViewCell class]
            forCellReuseIdentifier:@"chatCellId"];
    self.mTableView.dataSource = self;
    self.mTableView.delegate = self;
    self.mTableView.allowsSelection = YES;

    [self.mTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.mTableView setSeparatorColor:[UIColor redColor]];
    self.mTableView.backgroundColor = ColorRankMyRankBackground;
    
    [self.view addSubview:self.mTableView];
    
    if (scrollView==nil) {
        scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT + 216, SCREEN_WIDTH, 216)];
        [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
    }
    [scrollView setShowsVerticalScrollIndicator:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    scrollView.contentSize=CGSizeMake(SCREEN_WIDTH*9, 0);
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(98, SCREEN_HEIGHT - 30, 150, 30)];
    [pageControl setCurrentPage:0];
    pageControl.numberOfPages = 9;//指定页面个数
    [pageControl setBackgroundColor:[UIColor clearColor]];
    pageControl.pageIndicatorTintColor=[UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    [self.view addSubview:scrollView];
    [self.view addSubview:pageControl];
    
    self.inputToolBar = [[UMChatToolBar alloc] initWithFrame:CGRectMake(0, self.view.height - kMessagesInputToolbarHeightDefault -self.topViewOffset, self.view.width, kMessagesInputToolbarHeightDefault)];
    [self.view addSubview:self.inputToolBar];
    
    [self.inputToolBar.rightButton addTarget:self
                                      action:@selector(sendButtonPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBar.plusButton addTarget:self action:@selector(disFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.titleColor) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: self.titleColor};
    }

    [self setHidesBottomBarWhenPushed:YES];
}

- (NSMutableDictionary*) mutableDeepCopy:(NSDictionary *)dict {
    NSUInteger count = [dict count];
    NSMutableArray *cObjects = [[NSMutableArray alloc] initWithCapacity:count];
    NSMutableArray *cKeys = [[NSMutableArray alloc] initWithCapacity:count];;
    
    NSEnumerator *e = [dict keyEnumerator];
    unsigned int i = 0;
    id thisKey;
    while ((thisKey = [e nextObject]) != nil) {
        id obj = [dict objectForKey:thisKey];
        
        // Try to do a deep mutable copy, if this object supports it
        if ([[obj class] isKindOfClass:[NSDictionary class]])
            cObjects[i] = [self mutableDeepCopy:obj];
        
        // Then try a shallow mutable copy, if the object supports that
        else if ([obj respondsToSelector:@selector(mutableCopyWithZone:)])
            cObjects[i] = [obj mutableCopy];
        
        // If all else fails, fall back to an ordinary copy
        else
            cObjects[i] = [obj copy];
        
        // I don't think mutable keys make much sense, so just do an ordinary copy
        cKeys[i] = [thisKey copy];
        
        ++i;
    }
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithObjects:cObjects forKeys:cKeys];
    
    // The newly-created dictionary retained these, so now we need to balance the above copies
    for (unsigned int i = 0; i < count; ++i) {
    }
    
    return ret;
}

- (void)setBackButton:(UIButton *)button {
    [button addTarget:self action:@selector(backToPrevious) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)setTitleColor:(UIColor *)color {
    _titleColor = color;
}

- (void)backToPrevious {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
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
   // TODOjcx
//    [[UMFeedback sharedInstance] updateUserInfo:@{@"contact": @{@"phone": [RYGSingleton sharedSingleton].userInfo.mobile}}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.feedback.delegate = self;
    self.mTableView.delegate = self;
    [self refreshData];
    [self scrollToBottomAnimated:YES];
    self.previousBarStyle = self.navigationController.navigationBar.barStyle;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    self.inputToolBar.inputTextView.text = @"";

    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self jsq_addObservers];
    [self scrollToBottomAnimated:YES];

    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self.view endEditing:YES];
    
//    [self.inputToolBar.inputTextView becomeFirstResponder];
    for (int i=0; i<9; i++) {
        FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+SCREEN_WIDTH*i, 15, 300, 170)];
        [fview setBackgroundColor:[UIColor clearColor]];
        [fview loadFacialView:i size:CGSizeMake(SCREEN_SCALE*33, 43)];
        fview.delegate=self;
        [scrollView addSubview:fview];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = self.previousBarStyle;
    [self.view endEditing:YES];
    
    
    BOOL audioAuthCheck = [[[NSUserDefaults standardUserDefaults] objectForKey:AudioAuthCheckKey] boolValue];
    if ([[UMFeedback sharedInstance] audioEnabled] && audioAuthCheck) {
        [self stopRecordAndPlayback];
    }
    [self.mTableView becomeFirstResponder];
    [self.inputToolBar.inputTextView endEditing:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self jsq_removeObservers];
    
    self.mTableView.delegate = nil;
    [self.inputToolBar.inputTextView endEditing:YES];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)topicAndReplies {
    return self.feedback.topicAndReplies;
}

- (void)tapViewAction:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

- (void)setIsEditMode:(BOOL)isEditMode {
    [self.inputToolBar setIsEditMode:isEditMode];
    [self.inputToolBar.inputTextView resignFirstResponder];
    
    self.mTableView.frame = CGRectMake(0, 0, self.view.width, self.view.height - kMessagesInputToolbarHeightDefault);
    self.inputToolBar.frame = CGRectMake(0, self.view.height - kMessagesInputToolbarHeightDefault, self.view.width, kMessagesInputToolbarHeightDefault);
    
    if (isEditMode) {
        [self.inputToolBar.inputTextView becomeFirstResponder];
    } else {
        self.inputToolBar.inputTextView.keyboardType = UIKeyboardTypeDefault;
        [self.inputToolBar.inputTextView resignFirstResponder];
        [scrollView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 44)];
    }
}

- (void)sendButtonPressed:(UIButton *)button {
    if (self.inputToolBar.isEditMode) {
        [self setIsEditMode:NO];
        [self.inputToolBar cleanInputText];
        if ([self.delegate respondsToSelector:@selector(updateUserInfo:)]) {
            [self.delegate updateUserInfo:self.inputToolBar.contactInfo];
        }
        return;
    }
    
    // INFO: reply_id to mark the reply content and when post back to replace it.
    
    NSDictionary *info;
    if ([self.inputToolBar textValid]) {
        NSString *content = [self.inputToolBar textContent];
        [self.inputToolBar cleanInputText];
        
        info = @{@"content": content};
        [self setIsEditMode:NO];
    } else {
        // audio
        info = @{};
    }
    [self sendData:info];
    
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
    UIEdgeInsets inset = [self.mTableView contentInset];
    inset.bottom = keyboardHeight + 10 + self.inputToolBar.frame.size.height - kMessagesInputToolbarHeightDefault;

    [self.mTableView setContentInset:inset];
}

- (void)sendData:(NSDictionary *)info
{
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
    
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.topicAndReplies.count-1 inSection:0];
    
    if ([self.delegate respondsToSelector:@selector(sendButtonPressed:)]) {
        [self.delegate sendButtonPressed:info];
    }
    self.currentIndexPath = [NSIndexPath indexPathForRow:self.topicAndReplies.count-1 inSection:0];
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)updateData:(BOOL)reloadData
{
    if (reloadData)
    {
    }
}

#pragma mark Umeng Feedback delegate

- (void)updateTableView:(NSError *)error
{
    [self.mTableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)getFinishedWithError:(NSError *)error
{
    [self updateTableView:error];
}

- (void)updateTextField:(NSError *)error
{
    if (!error)
    {
    }
    
    [self updateData:YES];
}

- (void)postFinishedWithError:(NSError *)error
{
    if (error != nil) {
        if (error.code == -1009) {
            NSString *info = error.userInfo[NSLocalizedDescriptionKey];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:info
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:UM_Local(@"OK"), nil];
            [alertView show];
        }
    }
    
    [self updateTextField:error];
    if (self.currentIndexPath) {
        [self.mTableView reloadData];
    }
    
    [_feedback get];
}

#pragma mark - Keybaord Show Hide Notification

- (void)keyboardWillChangeFrameAction:(NSNotification*)aNotification {
}

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
        self.inputToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-self.inputToolBar.frame.size.height,  SCREEN_WIDTH,self.inputToolBar.frame.size.height);
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
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    CGRect frame = self.inputToolBar.frame;
//    
//    if (UM_IOS_8_OR_LATER) {
//        frame.origin.y = (self.view.frame.size.height - (isShow ? keyboardEndFrame.size.height : 0)) - self.inputToolBar.frame.size.height;
//    } else {
//        if (isShow) {
//            frame.origin.y = self.view.frame.size.height - keyboardFrame.size.height - frame.size.height;
//        } else {
//            frame.origin.y = self.view.frame.size.height - frame.size.height - self.topViewOffset;
//        }
//    }
//    self.inputToolBar.frame = frame;
    
    UIEdgeInsets inset = [self.mTableView contentInset];
    if (isShow) {
        inset.bottom = keyboardFrame.size.height + 10 + self.inputToolBar.frame.size.height - kMessagesInputToolbarHeightDefault;
    } else {
        inset.bottom = 10 + self.inputToolBar.frame.size.height - kMessagesInputToolbarHeightDefault;
    }
    [self.mTableView setContentInset:inset];
    
    if (isShow) {
        [self scrollToBottomAnimated:YES];
    }
    
    [UIView commitAnimations];
}

- (void)close:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
            [self scrollToBottomAnimated:NO];
        }
    }
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.mTableView numberOfRowsInSection:0] > 1)
    {
        NSUInteger lastRowNumber = [self.mTableView numberOfRowsInSection:0] - 1;
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [self.mTableView scrollToRowAtIndexPath:ip
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:animated];
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
    
    //    NSLog(@"%s: %f", __func__, dy);
    [self adjustInputToolbarHeightByDelta:dy];
    
    if (dy < 0) {
        [self scrollComposerTextViewToBottomAnimated:NO];
    }
}

- (void)adjustInputToolbarHeightByDelta:(CGFloat)dy
{
    NSInteger offset = dy;
    CGRect frame = self.inputToolBar.frame;
    frame.size.height += dy;
    if (frame.size.height < kMessagesInputToolbarHeightDefault) {
        dy = 0;
        frame.size.height = kMessagesInputToolbarHeightDefault;
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
    
    UIEdgeInsets inset =  self.mTableView.contentInset;
    // 当编辑框回位时，重置tableview bottom
    inset.bottom += (offset < 0) ? -inset.bottom : dy;
    [self.mTableView setContentInset:inset];
}

- (void)scrollComposerTextViewToBottomAnimated:(BOOL)animated
{
    UITextView *textView = self.inputToolBar.inputTextView;
    //    CGPoint contentOffsetToShowLastLine = CGPointMake(0.0f, textView.contentSize.height - CGRectGetHeight(textView.bounds));
    CGPoint contentOffsetToShowLastLine = textView.contentOffset;
    contentOffsetToShowLastLine.y = textView.contentSize.height - CGRectGetHeight(textView.bounds);
    
    [textView setContentOffset:contentOffsetToShowLastLine animated:animated];
}

#pragma mark - UITableView DataSource & Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = scrollView.contentOffset.x / SCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.isKeyboardShow) {
//        [self.view endEditing:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicAndReplies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *type = self.topicAndReplies[indexPath.row][@"type"];
    if([type isEqualToString:@"user_reply" ]) {
        static NSString *cellId = @"postCellId";
        UMPostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId
                                                                    forIndexPath:indexPath];
        NSString *isShow = [self.showTimes objectAtIndex:indexPath.row];
        [cell configCell:self.topicAndReplies[indexPath.row] showTime:isShow];
        return cell;
    }
    else {
        static NSString *cellId = @"chatCellId";
        UMChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId
                                                                    forIndexPath:indexPath];
        NSString *isShow = [self.showTimes objectAtIndex:indexPath.row];
        [cell configCell:self.topicAndReplies[indexPath.row] showTime:isShow];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentIndexPath = indexPath;
    if ([self.topicAndReplies[indexPath.row][@"is_failed"] boolValue]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:UM_Local(@"Send again?")
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:UM_Local(@"Cancel")
                                                  otherButtonTitles:UM_Local(@"Resend"), nil];
        [alertView show];
    } else {
    }
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSDictionary *info = self.topicAndReplies[self.mTableView.indexPathForSelectedRow.row];
        if ([self.delegate respondsToSelector:@selector(sendButtonPressed:)]) {
            [self.delegate sendButtonPressed:info];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *rowHeight;
    if (indexPath.row < [self.rowHeights count]) {
        rowHeight = [self.rowHeights objectAtIndex:indexPath.row];
    }
    if (rowHeight) {
        return [rowHeight floatValue];
    }
    NSString *content = self.topicAndReplies[indexPath.row][@"content"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.topicAndReplies[indexPath.row][@"created_at"] doubleValue] / 1000];
    NSString *strDate = [RYGDateUtility humanableInfoFromDate:date];
    
    CGFloat cellHeight = 0;
    if ([self.dicTime objectForKey:strDate]) {
        cellHeight = 15;
        [self.showTimes addObject:@"0"];
    }
    else {
        CGSize dateSize = RYG_TEXTSIZE(@"昨天", [UIFont systemFontOfSize:10]);
        cellHeight = 20 + dateSize.height + 10;
        [self.dicTime setObject:strDate forKey:strDate];
        [self.showTimes addObject:@"1"];
    }
    if (content.length > 0) {
        CGSize labelSize = RYG_MULTILINE_TEXTSIZE(content, [UIFont systemFontOfSize:14.0f], CGSizeMake((self.view.width - 39 - 42 - 4 - 20), FLT_MAX), NSLineBreakByTruncatingTail);
        
        if ((labelSize.height + 20) > 32) {
            cellHeight = labelSize.height + 20 + cellHeight;
        }
        else {
            cellHeight = 32 + cellHeight;
        }
         [self.rowHeights addObject:[NSNumber numberWithFloat:cellHeight + 2]];
        return cellHeight + 2;
    }
    return 0;
}

- (void)refreshData {
    if ([self.delegate respondsToSelector:@selector(reloadData)]) {
        [self.delegate reloadData];
    }
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
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

@end
