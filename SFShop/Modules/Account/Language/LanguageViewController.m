//
//  LanguageViewController.m
//  SFShop
//
//  Created by Lufer on 2022/1/7.
//

#import "LanguageViewController.h"

@interface LanguageViewController ()

@property (nonatomic, strong) UIButton *chineseBtn;

@property (nonatomic, strong) UIButton *englishBtn;
// 印度
@property (nonatomic, strong) UIButton *hindiBtn;

@property (nonatomic, strong) UIImageView *checkImageView;

@end

@implementation LanguageViewController

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
}

- (void)initLayout {
    [self.chineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
    [self.englishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chineseBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(130);
    }];
    [self.hindiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.englishBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.view.mas_left).offset(16);
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

@end
