//
//  ProductCheckoutDeliveryCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutDeliveryCell.h"

@interface ProductCheckoutDeliveryCell ()
@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *desLabel;
@property (nonatomic, readwrite, strong) UIButton *nextBtn;

@end

@implementation ProductCheckoutDeliveryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadubsviews];
        [self layout];
    }
    return self;
}

- (void)loadubsviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.desLabel];
    [self.bgView addSubview:self.nextBtn];
}

- (void)layout {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.nextBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(16);
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.nextBtn);
        make.right.equalTo(self.nextBtn.mas_left).offset(-1);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.nextBtn);
        make.left.mas_equalTo(20);
        make.right.lessThanOrEqualTo(self.priceLabel.mas_left).offset(-10);
    }];
    
    [self.desLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Getter
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    self.titleLabel.text = dataModel.deliveryTitle;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %f",dataModel.priceRp,dataModel.deliveryPrice];
    self.desLabel.text = dataModel.deliveryDes;
    [self layout];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"";
        _priceLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}

- (UILabel *)desLabel {
    if (_desLabel == nil) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.text = @"";
        _desLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _desLabel.font = [UIFont systemFontOfSize:12];
        _desLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _desLabel;
}

- (UIButton *)nextBtn {
    if (_nextBtn == nil) {
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setImage:[UIImage imageNamed:@"right-scroll"] forState:UIControlStateNormal];
    }
    return _nextBtn;
}

@end
