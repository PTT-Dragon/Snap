//
//  CategoryRankFilterInputItem.m
//  SFShop
//
//  Created by MasterFly on 2021/10/23.
//

#import "CategoryRankFilterInputItem.h"
#import "CustomTextField.h"

@interface CategoryRankFilterInputItem ()<UITextFieldDelegate>
@property (nonatomic, readwrite, strong) CustomTextField *minField;
@property (nonatomic, readwrite, strong) UIImageView *middleLineImageView;
@property (nonatomic, readwrite, strong) CustomTextField *maxField;
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
        make.top.mas_equalTo(3);
        make.bottom.mas_equalTo(-3);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(KScale(150));
    }];
    
    [self.middleLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minField.mas_right).offset(4);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(24);
        make.width.mas_equalTo(24);
    }];
    
    [self.maxField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.middleLineImageView.mas_right).offset(4);
        make.top.mas_equalTo(3);
        make.bottom.mas_equalTo(-3);
        make.width.mas_equalTo(KScale(150));
    }];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (textField.text && ![textField.text isEqualToString:@""]) {
        if (textField == self.minField) {
            !self.priceIntervalBlock ?: self.priceIntervalBlock(textField.text.intValue,YES);
        } else if (textField == self.maxField) {
            !self.priceIntervalBlock ?: self.priceIntervalBlock(textField.text.intValue,NO);
        }
    }
}

#pragma mark - Getter
- (void)setModel:(CategoryRankPriceModel *)model {
    _model = model;
    self.minField.text = _model.minPriceGinseng;
    self.maxField.text = _model.maxPriceGinseng;
}

- (UIImageView *)middleLineImageView {
    if (_middleLineImageView == nil) {
        _middleLineImageView = [[UIImageView alloc] init];
        _middleLineImageView.image = [UIImage imageNamed:@"rank_price_interval"];
    }
    return _middleLineImageView;
}

- (CustomTextField *)minField {
    if (_minField == nil) {
        _minField = [[CustomTextField alloc] init];
        _minField.userInteractionEnabled = YES;
        _minField.placeholder = kLocalizedString(@"Min");
        _minField.textColor = [UIColor blackColor];
        _minField.font = [UIFont systemFontOfSize:16];
        _minField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        _minField.layer.borderWidth = 1;
        _minField.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _minField.delegate = self;
    }
    return _minField;
}

- (CustomTextField *)maxField {
    if (_maxField == nil) {
        _maxField = [[CustomTextField alloc] init];
        _maxField.placeholder = kLocalizedString(@"Max");
        _maxField.textColor = [UIColor blackColor];
        _maxField.font = [UIFont systemFontOfSize:16];
        _maxField.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
        _maxField.layer.borderWidth = 1;
        _maxField.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _maxField.delegate = self;
    }
    return _maxField;
}

@end
