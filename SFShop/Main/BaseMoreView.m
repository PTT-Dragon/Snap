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

@interface BaseMoreView ()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *homeBtn;

@property (nonatomic, strong) UIButton *inboxBtn;

@property (nonatomic, strong) UIButton *accountBtn;

@property (nonatomic, strong) UIButton *mysfBtn;

@property (nonatomic, strong) UIView *maskView;

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
}


#pragma mark - init

- (void)initView {
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.homeBtn];
    [self.bgView addSubview:self.inboxBtn];
    [self.bgView addSubview:self.accountBtn];
    [self.bgView addSubview:self.mysfBtn];
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
}


#pragma mark - btnAction

- (void)homeBtnAction {
    self.hidden = YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)inboxBtnAction {
    self.hidden = YES;
    MessageViewController *vc = [[MessageViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

- (void)accountBtnAction {
    self.hidden = YES;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:4];
    [self.parentViewController.navigationController popToRootViewControllerAnimated:YES];
}

- (void)mysfBtnAction {
    self.hidden = YES;

}

- (void)tapAction {
    self.hidden = YES;
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
        _homeBtn.titleLabel.font = [UIFont systemFontOfSize:9];
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
        [_inboxBtn setTitle:kLocalizedString(@"Message")
                   forState:UIControlStateNormal];
        [_inboxBtn addTarget:self
                      action:@selector(inboxBtnAction)
            forControlEvents:UIControlEventTouchUpInside];
        [_inboxBtn setTitleColor:UIColor.blackColor
                        forState:UIControlStateNormal];
        _inboxBtn.titleLabel.font = [UIFont systemFontOfSize:9];
        [_inboxBtn setImagePosition:FFImagePositionTop
                            spacing:6];
    }
    return _inboxBtn;
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
        _accountBtn.titleLabel.font = [UIFont systemFontOfSize:9];
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
        _mysfBtn.titleLabel.font = [UIFont systemFontOfSize:9];
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

@end
