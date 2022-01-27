//
//  ProductCheckoutAddressCell.m
//  SFShop
//
//  Created by MasterFly on 2021/10/31.
//

#import "ProductCheckoutAddressCell.h"
#import "CustomTextField.h"
#import "UIButton+EnlargeTouchArea.h"

@interface ProductCheckoutAddressCell ()<UITextFieldDelegate>

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

- (void)layoutSubviews{
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.mas_equalTo(-16);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.sectionLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-47);
    }];
    
    [self.addressExtend mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.addressLabel);
    }];
    
    [self.emailTF mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(-20);
    }];
}

- (void)loadsubviews {
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.sectionLine];
    [self.bgView addSubview:self.addressLabel];
    [self.bgView addSubview:self.addressExtend];
    [self.bgView addSubview:self.emailTF];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.dataModel.addressModel.email = textField.text;
}

#pragma mark - #EVENT
- (void)extendClick {
    !self.eventBlock?:self.eventBlock(self.dataModel,self.cellModel,ProductCheckoutCellEvent_GotoAddress);
}

#pragma mark - Getter & Setter
- (void)setDataModel:(ProductCheckoutModel *)dataModel {
    super.dataModel = dataModel;
    
    if (!self.dataModel.addressModel) {
        self.addressLabel.text = kLocalizedString(@"ADD_ADDRESS_TIPS");
        self.emailTF.hidden = YES;
    } else {
        self.emailTF.hidden = NO;
        if (dataModel.addressModel.email.length > 0) {
            self.emailTF.text = dataModel.addressModel.email;
        }
        self.addressLabel.text = dataModel.addressModel.customAddress;
    }

    [self layoutSubviews];
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
        [_addressExtend setEnlargeEdgeWithTop:10 right:10 bottom:10 left:200];
        [_addressExtend setImage:[UIImage imageNamed:@"right-scroll"] forState:UIControlStateNormal];
        [_addressExtend addTarget:self action:@selector(extendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressExtend;
}

- (CustomTextField *)emailTF {
    if (_emailTF == nil) {
        _emailTF = [[CustomTextField alloc] init];
        _emailTF.text = self.dataModel.addressModel.email;
        _emailTF.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _emailTF.font = [UIFont systemFontOfSize:12];
        _emailTF.backgroundColor = [UIColor jk_colorWithHexString:@"#F5F5F5"];
        _emailTF.delegate = self;
        _emailTF.placeholder = kLocalizedString(@"Please_enter_your_email");
    }
    return _emailTF;
}


@end
