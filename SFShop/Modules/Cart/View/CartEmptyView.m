//
//  CartEmptyView.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "CartEmptyView.h"
#import "EmptyView.h"
#import "ProductionRecomandView.h"

@interface CartEmptyView ()

@property (nonatomic, strong) EmptyView *emptyView;

@property (nonatomic, strong) UIButton *goShoppingBtn;

@property (nonatomic, strong) ProductionRecomandView *recomandView;

@end

@implementation CartEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
    [self initLayout];
}

#pragma mark - init

- (void)initView {
    [self addSubview:self.emptyView];
    [self addSubview:self.goShoppingBtn];
    [self addSubview:self.recomandView];
}

- (void)initLayout {
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.height.mas_equalTo(182);
    }];
    [self.goShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyView.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(46);
    }];
    [self.recomandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goShoppingBtn.mas_bottom);
        make.left.right.bottom.mas_equalTo(self);
    }];
}

- (void)configDataWithSimilarList:(NSMutableArray<ProductSimilarModel *> *)similarList {
    [self.recomandView configDataWithSimilarList:similarList];
}

- (void)goShoppingBtnAction {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
}

- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoShoppingCarType];
    }
    return _emptyView;
}

- (UIButton *)goShoppingBtn {
    if (!_goShoppingBtn) {
        _goShoppingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goShoppingBtn setTitle:kLocalizedString(@"Go_Shopping") forState:UIControlStateNormal];
        [_goShoppingBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_goShoppingBtn setBackgroundColor:[UIColor jk_colorWithHexString:@"FF1659"]];
        [_goShoppingBtn addTarget:self action:@selector(goShoppingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goShoppingBtn;
}

- (ProductionRecomandView *)recomandView {
    if (!_recomandView) {
        _recomandView = [[ProductionRecomandView alloc] init];
    }
    return _recomandView;
}

@end
