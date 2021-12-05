//
//  ProductSpecAttrsView.m
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import "ProductSpecAttrsView.h"
#import "MakeH5Happy.h"
#import "NSString+Add.h"

@interface ProductSpecAttrsView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UIScrollView *attrsScrollView;
@property (nonatomic, strong) UIView *attrsScrollContentView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *decreaseBtn;
@property (nonatomic, strong) NSMutableArray<ProductAttrButton *> *selectedAttrBtn;

@end

@implementation ProductSpecAttrsView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.count = 1;
    self.selectedAttrBtn = [NSMutableArray array];
    self.selectedAttrValue = [NSMutableArray array];
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
    
    _attrsScrollContentView = [[UIView alloc] init];
    [_attrsScrollView addSubview:_attrsScrollContentView];
    [_attrsScrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_attrsScrollView);
        make.width.equalTo(self);
    }];
}

-(void)setModel:(ProductDetailModel *)model {
    _model = model;
    MPWeakSelf(self)
    [model.offerSpecAttrs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        // TODO: 此处默认选择第一个
        [weakself.selectedAttrValue addObject:@0];
    }];
    [self.imgView sd_setImageWithURL: [NSURL URLWithString: SFImage([MakeH5Happy getNonNullCarouselImageOf:self.model.carouselImgUrls[0]])]];
    self.titleLabel.text = model.offerName;
    self.priceLabel.text = [NSString stringWithFormat:@"Rp %ld", (long)model.salesPrice];
    // TODO: 此处先固定，后续根据库存接口数据调整
    self.stockLabel.text = @"stock: 25";
    
    __block UIView *preLayoutView = nil;
    NSArray<ProductAttrModel *> *attrs = model.offerSpecAttrs;
    [attrs enumerateObjectsUsingBlock:^(ProductAttrModel * _Nonnull obj, NSUInteger idx1, BOOL * _Nonnull stop) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = obj.attrName;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [weakself.attrsScrollContentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself.attrsScrollContentView).offset(16);
            make.top.equalTo(preLayoutView ? preLayoutView.mas_bottom : weakself.attrsScrollContentView).offset(10);
            make.height.mas_equalTo(20);
        }];
        preLayoutView = titleLabel;
        __block CGFloat xOffset = 16;
        __block BOOL newLine = YES;
        [obj.attrValues enumerateObjectsUsingBlock:^(ProductAttrValueModel * _Nonnull obj, NSUInteger idx2, BOOL * _Nonnull stop) {
            ProductAttrButton *item = [ProductAttrButton buttonWithType:UIButtonTypeCustom];
            BOOL isSelected = weakself.selectedAttrValue[idx1].integerValue == idx2;
            if (isSelected) {
                [weakself.selectedAttrBtn addObject:item];
            }
            [item addTarget:weakself action:@selector(selcteAttr:) forControlEvents:UIControlEventTouchUpInside];
            item.tag = idx1 * 100 + idx2;
            [item setSelected: isSelected];
            [item setTitle:obj.value forState:UIControlStateNormal];
            [weakself.attrsScrollContentView addSubview:item];
            CGFloat itemWidth = [obj.value calWidth:[UIFont systemFontOfSize:14] lineMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter limitSize:CGSizeMake(1000, 1000)] + 20; // 添加10的宽度做padding
            if(idx2 == 0 || xOffset + itemWidth + 16 > [[UIScreen mainScreen] bounds].size.width) {
                xOffset = 16;
                newLine = YES;
            } else {
                newLine = NO;
            }
            [item mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(weakself.attrsScrollContentView).offset(xOffset);
                make.size.mas_equalTo(CGSizeMake(itemWidth, 32));
                if (newLine) {
                    make.top.equalTo(preLayoutView.mas_bottom).offset(8);
                } else {
                    make.centerY.equalTo(preLayoutView);
                }
            }];
            xOffset += itemWidth + 8;
            preLayoutView = item;
        }];
    }];
    [preLayoutView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.attrsScrollContentView).offset(-10);
    }];
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

- (void)selcteAttr: (ProductAttrButton *)sender {
    NSUInteger sectionIndex = sender.tag / 100;
    ProductAttrButton *selectedBtn = self.selectedAttrBtn[sectionIndex];
    if (sender.tag == selectedBtn.tag) {
        return;
    }
    [selectedBtn setSelected:NO];
    [sender setSelected:YES];
    [self.selectedAttrBtn replaceObjectAtIndex:sectionIndex withObject:sender];
    self.selectedAttrValue[sectionIndex] = @(sender.tag % 100);
    if(self.chooseAttrBlock) {
        self.chooseAttrBlock();
    }
}


@end


@implementation ProductAttrButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self setTitleColor:[UIColor jk_colorWithHexString:@"#7b7b7b"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor jk_colorWithHexString:@"#ff1659"] forState:UIControlStateSelected];
    self.layer.borderColor = [UIColor jk_colorWithHexString:@"#c4c4c4"].CGColor;
    self.layer.borderWidth = 1;
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        self.layer.borderColor = [UIColor jk_colorWithHexString:@"#ff1659"].CGColor;
    } else {
        self.layer.borderColor = [UIColor jk_colorWithHexString:@"#c4c4c4"].CGColor;
    }
}


@end
