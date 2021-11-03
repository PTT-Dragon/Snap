//
//  ProductCheckoutGoodsCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutGoodsCell.h"
#import "ProductCheckoutModel.h"
#import "NSString+Add.h"

@interface ProductCheckoutGoodsCell ()

@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UIImageView *icon;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *typeLabel;
@property (nonatomic, readwrite, strong) UILabel *priceLabel;
@property (nonatomic, readwrite, strong) UILabel *numLabel;

@end

@implementation ProductCheckoutGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadsubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.icon];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.typeLabel];
    [self.bgView addSubview:self.priceLabel];
    [self.bgView addSubview:self.numLabel];
}

- (void)layout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(90, 90));
        make.left.mas_equalTo(14);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(14);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.mas_equalTo(-20);
    }];
    
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(6);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo([self.typeLabel.text calWidthWithLabel:self.typeLabel] + 16);
    }];
    
    [self.numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(16);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(14);
    }];
    
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(16);
        make.left.equalTo(self.icon.mas_right).offset(10);
        make.right.lessThanOrEqualTo(self.numLabel.mas_left).offset(-10);
        make.height.mas_equalTo(14);
    }];
}

#pragma mark - Getter
- (void)setCellModel:(SFCellCacheModel *)cellModel {
    ProductCheckoutSubItemModel *model = cellModel.obj;
    self.titleLabel.text = model.productTitle;
    self.typeLabel.text = [NSString stringWithFormat:@"%@",model.productCategpry] ;
    self.priceLabel.text = [NSString stringWithFormat:@"%@ %f",model.priceRp,model.productPrice];
    self.numLabel.text = [NSString stringWithFormat:@"x%ld",model.productNum];
    [self layout];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] init];
        _icon.backgroundColor = [UIColor redColor];
    }
    return _icon;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"";
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"";
        _typeLabel.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _typeLabel.font = [UIFont systemFontOfSize:10];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _typeLabel.layer.borderWidth = 1;
    }
    return _typeLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"";
        _priceLabel.textColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        _priceLabel.font = [UIFont systemFontOfSize:12];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

- (UILabel *)numLabel {
    if (_numLabel == nil) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"";
        _numLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _numLabel.font = [UIFont systemFontOfSize:12];
        _numLabel.textAlignment = NSTextAlignmentRight;
    }
    return _numLabel;
}

@end
