//
//  ProductSpecAttrsView.m
//  SFShop
//
//  Created by Jacue on 2021/10/30.
//

#import "ProductSpecAttrsView.h"
#import "MakeH5Happy.h"
#import "SysParamsModel.h"
#import "NSString+Fee.h"


@interface ProductSpecAttrsView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *stockLabel;
@property (nonatomic, strong) UIScrollView *attrsScrollView;
@property (nonatomic, strong) UIView *attrsScrollContentView;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIButton *decreaseBtn;
@property (nonatomic, strong) UIButton *increaseBtn;
@property (nonatomic, strong) NSMutableArray<ProductAttrButton *> *selectedAttrBtn;
@property (nonatomic,strong) UIButton *btn1;
@property (nonatomic,strong) UIButton *btn2;
@property (nonatomic,strong) UIView *groupView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *groupLabel;
@property (nonatomic,strong) UILabel *groupCountLabel;
@property (nonatomic,strong) UILabel *maxPurchaseLabel;
@property (nonatomic,assign) NSInteger maxPurchaseCount;//团购最多可买数量
@property (nonatomic,strong) SingleProductStockModel *selStockModel;//选中的stockmodel


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
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(self).offset(100);
    }];
    
    UIButton *dismissBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [dismissBtn addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [dismissBtn setImage:[UIImage imageNamed:@"nav_close"] forState:UIControlStateNormal];
    [_contentView addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(15);
        make.right.equalTo(_contentView).offset(-15);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    _imgView = [[UIImageView alloc] init];
    [self addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentView).offset(27);
        make.left.equalTo(_contentView).offset(16);
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
    [_priceLabel setTextColor: [UIColor jk_colorWithHexString:@"#ff1659"]];
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
        make.left.equalTo(_contentView).offset(16);
        make.right.equalTo(_contentView).offset(-16);
        make.bottom.equalTo(_contentView).offset(-180);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *quantityLabel = [[UILabel alloc] init];
    quantityLabel.font = [UIFont boldSystemFontOfSize:16];
    [quantityLabel setTextColor: [UIColor blackColor]];
    quantityLabel.text = kLocalizedString(@"Quantity");
    [self addSubview:quantityLabel];
    [quantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_contentView).offset(16);
        make.bottom.equalTo(_contentView).offset(-130);
    }];
    
    _increaseBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_increaseBtn addTarget:self action:@selector(increase:) forControlEvents:UIControlEventTouchUpInside];
    [_increaseBtn setTitle:@"+" forState:UIControlStateNormal];
    [_increaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [_increaseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_increaseBtn jk_setBackgroundColor:[UIColor jk_colorWithHexString:@"F5F5F5"] forState:UIControlStateDisabled];
    [_increaseBtn jk_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _increaseBtn.layer.borderWidth = 1;
    _increaseBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#cccccc"].CGColor;
    _increaseBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_increaseBtn];
    [_increaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.centerY.equalTo(quantityLabel);
        make.right.equalTo(_contentView).offset(-16);
    }];
    
    _countLabel = [[UILabel alloc] init];
    _countLabel.font = [UIFont boldSystemFontOfSize:20];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    [_countLabel setTextColor: [UIColor blackColor]];
    _countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)_count];
    [self addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.increaseBtn.mas_left).offset(-25);
        make.width.mas_equalTo(40);
        make.centerY.equalTo(quantityLabel);
    }];

    _decreaseBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [_decreaseBtn addTarget:self action:@selector(decrease:) forControlEvents:UIControlEventTouchUpInside];
    [_decreaseBtn setTitle:@"-" forState:UIControlStateNormal];
    [_decreaseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_decreaseBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [_decreaseBtn jk_setBackgroundColor:[UIColor jk_colorWithHexString:@"F5F5F5"] forState:UIControlStateDisabled];
    [_decreaseBtn jk_setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_imgView.mas_bottom).offset(10);
        make.bottom.equalTo(line.mas_top).offset(-10);
    }];
    
    _attrsScrollContentView = [[UIView alloc] init];
    [_attrsScrollView addSubview:_attrsScrollContentView];
    [_attrsScrollContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_attrsScrollView);
        make.width.equalTo(self);
        make.top.bottom.equalTo(_attrsScrollView);
    }];
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.backgroundColor = RGBColorFrom16(0xFF1659);
    [_btn1 setTitle:@"立即购买" forState:0];
    _btn1.titleLabel.font = [UIFont fontWithName:@"semiblod" size:15];
    [_btn1 setTitleColor:[UIColor whiteColor] forState:0];
    [_btn1 addTarget:self action:@selector(gotoBuyOrCart:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_btn1];
    [_btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_contentView.mas_right).offset(-16);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo((MainScreen_width-52)/2);
        make.bottom.equalTo(_contentView).offset(-44);
    }];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn2 addTarget:self action:@selector(gotoBuyOrCart:) forControlEvents:UIControlEventTouchUpInside];
    [_btn2 jk_setBackgroundColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [_btn2 setTitle:@"加入购物车" forState:0];
    _btn2.titleLabel.font = [UIFont fontWithName:@"semiblod" size:15];
    [_btn2 setTitleColor:RGBColorFrom16(0xFF1659) forState:0];
    _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
    _btn2.layer.borderWidth = 1;
    [self addSubview:_btn2];
    [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_contentView.mas_left).offset(16);
        make.height.mas_equalTo(46);
        make.width.mas_equalTo((MainScreen_width-52)/2);
        make.bottom.equalTo(_contentView).offset(-44);
    }];
    _maxPurchaseLabel = [[UILabel alloc] init];
    _maxPurchaseLabel.textColor = RGBColorFrom16(0x999999);
    _maxPurchaseLabel.font = CHINESE_SYSTEM(12);
    [self addSubview:_maxPurchaseLabel];
    [_maxPurchaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(quantityLabel);
        make.top.mas_equalTo(quantityLabel.mas_bottom).offset(5);
    }];
    
    _groupView = [[UIView alloc] init];
    _groupView.backgroundColor = RGBColorFrom16(0xFFE5EB);
    [self addSubview:_groupView];
    [_groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_stockLabel);
        make.top.mas_equalTo(_stockLabel.mas_bottom).offset(8);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(18);
    }];
    UIView *darkView = [[UIView alloc] init];
    darkView.backgroundColor = RGBColorFrom16(0xFF1659);
    [_groupView addSubview:darkView];
    [darkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(_groupView);
        make.width.mas_equalTo(35);
    }];
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"00005_01_users_outline"];
    [_groupView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(11);
        make.left.mas_equalTo(_groupView.mas_left).offset(4);
        make.centerY.equalTo(_groupView);
    }];
    _groupCountLabel = [[UILabel alloc] init];
    _groupCountLabel.font = CHINESE_SYSTEM(10);
    _groupCountLabel.textColor = [UIColor whiteColor];
    [_groupView addSubview:_groupCountLabel];
    [_groupCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgView.mas_right).offset(5);
        make.centerY.equalTo(_groupView);
    }];
    _groupLabel = [[UILabel alloc] init];
    _groupLabel.font = CHINESE_SYSTEM(10);
    _groupLabel.textColor = RGBColorFrom16(0xFF1659);
    _groupLabel.text = kLocalizedString(@"SHAREBUY");
    [_groupView addSubview:_groupLabel];
    [_groupLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(darkView.mas_right).offset(5);
        make.centerY.equalTo(_groupView);
    }];
}
- (void)updateView
{
    if (self.stockModel.count == 0 || self.maxPurchaseCount == 0) {
        _btn2.hidden = YES;
        [_btn1 setTitle:kLocalizedString(@"OUT_OF_STOCK_IN_CURRENT_REGION") forState:0];
        [_btn1 jk_setBackgroundColor: RGBColorFrom16(0xFFE5EB) forState:UIControlStateNormal];
        [_btn1 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.bottom.equalTo(self).offset(-44);
        }];
    }
    if (_attrsType == buyType) {
        _btn2.hidden = YES;
        _btn1.tag = buyType + 100;
        [_btn1 setTitle:kLocalizedString(@"BUY_NOW") forState:0];
        [_btn1 jk_setBackgroundColor: RGBColorFrom16(0xFF1659) forState:UIControlStateNormal];
        [_btn1 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.bottom.equalTo(self).offset(-44);
        }];
    }else if (_attrsType == cartType){
        _btn2.hidden = YES;
        [_btn1 setTitle:kLocalizedString(@"ADD_TO_CART") forState:0];
        _btn1.tag = cartType + 100;
        [_btn1 jk_setBackgroundColor: RGBColorFrom16(0xFF1659) forState:UIControlStateNormal];
        [_btn1 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.bottom.equalTo(self).offset(-44);
        }];
    }else if (_attrsType == groupBuyType){
        _btn2.hidden = YES;
        [_btn1 jk_setBackgroundColor: RGBColorFrom16(0xFF1659) forState:UIControlStateNormal];
        [_btn1 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        _btn1.tag = groupBuyType + 100;
        [_btn1 setTitle:kLocalizedString(@"SHAREBUY") forState:0];
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.bottom.equalTo(self).offset(-44);
        }];
    }else if (_attrsType == groupSingleBuyType){
        _btn2.hidden = NO;
        [_btn1 jk_setBackgroundColor: RGBColorFrom16(0xFF1659) forState:UIControlStateNormal];
        [_btn1 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        [_btn2 jk_setBackgroundColor:RGBColorFrom16(0xFFE5EB) forState:UIControlStateDisabled];
        _btn1.tag = groupSingleBuyType + 100;
        _btn2.tag = cartType + 100;
        [_btn1 setTitle:kLocalizedString(@"BUY_NOW") forState:0];
        [_btn2 setTitle:kLocalizedString(@"ADD_TO_CART") forState:0];
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo((MainScreen_width-52)/2);
            make.bottom.equalTo(self).offset(-44);
        }];
        [_btn2 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.height.mas_equalTo(46);
            make.width.mas_equalTo((MainScreen_width-52)/2);
            make.bottom.equalTo(self).offset(-44);
        }];
    }
    // ====== 处理活动信息 ======
    MPWeakSelf(self)
    ProductCampaignsInfoModel * camaignsInfo = [self.campaignsModel yy_modelCopy];
    camaignsInfo.cmpFlashSales = [camaignsInfo.cmpFlashSales jk_filter:^BOOL(FlashSaleDateModel *object) {
        return object.productId.integerValue == weakself.selProductModel.productId;
    }];
    __block NSInteger groupCount = 0;
    BOOL isGroupBuy = [camaignsInfo.cmpShareBuys jk_filter:^BOOL(cmpShareBuysModel *object) {
        if (object.productId.integerValue == weakself.selProductModel.productId) {
            groupCount = object.shareByNum;
            self.maxPurchaseCount = object.buyAmtLimit;
        }
        return object.productId.integerValue == weakself.selProductModel.productId;
    }].count > 0;
    if (isGroupBuy) {
        _groupCountLabel.text = [NSString stringWithFormat:@"%ld",groupCount];
        _maxPurchaseLabel.text = [NSString stringWithFormat:@"Max purchase quantity %ld", self.maxPurchaseCount];

        self.groupView.hidden = NO;
    }else{
        self.groupView.hidden = YES;
    }
    //更新商量购买按钮状态和显示
    [self updateQuantityState];
    //更新按钮点击状态,没有库存时,不让点击
    [self updateBuyState];
}

