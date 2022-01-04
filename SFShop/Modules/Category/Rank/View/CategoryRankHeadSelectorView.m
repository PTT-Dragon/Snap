//
//  CategoryRankHeadSelectorView.m
//  SFShop
//
//  Created by MasterFly on 2021/10/21.
//

#import "CategoryRankHeadSelectorView.h"
#import "UIButton+EnlargeTouchArea.h"

@interface CategoryRankHeadSelectorView ()
@property (nonatomic, readwrite, strong) UIButton *popularityBtn;
@property (nonatomic, readwrite, strong) UIButton *salesBtn;
@property (nonatomic, readwrite, strong) UIButton *priceBtn;
@property (nonatomic, readwrite, strong) UIButton *filterBtn;
@property (nonatomic, readwrite, strong) UIButton *lastBtn;
@end
@implementation CategoryRankHeadSelectorView

- (instancetype)initWithFrame:(CGRect)frame type:(CategoryRankType)type {
    if (self = [super initWithFrame:frame]) {
        [self loadSubviewsWithType:type];
        [self layout];
    }
    return self;
}

- (void)loadSubviewsWithType:(CategoryRankType)type {
    for (UIButton *btn in @[self.popularityBtn,self.salesBtn,self.priceBtn,self.filterBtn]) {
        if (btn.tag - 100 == type) {
            [self sortUpdateBtnUI:btn];
        }
        [self addSubview:btn];
    }
}

- (void)layout {
    [self.popularityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(KScale(16));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(KScale(32));
        make.width.mas_equalTo(KScale(96));
    }];
    
    [self.salesBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.popularityBtn.mas_right).offset(KScale(8));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(KScale(32));
        make.width.mas_equalTo(KScale(60));
    }];
    
    [self.priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.salesBtn.mas_right).offset(KScale(8));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(KScale(32));
        make.width.mas_equalTo(KScale(78));
    }];
    
    [self.filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(KScale(-25));
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(KScale(18));
        make.width.mas_equalTo(KScale(18));
    }];
}

#pragma mark - Event
- (void)sort:(UIButton *)btn {
    //改变状态之前的逻辑处理
    if (btn == self.priceBtn) {
        CategoryRankType type = btn.tag - 100;
        BOOL isSeleted = btn.selected;
        if (isSeleted) {
            if (type == CategoryRankTypePriceDescending) {
                btn.tag = CategoryRankTypePriceAscending + 100;
            } else {
                btn.tag = CategoryRankTypePriceDescending + 100;
            }
        } else {//从未选中到选中状态默认未降序
            btn.tag = CategoryRankTypePriceDescending + 100;
        }
    }
    
    //回调给外部
    !self.clickFilterBlock?:self.clickFilterBlock(btn.tag - 100);
    
    //UI 处理
    [self sortUpdateBtnUI:btn];
}

- (void)sortUpdateBtnUI:(UIButton *)btn {
    btn.selected = YES;
    btn.layer.borderColor = [UIColor jk_colorWithHexString:@"#FF1659"].CGColor;
    if (self.lastBtn && self.lastBtn != btn ) {
        self.lastBtn.selected = NO;
        self.lastBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
    }
    self.lastBtn = btn;
}

- (void)detailFilter:(UIButton *)btn {
    !self.clickFilterBlock?:self.clickFilterBlock(btn.tag - 100);
}

#pragma mark - Getter
- (UIButton *)popularityBtn {
    if (_popularityBtn == nil) {
        _popularityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _popularityBtn.tag = CategoryRankTypePopularity + 100;
        _popularityBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_popularityBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_popularityBtn setTitle:kLocalizedString(@"Popularity") forState:UIControlStateNormal];
        [_popularityBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_popularityBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _popularityBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _popularityBtn.layer.borderWidth = 1;
    }
    return _popularityBtn;
}

- (UIButton *)salesBtn {
    if (_salesBtn == nil) {
        _salesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _salesBtn.tag = CategoryRankTypeSales + 100;
        _salesBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_salesBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_salesBtn setTitle:kLocalizedString(@"Sales") forState:UIControlStateNormal];
        [_salesBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_salesBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _salesBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _salesBtn.layer.borderWidth = 1;
    }
    return _salesBtn;
}

- (UIButton *)priceBtn {
    if (_priceBtn == nil) {
        _priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _priceBtn.tag = CategoryRankTypePriceAscending + 100;
        _priceBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_priceBtn addTarget:self action:@selector(sort:) forControlEvents:UIControlEventTouchUpInside];
        [_priceBtn setTitle:kLocalizedString(@"Price") forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[UIColor jk_colorWithHexString:@"#7B7B7B"] forState:UIControlStateNormal];
        [_priceBtn setTitleColor:[UIColor jk_colorWithHexString:@"#FF1659"] forState:UIControlStateSelected];
        _priceBtn.layer.borderColor = [UIColor jk_colorWithHexString:@"#C4C4C4"].CGColor;
        _priceBtn.layer.borderWidth = 1;
    }
    return _priceBtn;
}

- (UIButton *)filterBtn {
    if (_filterBtn == nil) {
        _filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_filterBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
        _filterBtn.tag = CategoryRankTypeDetail + 100;
        [_filterBtn addTarget:self action:@selector(detailFilter:) forControlEvents:UIControlEventTouchUpInside];
        [_filterBtn setImage:[UIImage imageNamed:@"rank_filters"] forState:UIControlStateNormal];
    }
    return _filterBtn;
}


@end
