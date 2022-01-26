//
//  LanguageViewController.m
//  SFShop
//
//  Created by Lufer on 2022/1/7.
//

#import "LanguageViewController.h"
#import <MJRefresh/MJRefresh.h>

@interface LanguageViewController ()

@property (nonatomic, strong) UIButton *chineseBtn;

@property (nonatomic, strong) UIButton *englishBtn;
// 印度
@property (nonatomic, strong) UIButton *hindiBtn;

@property (nonatomic, strong) UIImageView *checkImageView;

@property (nonatomic,strong) UILabel *topLabel;

@end

@implementation LanguageViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self initView];
    [self initLayout];
    [self initData];
}

- (void)initView {
    self.title = kLocalizedString(@"LANGUGE");
    [self.view addSubview:self.chineseBtn];
    [self.view addSubview:self.englishBtn];
    [self.view addSubview:self.hindiBtn];
    [self.view addSubview:self.checkImageView];
    [self.view addSubview:self.topLabel];
}

- (void)initLayout {
    [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    [self.chineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.englishBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
    [self.englishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
    [self.hindiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chineseBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(0);
        make.width.mas_equalTo(130);
        make.height.mas_equalTo(50);
    }];
}

- (void)initData {
    NSString *language = UserDefaultObjectForKey(@"Language");
    if ([language isEqualToString:kLanguageChinese]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chineseBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
        [self.chineseBtn setTitleColor:RGBColorFrom16(0x1296db) forState:0];
    } else if ([language isEqualToString:kLanguageEnglish]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.englishBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
        [self.englishBtn setTitleColor:RGBColorFrom16(0x1296db) forState:0];
    } else if ([language isEqualToString:kLanguageHindi]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hindiBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
        [self.hindiBtn setTitleColor:RGBColorFrom16(0x1296db) forState:0];
    } else {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chineseBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
    }
}

- (void)chineseBtnAction {
    UserDefaultSetObjectForKey(kLanguageChinese, @"Language");
    [self.checkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chineseBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageChinese];
    [self changeLanguageWithId:@"2"];
}

- (void)englishBtnAction {
    UserDefaultSetObjectForKey(kLanguageEnglish, @"Language");
    MJRefreshConfig.defaultConfig.languageCode = @"en";
    [self.checkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.englishBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageEnglish];
    [self changeLanguageWithId:@"1"];
}

- (void)hindiBtnAction {
    UserDefaultSetObjectForKey(kLanguageHindi, @"Language");
    MJRefreshConfig.defaultConfig.languageCode = @"id";
    [self.checkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hindiBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageHindi];
    [self changeLanguageWithId:@"3"];
}
- (void)changeLanguageWithId:(NSString *)languageId
{
    [SFNetworkManager post:[SFNet.account setLanguageWithId:languageId] parameters:@{} success:^(id  _Nullable response) {
        
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (UIButton *)chineseBtn {
    if (!_chineseBtn) {
        _chineseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chineseBtn setTitle:@"中文" forState:UIControlStateNormal];
        [_chineseBtn addTarget:self action:@selector(chineseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_chineseBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_chineseBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
        _chineseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _chineseBtn;
}

- (UIButton *)englishBtn {
    if (!_englishBtn) {
        _englishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_englishBtn setTitle:@"English" forState:UIControlStateNormal];
        [_englishBtn addTarget:self action:@selector(englishBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_englishBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _englishBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_englishBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _englishBtn;
}

- (UIButton *)hindiBtn {
    if (!_hindiBtn) {
        _hindiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hindiBtn setTitle:@"Hindi" forState:UIControlStateNormal];
        [_hindiBtn addTarget:self action:@selector(hindiBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_hindiBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _hindiBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_hindiBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return _hindiBtn;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbox_check-1"]];
        _checkImageView.contentMode = UIViewContentModeScaleAspectFill;
        _checkImageView.layer.masksToBounds = YES;
    }
    return _checkImageView;
}
- (UILabel *)topLabel
{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.backgroundColor = RGBColorFrom16(0xfcf9dd);
        _topLabel.text = @"Select the language you prefer for browsing shopping and communications";
        _topLabel.font = CHINESE_SYSTEM(12);
        _topLabel.textColor = RGBColorFrom16(0xd58b63);
        _topLabel.numberOfLines = 0;
    }
    return _topLabel;
}

@end
