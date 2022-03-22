//
//  SFSearchNav.m
//  SFShop
//
//  Created by MasterFly on 2021/10/27.
//

#import "SFSearchNav.h"
#import "SFSearchView.h"
#import "SFSearchingView.h"
#import "SceneManager.h"

@interface SFSearchNav ()<UITextFieldDelegate>
@property (nonatomic, readwrite, strong) SFSearchItem *bItem;
@property (nonatomic, readwrite, strong) SFSearchItem *rItem;
@property (nonatomic, readwrite, strong) UIButton *rightBtn;
@property (nonatomic, readwrite, strong) UIButton *searchImgBtn;
@property (nonatomic, readwrite, strong) SFSearchView *searchView;
@property (nonatomic, readwrite, strong) SFSearchingView *searchingView;
@property (nonatomic, readwrite, strong) UIView *lineView;
@property (nonatomic, readwrite, copy) void(^searchBlock)(NSString *qs);
@property (nonatomic, readwrite, strong) NSMutableArray<NSMutableArray<SFSearchModel *> *> *dataArray;
@property (nonatomic, readwrite, strong) NSMutableArray<SFSearchModel *> *searchHistory;

@end
@implementation SFSearchNav

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame backItme:(SFSearchItem *)bItem rightItem:(SFSearchItem *)rItem searchBlock:(nonnull void (^)(NSString *qs))searchBlock {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _searchBlock = searchBlock;
        _bItem = bItem;
        _rItem = rItem;
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)textFieldDidChangeValue:(NSNotification *)noti {
    if (self.searchType == SFSearchTypeImmersion) {
        UITextField *textField = (UITextField *)[noti object];
        if (textField.text.length > 0) {
            [self.searchingView requestAssociate:textField.text];
        } else {
            [self.searchingView requestAssociate:textField.text];
//            self.searchingView.hidden = YES;
        }
    }
}

- (void)loadsubviews {
    [self addSubview:self.backBtn];
    [self addSubview:self.textField];
    [self addSubview:self.rightBtn];
    [self addSubview:self.searchBtn];
    [self addSubview:self.lineView];
}

- (void)layout {
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.left.mas_equalTo(10);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(-27);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(24, 24));
        make.right.mas_equalTo(-27);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(10);
        make.right.equalTo(self.rightBtn.mas_left).offset(-18);
        make.left.equalTo(self.backBtn.mas_right).offset(12);
        make.height.mas_equalTo(35);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
}

#pragma mark - Publice
- (void)addSearchSection:(NSMutableArray<SFSearchModel *> *)sectionData {
    [self.dataArray addObject:sectionData];
    self.searchView.dataArray = _dataArray;
}

- (void)setActiveSearch:(BOOL)activeSearch {
    _activeSearch = activeSearch;
    if (_activeSearch) {
        [self.textField becomeFirstResponder];
    }
}

#pragma mark - Event
- (void)clickRightBtn
{
    [self btnClick:self.rightBtn];
}

- (void)btnClick:(UIButton *)btn {
    if (btn == self.backBtn) {
        if ([self.superview.subviews containsObject:self.searchView]) {
            [self searchUIUnActive];
            if (self.activeSearch) {
                !self.bItem.itemActionBlock ?: self.bItem.itemActionBlock(SFSearchStateInFocuActive,nil,NO);
            } else {
                !self.bItem.itemActionBlock ?: self.bItem.itemActionBlock(self.searchingView.hidden?SFSearchStateInHistory:SFSearchStateInSearching,nil,NO);
            }
        } else {
            !self.bItem.itemActionBlock ?: self.bItem.itemActionBlock(SFSearchStateInUnActive,nil,NO);
        }
    } else if (btn == self.rightBtn) {
        btn.selected = !btn.selected;
        if ([self.superview.subviews containsObject:self.searchView]) {
            if (self.activeSearch) {
                !self.rItem.itemActionBlock ?: self.rItem.itemActionBlock(SFSearchStateInFocuActive,nil,btn.selected);
            } else {
                !self.rItem.itemActionBlock ?: self.rItem.itemActionBlock(self.searchingView.hidden?SFSearchStateInHistory:SFSearchStateInSearching,nil,btn.selected);
            }
        } else {
            !self.rItem.itemActionBlock ?: self.rItem.itemActionBlock(SFSearchStateInUnActive,nil,btn.selected);
        }
    }
}

- (void)searchClick:(UIButton *)btn {
    [self search:self.textField.text];
}

- (void)searchUIUnActive {
    if ([self.superview.subviews containsObject:self.searchView]) {
        [self.searchView removeFromSuperview];
        self.searchBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self endEditing:YES];
    }
}

