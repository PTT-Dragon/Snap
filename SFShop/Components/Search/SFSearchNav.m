//
//  SFSearchNav.m
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import "SFSearchNav.h"
#import "CustomTextField.h"
#import "SFSearchView.h"

@interface SFSearchNav ()<UITextFieldDelegate>
@property (nonatomic, readwrite, strong) SFSearchItem *bItem;
@property (nonatomic, readwrite, strong) SFSearchItem *rItem;
@property (nonatomic, readwrite, strong) UIButton *backBtn;
@property (nonatomic, readwrite, strong) CustomTextField *textField;
@property (nonatomic, readwrite, strong) UIButton *rightBtn;
@property (nonatomic, readwrite, strong) SFSearchView *searchView;
@property (nonatomic, readwrite, copy) void(^searchBlock)(NSString *qs);

@end
@implementation SFSearchNav

- (instancetype)initWithFrame:(CGRect)frame backItme:(SFSearchItem *)bItem rightItem:(SFSearchItem *)rItem searchBlock:(nonnull void (^)(NSString *qs))searchBlock {
    if (self = [super initWithFrame:frame]) {
        _searchBlock = searchBlock;
        _bItem = bItem;
        _rItem = rItem;
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)loadsubviews {
    [self addSubview:self.backBtn];
    [self addSubview:self.textField];
    [self addSubview:self.rightBtn];
}

- (void)layout {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(10);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(-27);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.right.equalTo(self.rightBtn.mas_left).offset(-18);
        make.left.equalTo(self.backBtn.mas_right).offset(12);
        make.height.mas_equalTo(35);
    }];
}

#pragma mark - Event
- (void)btnClick:(UIButton *)btn {
    if (btn == self.backBtn) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if ([window.subviews containsObject:self.searchView]) {
            [self.searchView removeFromSuperview];
            [self endEditing:YES];
        } else {
            !self.bItem.itemActionBlock ?: self.bItem.itemActionBlock(nil);
        }
    } else if (btn == self.rightBtn) {
        !self.rItem.itemActionBlock ?: self.rItem.itemActionBlock(nil);
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (![window.subviews containsObject:self.searchView]) {
        [window addSubview:self.searchView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search:textField.text];
    return YES;
}

- (void)search:(NSString *)qs {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if ([window.subviews containsObject:self.searchView]) {
        [self.searchView removeFromSuperview];
    }
    !self.searchBlock ?: self.searchBlock(qs);
    [self endEditing:YES];
}

#pragma mark - Getter
- (SFSearchView *)searchView {
    if (_searchView == nil) {
        _searchView = [[SFSearchView alloc] initWithFrame:CGRectMake(0, 10 + navBarHei, MainScreen_width, MainScreen_height - (10 + navBarHei))];
        __weak __typeof (self)weakSelf = self;
        _searchView.searchBlock = ^(NSString *qs) {
            __weak __typeof (weakSelf)strongSelf = weakSelf;
            [strongSelf search:qs];
        };
    }
    return _searchView;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:_bItem.name forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:_bItem.icon] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (CustomTextField *)textField {
    if (_textField == nil) {
        _textField = [[CustomTextField alloc] init];
        _textField.delegate = self;
        _textField.font = [UIFont systemFontOfSize:16];
        _textField.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.returnKeyType = UIReturnKeySearch;
    }
    return _textField;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitle:_rItem.name forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:_rItem.icon] forState:UIControlStateNormal];
    }
    return _rightBtn;
}

@end
