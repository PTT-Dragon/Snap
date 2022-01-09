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
    self.title = kLocalizedString(@"Language");
    [self.view addSubview:self.chineseBtn];
    [self.view addSubview:self.englishBtn];
    [self.view addSubview:self.hindiBtn];
    [self.view addSubview:self.checkImageView];
}

- (void)initLayout {
    [self.chineseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(navBarHei+10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.englishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chineseBtn.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
    [self.hindiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.englishBtn.mas_bottom).offset(10);
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(50);
    }];
}

- (void)initData {
    NSString *language = UserDefaultObjectForKey(@"Language");
    if ([language isEqualToString:kLanguageChinese]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chineseBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
    } else if ([language isEqualToString:kLanguageEnglish]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.englishBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
    } else if ([language isEqualToString:kLanguageHindi]) {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hindiBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(50, 50));
            make.right.mas_equalTo(self.view.mas_right).offset(-10);
        }];
    } else {
        [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.chineseBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(50, 50));
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
}

- (void)englishBtnAction {
    UserDefaultSetObjectForKey(kLanguageEnglish, @"Language");
    [self.checkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.englishBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageEnglish];
}

- (void)hindiBtnAction {
    UserDefaultSetObjectForKey(kLanguageHindi, @"Language");
    [self.checkImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hindiBtn.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.right.mas_equalTo(self.view.mas_right).offset(-10);
    }];
    [NSNotificationCenter.defaultCenter postNotificationName:@"KLanguageChange" object:kLanguageHindi];
}

- (UIButton *)chineseBtn {
    if (!_chineseBtn) {
        _chineseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chineseBtn setTitle:@"中文" forState:UIControlStateNormal];
        [_chineseBtn addTarget:self action:@selector(chineseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [_chineseBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _chineseBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _chineseBtn.layer.borderColor = UIColor.blackColor.CGColor;
        _chineseBtn.layer.borderWidth = 1;
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
        _englishBtn.layer.borderColor = UIColor.blackColor.CGColor;
        _englishBtn.layer.borderWidth = 1;
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
        _hindiBtn.layer.borderColor = UIColor.blackColor.CGColor;
        _hindiBtn.layer.borderWidth = 1;
    }
    return _hindiBtn;
}

- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_checkbox_check"]];
        _checkImageView.contentMode = UIViewContentModeScaleAspectFit;
        _checkImageView.layer.masksToBounds = YES;
    }
    return _checkImageView;
}

@end
