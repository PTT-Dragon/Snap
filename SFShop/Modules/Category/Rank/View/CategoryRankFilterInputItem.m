//
//  CategoryRankFilterInputItem.m
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import "CategoryRankFilterInputItem.h"

@interface CategoryRankFilterInputItem ()
@property (nonatomic, readwrite, strong) UITextField *minField;
@property (nonatomic, readwrite, strong) UIImageView *middleLineImageView;
@property (nonatomic, readwrite, strong) UITextField *maxField;
@end

@implementation CategoryRankFilterInputItem

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviews];
        [self latout];
    }
    return self;
}

- (void)loadSubviews {
    [self.contentView addSubview:self.minField];
    [self.contentView addSubview:self.middleLineImageView];
    [self.contentView addSubview:self.maxField];
}

- (void)latout {
    [self.minField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KScale(150));
    }];
    
    [self.middleLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minField.mas_left).offset(4);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    
    [self.minField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleLineImageView.mas_right).offset(4);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KScale(150));
    }];
}

#pragma mark - Getter
- (UIImageView *)middleLineImageView {
    if (_middleLineImageView == nil) {
        _middleLineImageView = [[UIImageView alloc] init];
        _middleLineImageView.image = [UIImage imageNamed:@"rank_price_interval"];
    }
    return _middleLineImageView;
}

- (UITextField *)minField {
    if (_minField == nil) {
        _minField = [[UITextField alloc] init];
        _minField.placeholder = @"Min";
        _minField.textColor = [UIColor blackColor];
        _minField.font = [UIFont systemFontOfSize:16];
    }
    return _minField;
}

- (UITextField *)maxField {
    if (_maxField == nil) {
        _maxField = [[UITextField alloc] init];
        _maxField.placeholder = @"Max";
        _maxField.textColor = [UIColor blackColor];
        _maxField.font = [UIFont systemFontOfSize:16];
    }
    return _minField;
}

@end