- (void)setSelProductModel:(ProductItemModel *)selProductModel {
    _selProductModel = selProductModel;
    
    [self.imgView sd_setImageWithURL: [NSURL URLWithString: SFImage(selProductModel.imgUrl)]];
    self.titleLabel.text = selProductModel.productName;
    self.priceLabel.text = [[NSString stringWithFormat:@"%ld", (long)selProductModel.salesPrice] currency];
    self.maxPurchaseCount = _selProductModel.maxBuyCount ? selProductModel.maxBuyCount.integerValue : 100000;
    self.maxPurchaseLabel.text = self.maxPurchaseCount == 100000 ? @"": [NSString stringWithFormat:@"Max purchase quantity %ld", self.maxPurchaseCount];
}

- (void)setStockModel:(NSArray<ProductStockModel *> *)stockModel {
    _stockModel = stockModel;
    [stockModel enumerateObjectsUsingBlock:^(ProductStockModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.products enumerateObjectsUsingBlock:^(SingleProductStockModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            if (obj1.productId.integerValue == self.selProductModel.productId) {
                self.selStockModel = obj1;
                self.stockLabel.text = [obj1.stock isEqualToString:@"0"] ? kLocalizedString(@"OUT_OF_STOCK"): [NSString stringWithFormat:@"%@: %@", kLocalizedString(@"STOCK"),obj1.stock];
                *stop = YES;
                *stop1 = YES;
            }
        }];
    }];
    [self updateView];
}

