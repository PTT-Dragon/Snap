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

@property (nonatomic, strong) UILabel *clearLabel;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIButton *clearBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *anchorImgView;

@property (nonatomic, strong) UILabel *anchorNameLabel;

@property (nonatomic, copy) NSString *currentTitle;

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
    [self initNotification];
}


#pragma mark - init

- (void)initView {
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.clearBtn];
    [self addSubview:self.clearLabel];
    [self addSubview:self.anchorImgView];
    [self addSubview:self.anchorNameLabel];
    self.clearBtn.hidden = YES;
    self.clearLabel.hidden = YES;
    self.anchorImgView.hidden = YES;
    self.anchorNameLabel.hidden = YES;
    [self addSubview:self.searchBtn];
    [self addSubview:self.shareBtn];
    [self addSubview:self.moreBtn];
    [self addSubview:self.lineView];
}

- (void)initLayout {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(20);
    }];
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(20);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.clearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.clearBtn.mas_right).offset(10);
        make.centerY.equalTo(self.clearBtn);
    }];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.right.mas_equalTo(self.mas_right).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.right.mas_equalTo(self.moreBtn.mas_left).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.right.mas_equalTo(self.shareBtn.mas_left).offset(-16);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(1);
    }];
    [self.anchorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(30);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(10);
        make.centerY.equalTo(self.backBtn);
    }];
    [self.anchorNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.anchorImgView.mas_right).offset(7);
        make.centerY.equalTo(self.anchorImgView);
        make.width.mas_equalTo(200);
    }];
}

- (void)initNotification {
    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(hiddenMoreView)
                                               name:@"KBaseMoreViewHidden"
                                             object:nil];
}

#pragma mark - config

- (void)configDataWithTitle:(NSString *)title {
    self.currentTitle = title;
    self.titleLabel.text = title;
}

- (void)updateIsOnlyShowMoreBtn:(BOOL)isOnly {
    if (isOnly) {
        self.searchBtn.hidden = YES;
        self.shareBtn.hidden = YES;
        self.moreBtn.hidden = NO;
    } else {
        self.searchBtn.hidden = NO;
        self.shareBtn.hidden = NO;
        self.moreBtn.hidden = NO;
    }
}

- (void)updateIsShowClearBtn:(BOOL)isOnly{
    
    if (isOnly) {
        self.searchBtn.hidden = YES;
        self.shareBtn.hidden = YES;
        self.moreBtn.hidden = NO;
        self.clearBtn.hidden = NO;
        self.clearLabel.hidden = NO;
    } else {
        self.searchBtn.hidden = NO;
        self.shareBtn.hidden = NO;
        self.moreBtn.hidden = NO;
        self.clearBtn.hidden = NO;
        self.clearLabel.hidden = NO;
    }
}
- (void)updateIsShowArticleTop:(BOOL)isOnly
{
    if (isOnly) {
        self.anchorImgView.hidden = NO;
        self.anchorNameLabel.hidden = NO;
        self.shareBtn.hidden = NO;
    } else {
        self.anchorImgView.hidden = NO;
        self.anchorNameLabel.hidden = NO;
        self.shareBtn.hidden = NO;
    }
}
- (void)configDataWithAnchorName:(NSString *)title anchorImgUrl:(NSString *)imgUrl
{
    self.anchorNameLabel.text = title;
    [self.anchorImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(imgUrl)]];
}
- (void)showMoreView {
    self.titleLabel.text = kLocalizedString(@"DIRECT_FUNCTION");
    self.backBtn.hidden = YES;
    self.moreBtn.selected = YES;
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.mas_left).offset(10);
    }];
}

- (void)hiddenMoreView {
    self.backBtn.hidden = NO;
    self.titleLabel.text = self.currentTitle;
    self.moreBtn.selected = NO;
    [self.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.mas_left).offset(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY).offset(statuBarHei/2);
        make.left.mas_equalTo(self.backBtn.mas_right).offset(20);
    }];
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
    if (self.moreBtn.isSelected) {
        [NSNotificationCenter.defaultCenter postNotificationName:@"KBaseNavViewHiddenMoreView"
                                                          object:self];
    } else {
        [self showMoreView];
        if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickMoreBtn:)]) {
            [self.delegate baseNavViewDidClickMoreBtn:self];
        }
    }
}

- (void)clearBtnAction {
    
    if ([self.delegate respondsToSelector:@selector(baseNavViewDidClickClearBtn:)]) {
        [self.delegate baseNavViewDidClickClearBtn:self];
    }
}

#pragma mark - setter
- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back"]
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
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)anchorNameLabel {
    if (!_anchorNameLabel) {
        _anchorNameLabel = [[UILabel alloc] init];
        _anchorNameLabel.textColor = UIColor.blackColor;
        _anchorNameLabel.font = [UIFont boldSystemFontOfSize:14];
    }
    return _anchorNameLabel;
}

- (UIImageView *)anchorImgView
{
    if (!_anchorImgView) {
        _anchorImgView = [[UIImageView alloc] init];
        _anchorImgView.contentMode = UIViewContentModeScaleToFill;
    }
    return _anchorImgView;
}
- (UILabel *)clearLabel {
    if (!_clearLabel) {
        _clearLabel = [[UILabel alloc] init];
        _clearLabel.textColor = RGBColorFrom16(0x555555);
        _clearLabel.font = [UIFont boldSystemFontOfSize:12];
        _clearLabel.text = @"mark all as read";
    }
    return _clearLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setImage:[UIImage imageNamed:@"clear-2"]
                   forState:UIControlStateNormal];
        [_clearBtn addTarget:self
                      action:@selector(clearBtnAction)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

- (UIButton *)moreBtn {
    if (!_moreBtn) {
        _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBtn setImage:[UIImage imageNamed:@"more-horizontal"]
                  forState:UIControlStateNormal];
        [_moreBtn setImage:[UIImage imageNamed:@"more-vertical"]
                  forState:UIControlStateSelected];
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

