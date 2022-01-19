//
//  CartEmptyView.m
//  SFShop
//
//  Created by Lufer on 2022/1/11.
//

#import "CartEmptyView.h"
#import "EmptyView.h"
#import "ProductionRecomandView.h"
#import "ProductSimilarModel.h"

@interface CartEmptyView ()

@property (nonatomic, strong) UIScrollView *scrollView;

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
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.emptyView];
    [self.scrollView addSubview:self.goShoppingBtn];
    [self.scrollView addSubview:self.recomandView];
}

- (void)initLayout {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.bottom.mas_equalTo(self.recomandView.mas_bottom);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_equalTo(182);
    }];
    [self.goShoppingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyView.mas_bottom).offset(-30);
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.right.mas_equalTo(self.mas_right).offset(-20);
        make.height.mas_equalTo(46);
    }];
    [self.recomandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goShoppingBtn.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(400);
    }];
}


#pragma mark - configData

- (void)configDataWithSimilarList:(NSMutableArray *)similarList {
//    NSMutableArray<ProductSimilarModel *> *tempArr = [NSMutableArray array];
//    for (favoriteModel *tempModel in similarList) {
//        ProductSimilarModel *similarModel = [[ProductSimilarModel alloc] init];
//        similarModel.imgUrl = tempModel.imgUrl;
//        similarModel.offerName = tempModel.offerName;
//        similarModel.salesPrice = [tempModel.salesPrice floatValue];
//        similarModel.discountPercent = ([tempModel.salesPrice floatValue]/[tempModel.marketPrice floatValue]) * 100;
//        similarModel.marketPrice = [tempModel.marketPrice floatValue];
//        [tempArr addObject:similarModel];
//    }
    [self.recomandView configDataWithSimilarList:similarList];
}


#pragma mark - btnAction

- (void)goShoppingBtnAction {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
}


#pragma mark - setter

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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

@end