- (void)searchUIActive {
    if (![self.superview.subviews containsObject:self.searchView]) {
        [self.superview addSubview:self.searchView];
        self.searchBtn.hidden = NO;
        self.rightBtn.hidden = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.searchType == SFSearchTypeImmersion) {
        [self searchUIActive];
    } else if (self.searchType == SFSearchTypeFake) {
        !self.fakeTouchBock ?: self.fakeTouchBock();
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self search:textField.text];
    return YES;
}

- (void)search:(NSString *)qs {
    [self searchUIUnActive];
    self.textField.text = qs;
    self.activeSearch = NO;
    !self.searchBlock ?: self.searchBlock(qs);
    if (qs && ![qs isEqualToString:@""]) {
        NSMutableArray *searchHistory = UserDefaultObjectForKey(userDefaultNameSearchHistory) ? [NSMutableArray arrayWithArray:UserDefaultObjectForKey(userDefaultNameSearchHistory)] : [NSMutableArray array];
        if (![searchHistory containsObject:qs]) {
            [searchHistory addObject:qs];
            UserDefaultSetObjectForKey(searchHistory, userDefaultNameSearchHistory);
            [self.searchHistory insertObject:[SFSearchModel historyModelWithName:qs] atIndex:0];
            [self.searchView reload];
        }
    }
}

#pragma mark - Get and Set
- (NSMutableArray<NSMutableArray<SFSearchModel *> *> *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:self.searchHistory];
    }
    return _dataArray;
}

- (NSMutableArray<SFSearchModel *> *)searchHistory {
    if (_searchHistory == nil) {
        _searchHistory = [NSMutableArray array];
        NSArray *searchs = UserDefaultObjectForKey(userDefaultNameSearchHistory);
        for (NSString *qs in searchs) {
            [_searchHistory addObject:[SFSearchModel historyModelWithName:qs]];
        }
    }
    return _searchHistory;
}

- (SFSearchView *)searchView {
    if (_searchView == nil) {
        _searchView = [[SFSearchView alloc] initWithFrame:CGRectMake(0, 10 + navBarHei, MainScreen_width, MainScreen_height - (10 + navBarHei))];
        __weak __typeof (self)weakSelf = self;
        _searchView.dataArray = self.dataArray;
        _searchView.searchBlock = ^(NSString *qs) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            [strongSelf search:qs];
        };
        _searchView.cleanHistoryBlock = ^{
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Confirm delete all search history?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UserDefaultSetObjectForKey(nil, userDefaultNameSearchHistory);
                [strongSelf.searchHistory removeAllObjects];
                [strongSelf.searchView reload];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
        };
    }
    return _searchView;
}

- (SFSearchingView *)searchingView {
    if (_searchingView == nil) {
        _searchingView = [[SFSearchingView alloc] initWithFrame:self.searchView.bounds];
        _searchingView.hidden = YES;
        __weak __typeof (self)weakSelf = self;
        _searchingView.selectedBlock = ^(NSString * _Nonnull q) {
            __strong __typeof (weakSelf)strongSelf = weakSelf;
            [strongSelf search:q];
        };
        [self.searchView addSubview:_searchingView];
    }
    return _searchingView;
}

- (UIButton *)backBtn {
    if (_backBtn == nil) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setTitle:_bItem.name forState:UIControlStateNormal];
        [_backBtn setImage:[UIImage imageNamed:_bItem.icon] forState:UIControlStateNormal];
    }
    return _backBtn;
}

- (CustomTextField *)textField {
    if (_textField == nil) {
        _textField = [[CustomTextField alloc] init];
        _textField.delegate = self;
        _textField.font = kFontRegular(16);
        _textField.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _textField.textAlignment = NSTextAlignmentLeft;
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.placeholder = kLocalizedString(@"Search");
        [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDidChangeValue:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:_textField];
    }
    return _textField;
}

- (UIButton *)rightBtn {
    if (_rightBtn == nil) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitle:_rItem.name forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:_rItem.icon] forState:UIControlStateNormal];
        [_rightBtn setImage:[UIImage imageNamed:_rItem.selectedIcon] forState:UIControlStateSelected];

    }
    return _rightBtn;
}

- (UIButton *)searchBtn {
    if (_searchBtn == nil) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
        [_searchBtn setImage:[UIImage imageNamed:@"ic_nav_search"] forState:UIControlStateNormal];
        _searchBtn.hidden = YES;
    }
    return _searchBtn;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor jk_colorWithHexString:@"#eeeeee"];
    }
    return _lineView;
}


@end
