//
//  ProductCheckoutAddressCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutAddressCell.h"

@interface ProductCheckoutAddressCell ()

@property (nonatomic, readwrite, strong) UIImageView *sectionImageView;
@property (nonatomic, readwrite, strong) UILabel *sectionTitle;
@property (nonatomic, readwrite, strong) UIView *sectionLine;
@property (nonatomic, readwrite, strong) UILabel *addressLabel;
@property (nonatomic, readwrite, strong) UIButton *addressExtend;
@property (nonatomic, readwrite, strong) UITextField *emailTF;

@end

@implementation ProductCheckoutAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadsubviews];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.sectionImageView];
    [self.contentView addSubview:self.sectionTitle];
    [self.contentView addSubview:self.sectionLine];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.addressExtend];
    [self.contentView addSubview:self.emailTF];
}

- (void)layout {
    [self.sectionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(16);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    
    [self.sectionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sectionImageView.mas_right).offset(4);
        make.top.bottom.equalTo(self.sectionImageView);
        make.right.mas_equalTo(-20);
    }];
    
    [self.sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionImageView.mas_bottom).offset(13);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionLine.mas_bottom).offset(16);
        make.left.equalTo(self.sectionImageView);
        make.right.mas_equalTo(-47);
    }];
    
    [self.addressExtend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self.emailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(12);
        make.left.equalTo(self.sectionImageView);
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

- (UIImageView *)sectionImageView {
    if (_sectionImageView == nil) {
        _sectionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        _sectionImageView.backgroundColor = [UIColor blackColor];
    }
    return _sectionImageView;
}

- (UIView *)sectionLine {
    if (_sectionLine == nil) {
        _sectionLine = [[UIView alloc] init];
        _sectionLine.backgroundColor = [UIColor jk_colorWithHexString:@"#F0F0F0"];
    }
    return _sectionLine;
}

- (UILabel *)sectionTitle {
    if (_sectionTitle == nil) {
        _sectionTitle = [[UILabel alloc] init];
        _sectionTitle.text = @"Delivery Address";
        _sectionTitle.textColor = [UIColor jk_colorWithHexString:@"#7B7B7B"];
        _sectionTitle.font = [UIFont boldSystemFontOfSize:11];
        _sectionTitle.textAlignment = NSTextAlignmentLeft;
        _sectionTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        _sectionTitle.numberOfLines = 1;
    }
    return _sectionTitle;
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

- (UITextField *)emailTF {
    if (_emailTF == nil) {
        _emailTF = [[UITextField alloc] init];
        _emailTF.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        _emailTF.borderStyle = UITextBorderStyleLine;
    }
    return _emailTF;
}

@end
