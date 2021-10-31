//
//  ProductSpecAttrsView.m
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import "ProductSpecAttrsView.h"
#import "MakeH5Happy.h"

@interface ProductSpecAttrsView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UIScrollView *attrsScrollView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) UIButton *decreaseBtn;

@end

@implementation ProductSpecAttrsView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.count = 1;
    [self setupSubViews];
    return self;
}

-(void)setupSubViews {
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self).offset(100);
    }];
    
    UIButton *dismissBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [contentView addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(15);
        make.right.equalTo(contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).offset(27);
        make.left.equalTo(contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(113, 113));
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:16];
    [_titleLabel setTextColor: [UIColor blackColor]];
    _titleLabel.numberOfLines = 2;
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imgView).offset(4);
        make.left.equalTo(_imgView.mas_right).offset(8);
        make.right.equalTo(dismissBtn.mas_left).offset(-18);
    }];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [_priceLabel setTextColor: [UIColor jk_colorWithHexString:@"#262626"]];
    _priceLabel.numberOfLines = 1;
    [self addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(6);
        make.left.equalTo(_imgView.mas_right).offset(8);
        make.right.equalTo(dismissBtn.mas_left).offset(-18);
    }];
    
    _stockLabel = [[UILabel alloc] init];
    _stockLabel.font = [UIFont boldSystemFontOfSize:12];
    [_stockLabel setTextColor: [UIColor jk_colorWithHexString:@"#555555"]];
    _stockLabel.numberOfLines = 1;
    [self addSubview:_stockLabel];
    [_stockLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLabel.mas_bottom).offset(6);
        make.left.equalTo(_imgView.mas_right).offset(8);
        make.right.equalTo(dismissBtn.mas_left).offset(-18);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor jk_colorWithHexString:@"#dddddd"];
    [self addSubview: line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(16);
        make.right.equalTo(contentView).offset(-16);
        make.bottom.equalTo(contentView).offset(-80);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *quantityLabel = [[UILabel alloc] init];
    quantityLabel.font = [UIFont boldSystemFontOfSize:16];
    [quantityLabel setTextColor: [UIColor blackColor]];
    quantityLabel.text = @"Quantity";
    [self addSubview:quantityLabel];
    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).offset(16);
        make.bottom.equalTo(contentView).offset(-30);
    }];
    
    UIButton *increaseBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [increaseBtn addTarget:self action:@selector(increase:) forControlEvents:UIControlEventTouchUpInside];
    [increaseBtn setTitle:@"+" forState:UIControlStateNormal];
    [increaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    increaseBtn.layer.borderWidth = 1;
    increaseBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#cccccc"].CGColor;
    increaseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:increaseBtn];
    [increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerY.equalTo(quantityLabel);
        make.right.equalTo(contentView).offset(-16);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont boldSystemFontOfSize:20];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_countLabel setTextColor: [UIColor blackColor]];
    _countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_count];
    [self addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(increaseBtn.mas_left).offset(-25);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(quantityLabel);
    }];

    _decreaseBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_decreaseBtn addTarget:self action:@selector(decrease:) forControlEvents:UIControlEventTouchUpInside];
    [_decreaseBtn setTitle:@"-" forState:UIControlStateNormal];
    _decreaseBtn.enabled = self.count > 1;
    [_decreaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _decreaseBtn.layer.borderWidth = 1;
    _decreaseBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#cccccc"].CGColor;
    _decreaseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_decreaseBtn];
    [_decreaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerY.equalTo(quantityLabel);
        make.right.equalTo(_countLabel.mas_left).offset(-25);
    }];
    
    _attrsScrollView = [[UIScrollView alloc] init];
    _attrsScrollView.showsVerticalScrollIndicator = YES;
    _attrsScrollView.alwaysBounceVertical = YES;
    [self addSubview:_attrsScrollView];
    [_attrsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(contentView);
        make.top.equalTo(_imgView.mas_bottom).offset(10);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
}

-(void)setModel:(ProductDetailModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL: [NSURL URLWithString: SFImage([MakeH5Happy getNonNullCarouselImageOf:self.model.carouselImgUrls[0]])]];
    self.titleLabel.text = model.offerName;
    self.priceLabel.text = [NSString stringWithFormat:@"Rp %ld", (long)model.salesPrice];
    // TODO: 此处先固定，后续根据库存接口数据调整
    self.stockLabel.text = @"stock: 25";
}

- (void)dismiss: (UIButton *)sender {
    if (_dismissBlock) {
        _dismissBlock();
    }
}

- (void)increase: (UIButton *)sender {
    self.count++;
    _decreaseBtn.enabled = self.count > 1;
    _countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_count];
}

- (void)decrease: (UIButton *)sender {
    self.count--;
    _decreaseBtn.enabled = self.count > 1;
    _countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_count];
    
}


@end
