//
//  BaseMoreView.m
//  SFShop
//
//  Created by Lufer on 2022/1/21.
//

#import "BaseMoreView.h"
#import "UIButton+FFImagePosition.h"
#import "UIView+Response.h"
#import "MessageViewController.h"
#import "CartModel.h"

@interface BaseMoreView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *homeBtn;

@property (nonatomic, strong) UIButton *inboxBtn;

@property (nonatomic, strong) UIButton *accountBtn;

@property (nonatomic, strong) UIButton *mysfBtn;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic,strong)  UILabel *badgeLabel;

@end

@implementation BaseMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
    [self initLayout];
    [self initNotification];
    [self loadNoReadNumber];
}


#pragma mark - init

- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.homeBtn];
    [self.bgView addSubview:self.inboxBtn];
    [self.bgView addSubview:self.accountBtn];
    [self.bgView addSubview:self.mysfBtn];
    [self.bgView addSubview:self.badgeLabel];
    [self addSubview:self.maskView];
}

- (void)initLayout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(111);
    }];
    NSArray *btnArr = @[
        self.homeBtn,
        self.inboxBtn,
        self.accountBtn,
        self.mysfBtn
    ];
    [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                     withFixedItemLength:80
                             leadSpacing:10
                             tailSpacing:10];
    [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_top).offset(16);
        make.height.mas_equalTo(80);
    }];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
    [self.badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.inboxBtn.mas_right).offset(-AdaptedWidth(20));
        make.top.mas_equalTo(self.inboxBtn.mas_top).offset(10);
        make.height.mas_equalTo(15);
    }];
}

- (void)initNotification {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(cancel)
                                               name:@"KBaseNavViewHiddenMoreView"
                                             object:nil];
}

#pragma mark - loadData
- (void)loadNoReadNumber
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.account.messageNum parameters:@{} success:^(id  _Nullable response) {
        NSNumber *num = response;
        weakself.badgeLabel.text = [num.stringValue isEqualToString:@"0"] ? @"": [NSString stringWithFormat:@" %@ ",num.stringValue];
    } failed:^(NSError * _Nonnull error) {

    }];
}

#pragma mark - btnAction

- (void)homeBtnAction {
    [self cancel];
    UIViewController *vc = [baseTool getCurrentVC];
    [vc.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(aaa) withObject:nil afterDelay:0.1];
}
- (void)aaa
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
}
- (void)inboxBtnAction {
    [self cancel];
    MessageViewController *vc = [[MessageViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
//    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)accountBtnAction {
    [self cancel];
    UIViewController *vc = [baseTool getCurrentVC];
    [vc.navigationController popToRootViewControllerAnimated:YES];
    [self performSelector:@selector(bbb) withObject:nil afterDelay:0.1];
}
- (void)bbb
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:4];
}
- (void)mysfBtnAction {
    [self cancel];

}

- (void)tapAction {
    [self cancel];
}

- (void)cancel {
    self.hidden = YES;
    [NSNotificationCenter.defaultCenter postNotificationName:@"KBaseMoreViewHidden"
                                                      object:self];
}

#pragma mark - setter

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
    }
    return _bgView;
}

- (UIButton *)homeBtn {
    if (!_homeBtn) {
        _homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_homeBtn setImage:[UIImage imageNamed:@"ic_nav_more_home"]
                  forState:UIControlStateNormal];
        [_homeBtn setTitle:kLocalizedString(@"Home")
                  forState:UIControlStateNormal];
        [_homeBtn addTarget:self
                     action:@selector(homeBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
        [_homeBtn setTitleColor:UIColor.blackColor
                       forState:UIControlStateNormal];
        _homeBtn.titleLabel.font = kFontRegular(9);
        [_homeBtn setImagePosition:FFImagePositionTop
                           spacing:6];
    }
    return _homeBtn;
}

- (UIButton *)inboxBtn {
    if (!_inboxBtn) {
        _inboxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_inboxBtn setImage:[UIImage imageNamed:@"ic_nav_more_message"]
                   forState:UIControlStateNormal];
        [_inboxBtn setTitle:kLocalizedString(@"INBOX")
                   forState:UIControlStateNormal];
        [_inboxBtn addTarget:self
                      action:@selector(inboxBtnAction)
            forControlEvents:UIControlEventTouchUpInside];
        [_inboxBtn setTitleColor:UIColor.blackColor
                        forState:UIControlStateNormal];
        _inboxBtn.titleLabel.font = kFontRegular(9);
        [_inboxBtn setImagePosition:FFImagePositionTop
                            spacing:6];
    }
    return _inboxBtn;//MY_ACCOUNT
}

- (UIButton *)accountBtn {
    if (!_accountBtn) {
        _accountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountBtn setImage:[UIImage imageNamed:@"ic_nav_more_account"]
                     forState:UIControlStateNormal];
        [_accountBtn setTitle:kLocalizedString(@"Account")
                     forState:UIControlStateNormal];
        [_accountBtn addTarget:self
                        action:@selector(accountBtnAction)
              forControlEvents:UIControlEventTouchUpInside];
        [_accountBtn setTitleColor:UIColor.blackColor
                          forState:UIControlStateNormal];
        _accountBtn.titleLabel.font = kFontRegular(9);
        [_accountBtn setImagePosition:FFImagePositionTop
                              spacing:6];
    }
    return _accountBtn;
}

- (UIButton *)mysfBtn {
    if (!_mysfBtn) {
        _mysfBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mysfBtn setImage:[UIImage imageNamed:@"ic_nav_more_my"]
                  forState:UIControlStateNormal];
        [_mysfBtn setTitle:kLocalizedString(@"MY_SF")
                  forState:UIControlStateNormal];
        [_mysfBtn addTarget:self
                     action:@selector(mysfBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
        [_mysfBtn setTitleColor:UIColor.blackColor
                       forState:UIControlStateNormal];
        _mysfBtn.titleLabel.font = kFontRegular(9);
        [_mysfBtn setImagePosition:FFImagePositionTop
                           spacing:6];
        _mysfBtn.hidden = YES;
    }
    return _mysfBtn;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [[UIColor jk_colorWithHexString:@"000000"] colorWithAlphaComponent:0.3];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}
- (UILabel *)badgeLabel
{
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.backgroundColor = RGBColorFrom16(0xff1659);
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.textAlignment = NSTextAlignmentNatural;
        _badgeLabel.font = kFontRegular(10);
    }
    return _badgeLabel;
}

@end
