//
//  MessageListOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "MessageListOrderCell.h"

@interface MessageListOrderCell ()
@property (nonatomic,strong) UIImageView *storeImgView;
@property (nonatomic,strong) UILabel *storeNameLabel;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *rightImgView;
@property (nonatomic,strong) UIView *bgView;
@end

@implementation MessageListOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    self.contentView.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.contentView addSubview:self.bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(16);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-16);
        make.top.mas_equalTo(self.contentView.mas_top).offset(16);
        make.bottom.mas_equalTo(self.contentView);
    }];
    [_bgView addSubview:self.storeImgView];
    [_storeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.left.mas_equalTo(_bgView.mas_left).offset(12);
        make.top.mas_equalTo(_bgView.mas_top).offset(12);
    }];
    [_bgView addSubview:self.storeNameLabel];
    [_storeNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_storeImgView.mas_right).offset(4);
        make.centerY.equalTo(_storeImgView);
    }];
    [_bgView addSubview:self.imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56);
        make.left.mas_equalTo(_bgView.mas_left).offset(12);
        make.top.mas_equalTo(_bgView.mas_top).offset(56);
    }];
    [_bgView addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgView.mas_right).offset(12);
        make.right.mas_equalTo(_bgView.mas_right).offset(-12);
        make.top.equalTo(_imgView);
    }];
    [_bgView addSubview:self.contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_imgView.mas_right).offset(12);
        make.right.mas_equalTo(_bgView.mas_right).offset(-12);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(4);
        make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-17);
        make.height.mas_greaterThanOrEqualTo(55);
    }];
    [_bgView addSubview:self.rightImgView];
    [_rightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(16);
        make.right.mas_equalTo(_bgView.mas_right).offset(-12);
        make.centerY.equalTo(_storeNameLabel);
    }];
}
- (void)setModel:(MessageOrderListModel *)model
{
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.product.imgUrl)]];
    self.contentLabel.text = model.message.content;
    self.titleLabel.text = model.message.subject;
    self.storeNameLabel.text = model.store.storeName;
    [self.storeImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.store.logoUrl)]];
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = CHINESE_SYSTEM(14);
    }
    return _contentLabel;
}
- (UILabel *)storeNameLabel
{
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.font = CHINESE_MEDIUM(14);
    }
    return _storeNameLabel;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = CHINESE_MEDIUM(14);
    }
    return _titleLabel;
}
- (UIImageView *)storeImgView
{
    if (!_storeImgView) {
        _storeImgView = [[UIImageView alloc] init];
    }
    return _storeImgView;;
}
- (UIImageView *)rightImgView
{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-scroll"]];
    }
    return _rightImgView;;
}
@end
