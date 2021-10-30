//
//  SFSearchSectionHeadView.m
//  SFShop
//
//  Created by MasterFly on 2021/10/28.
//

#import "SFSearchSectionHeadView.h"
#import "UIButton+EnlargeTouchArea.h"

@interface SFSearchSectionHeadView ()
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UIButton *rightBtn;
@end

@implementation SFSearchSectionHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self layout];
    }
    return self;
}

- (void)loadSubviews {
    [self addSubview:self.titleLabel];
    [self addSubview:self.rightBtn];
}

- (void)layout {
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-16);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.centerY.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.bottom.mas_equalTo(0);
        make.right.lessThanOrEqualTo(self.rightBtn.mas_left).offset(-10);
    }];
}

#pragma mark - Event
- (void)btnClick {
    !self.rightBlock ?: self.rightBlock(self.model);
}

#pragma mark - Getter
- (void)setModel:(SFSearchModel *)model {
    _model = model;
    self.titleLabel.text = model.sectionTitle;
    [self.rightBtn setImage:[UIImage imageNamed:model.sectionIcon] forState:UIControlStateNormal];
    switch (model.type) {
        case SFSearchHeadTypeDelete:
            self.rightBtn.hidden = NO;
            break;
        case SFSearchHeadTypeNormal:
        default:
            self.rightBtn.hidden = YES;
            break;
    }
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _titleLabel;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.hidden = YES;
        [_rightBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
    }
    return _rightBtn;
}

@end
