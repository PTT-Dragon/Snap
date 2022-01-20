//
//  BaseNavView.m
//  SFShop
//
//  Created by Lufer on 2022/1/20.
//

#import "BaseNavView.h"

@interface BaseNavView ()

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation BaseNavView

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
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.searchBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.moreBtn];
    [self addSubview:self.lineView];
}

- (void)initLayout {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_safeAreaLayoutGuideTop).offset(16);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn.mas_top);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(20);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn.mas_top);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn.mas_top);
        make.right.mas_equalTo(self.moreBtn.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backBtn.mas_top);
        make.right.mas_equalTo(self.shareBtn.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - config

- (void)configDataWithTitle:(NSString *)title {
    self.titleLabel.text = title;
}


#pragma mark - btnAction

- (void)backBtnAction {
    if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickBackBtn:)]) {
        [self.delegate baseNavViewDidClickBackBtn:self];
    }
}

- (void)searchBtnAction {
    if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickSearchBtn:)]) {
        [self.delegate baseNavViewDidClickSearchBtn:self];
    }
}

- (void)shareBtnAction {
    if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickShareBtn:)]) {
        [self.delegate baseNavViewDidClickShareBtn:self];
    }
}

- (void)moreBtnAction {
    if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickMoreBtn:)]) {
        [self.delegate baseNavViewDidClickMoreBtn:self];
    }
}

#pragma mark - function



#pragma mark - setter

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"ic_nav_back"]
                  forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(backBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = UIColor.blackColor;
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"more-horizontal"]
                  forState:UIControlStateNormal];
        [_moreBtn addTarget:self
                     action:@selector(moreBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"share"]
                  forState:UIControlStateNormal];
        [_shareBtn addTarget:self
                     action:@selector(shareBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setImage:[UIImage imageNamed:@"ic_nav_search"]
                  forState:UIControlStateNormal];
        [_searchBtn addTarget:self
                     action:@selector(searchBtnAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

@end