-(void)setModel:(ProductDetailModel *)model {
    _model = model;
    MPWeakSelf(self)
    [model.offerSpecAttrs enumerateObjectsUsingBlock:^(ProductAttrModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj.attrValues enumerateObjectsUsingBlock:^(ProductAttrValueModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
            [weakself.selProductModel.prodSpcAttrs enumerateObjectsUsingBlock:^(ProdSpcAttrsModel * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
                if ([obj.attrName isEqualToString:obj2.attrName] && [obj1.value isEqualToString:obj2.value]) {
                    [weakself.selectedAttrValue addObject:@(idx1)];
                }
            }];
        }];
    }];
    
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

- (void)gotoBuyOrCart:(UIButton *)btn {
    !self.buyOrCartBlock ?: self.buyOrCartBlock(btn.tag - 100);
}

- (void)increase:(UIButton *)sender {
    self.count++;
    [self updateQuantityState];
}

- (void)decrease:(UIButton *)sender {
    self.count--;
    [self updateQuantityState];
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
    
//    self.selProductModel = self.model.products[sender.tag % 100];
    NSMutableArray *selectedAttrValueString = [NSMutableArray array];
    [self.model.offerSpecAttrs enumerateObjectsUsingBlock:^(ProductAttrModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedAttrValueString addObject: obj.attrValues[self.selectedAttrValue[idx].integerValue].value];
    }];
    self.selProductModel = [self.model.products jk_filter:^BOOL(ProductItemModel *object) {
        __block BOOL match = YES;
        [selectedAttrValueString enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *matchSpecs = [object.prodSpcAttrs jk_filter:^BOOL(ProdSpcAttrsModel *object1) {
                return [object1.value isEqualToString:obj];
            }];
            if (matchSpecs.count < 1) {
                match = NO;
                *stop = YES;
            }
        }];
        return match;
    }].firstObject;

    // 此处为了刷新库存
    self.stockModel = self.stockModel;
    
    //重置当前选中数量,并更新商量购买按钮状态和显示
    self.count = 1;
    [self updateQuantityState];
    
    //更新按钮点击状态,没有库存时,不让点击
    [self updateBuyState];
    
    if(self.chooseAttrBlock) {
        self.chooseAttrBlock();
    }
}

- (void)updateBuyState {
    if (MIN(self.maxPurchaseCount, self.selStockModel.stock.intValue) > 0) {
        self.btn1.enabled = YES;
        self.btn2.enabled = YES;
    } else {
        [self.btn1 setTitle:kLocalizedString(@"OUT_OF_STOCK_IN_CURRENT_REGION") forState:0];
        self.btn1.enabled = NO;
        self.btn2.enabled = NO;
        self.btn2.hidden = YES;
        [_btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(16);
            make.right.mas_equalTo(self.mas_right).offset(-16);
            make.height.mas_equalTo(46);
            make.bottom.equalTo(self).offset(-44);
        }];
    }
}

- (void)updateQuantityState {
    if (self.maxPurchaseCount) {
        self.increaseBtn.enabled = (self.count < MIN(self.maxPurchaseCount, self.selStockModel.stock.intValue));
    } else {
        self.increaseBtn.enabled = (self.count < self.selStockModel.stock.integerValue);
    }
    self.decreaseBtn.enabled = self.count > 1;
    //如果两个都是不可点击,说明无货
    if (!self.increaseBtn.enabled && !self.decreaseBtn.enabled) {
        self.count = 0;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.count];
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
