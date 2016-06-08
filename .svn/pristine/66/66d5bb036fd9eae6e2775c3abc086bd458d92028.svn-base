//
//  UMTextView.m
//  UMFeedback
//
//  Created by amoblin on 14/10/9.
//
//

#import "UMTextView.h"
#import "UMOpenMacros.h"

NSString * const UMTextViewSelectionDidChangeNotification = @"com.umeng.TextViewController.TextView.DidChangeSelection";
NSString * const UMTextViewContentSizeDidChangeNotification = @"com.umeng.TextViewController.TextView.DidChangeContentSize";


@interface UMTextView ()
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation UMTextView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.layer.borderWidth = 0.5f;
    self.layer.borderColor = [ColorAttionunCanBackground CGColor];
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;

    // reference to iMessage UI
    self.font = [UIFont systemFontOfSize:14.0];

    self.editable = YES;
    self.scrollEnabled = YES;
    self.scrollsToTop = NO;
    self.directionalLockEnabled = YES;
    self.dataDetectorTypes = UIDataDetectorTypeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeTextView:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:nil];
    
    [self addObserver:self
           forKeyPath:NSStringFromSelector(@selector(contentSize))
              options:NSKeyValueObservingOptionNew
              context:NULL];

    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.hidden = NO;
        [self sendSubviewToBack:self.placeholderLabel];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self scrollsToTop];
}

- (UILabel *)placeholderLabel
{
    if (!_placeholderLabel)
    {
        CGSize size = RYG_TEXTSIZE(@"回复", self.font);
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, (self.height - size.height) / 2, 250, size.height)];
        _placeholderLabel.clipsToBounds = NO;
        _placeholderLabel.autoresizesSubviews = NO;
        _placeholderLabel.numberOfLines = 1;
        _placeholderLabel.font = self.font;
        _placeholderLabel.backgroundColor = [UIColor clearColor];
        _placeholderLabel.textColor = ColorRankMedal;
        _placeholderLabel.hidden = NO;
        [self addSubview:_placeholderLabel];
    }
    return _placeholderLabel;
}

- (UIColor *)placeholderColor
{
    return self.placeholderLabel.textColor;
}

#pragma mark - Setters

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)color
{
    self.placeholderLabel.textColor = color;
}

#pragma mark - Overrides

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - Observers & Notifications

- (void)didChangeTextView:(NSNotification *)notification
{
    if (self.placeholder.length > 0) {
        self.placeholderLabel.hidden = (self.text.length > 0) ? YES : NO;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isEqual:self] && [keyPath isEqualToString:NSStringFromSelector(@selector(contentSize))]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:UMTextViewContentSizeDidChangeNotification object:self userInfo:nil];
    }
}

- (void)dealloc {
#if __has_feature(objc_arc)
#else
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize))];
    
    _placeholderLabel = nil;
}
@end
