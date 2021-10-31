//
//  ProductCheckoutAddressCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutAddressCell.h"
#import "CustomTextField.h"

@interface ProductCheckoutAddressCell ()

@property (nonatomic, readwrite, strong) UIView *bgView;
@property (nonatomic, readwrite, strong) UIView *sectionLine;
@property (nonatomic, readwrite, strong) UILabel *addressLabel;
@property (nonatomic, readwrite, strong) UIButton *addressExtend;
@property (nonatomic, readwrite, strong) CustomTextField *emailTF;

@end

@implementation ProductCheckoutAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        [self loadsubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.sectionLine];
    [self.bgView addSubview:self.addressLabel];
    [self.bgView addSubview:self.addressExtend];
    [self.bgView addSubview:self.emailTF];
}

- (void)layout {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionLine.mas_bottom).offset(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-47);
    }];
    
    [self.addressExtend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
    }];
}

#pragma mark - Getter & Setter
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    self.addressLabel.text = dataModel.address;
    self.emailTF.text = dataModel.email;
    [self layout];
}

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UIView *)sectionLine {
    if (_sectionLine == nil) {
        _sectionLine = [[UIView alloc] init];
        _sectionLine.backgroundColor = [UIColor jk_colorWithHexString:@"#F0F0F0"];
    }
    return _sectionLine;
}

- (UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.text = @"";
        _addressLabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _addressLabel.font = [UIFont boldSystemFontOfSize:12];
        _addressLabel.textAlignment = NSTextAlignmentLeft;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}

- (UIButton *)addressExtend {
    if (_addressExtend == nil) {
        _addressExtend = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addressExtend jk_setBackgroundColor:[UIColor jk_colorWithHexString:@"#000000"] forState:UIControlStateNormal];
//        [_addressExtend setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_addressExtend addTarget:self action:@selector(extendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressExtend;
}

- (CustomTextField *)emailTF {
    if (_emailTF == nil) {
        _emailTF = [[CustomTextField alloc] init];
        _emailTF.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _emailTF.font = [UIFont systemFontOfSize:12];
        _emailTF.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
    }
    return _emailTF;
}

@end
