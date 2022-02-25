//
//  PublicAlertView.m
//  SFShop
//
//  Created by 游挺 on 2021/11/3.
//

#import "PublicAlertView.h"

@interface PublicAlertView ()
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic,strong) UIButton *btn2;
@end

@implementation PublicAlertView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btnTitle block:(void (^)(void))block
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(22);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBColorFrom16(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = CHINESE_SYSTEM(12);
        _titleLabel.text = title;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_bgView.mas_top).offset(24);
        }];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = CHINESE_BOLD(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:btnTitle forState:0];
        [_bgView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(24);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-24);
        }];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block();
            [self removeFromSuperview];
        }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btn1Title block:(void (^)(void))block1 btn2Title:(NSString *)btn2Title block2:(void (^)(void))block2
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(22);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBColorFrom16(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = CHINESE_SYSTEM(13);
        _titleLabel.text = title;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_bgView.mas_top).offset(24);
        }];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = CHINESE_BOLD(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:btn1Title forState:0];
        [_bgView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(24);
        }];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block1();
            [self removeFromSuperview];
        }];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.titleLabel.font = CHINESE_BOLD(14);
        [_btn2 setTitleColor:RGBColorFrom16(0xFF1659) forState:0];
        _btn2.backgroundColor = [UIColor whiteColor];
        _btn2.layer.borderWidth = 1;
        _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        [_btn2 setTitle:btn2Title forState:0];
        [_bgView addSubview:_btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_btn.mas_bottom).offset(12);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-24);
        }];
        [[_btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block2();
            [self removeFromSuperview];
        }];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content btnTitle:(NSString *)btn1Title block:(void (^)(void))block1
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(22);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBColorFrom16(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kFontBlod(14);
        _titleLabel.text = title;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_bgView.mas_top).offset(24);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBColorFrom16(0x000000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = kFontRegular(12);
        _contentLabel.text = content;
        [_bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        }];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = kFontBlod(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:btn1Title forState:0];
        [_bgView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(24);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-20);
        }];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block1();
            [self removeFromSuperview];
        }];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title content:(NSString *)content btnTitle:(NSString *)btn1Title block:(void (^)(void))block1 btn2Title:(NSString *)btn2Title block2:(void (^)(void))block2
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(22);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBColorFrom16(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = kFontRegular(14);
        _titleLabel.text = title;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_bgView.mas_top).offset(24);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = RGBColorFrom16(0x000000);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = CHINESE_SYSTEM(12);
        _contentLabel.text = content;
        [_bgView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
        }];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = CHINESE_BOLD(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:btn1Title forState:0];
        [_bgView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_contentLabel.mas_bottom).offset(24);
        }];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block1();
            [self removeFromSuperview];
        }];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.titleLabel.font = CHINESE_BOLD(14);
        [_btn2 setTitleColor:RGBColorFrom16(0xFF1659) forState:0];
        _btn2.backgroundColor = [UIColor whiteColor];
        _btn2.layer.borderWidth = 1;
        _btn2.layer.borderColor = RGBColorFrom16(0xFF1659).CGColor;
        [_btn2 setTitle:btn2Title forState:0];
        [_bgView addSubview:_btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_btn.mas_bottom).offset(12);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-24);
        }];
        [[_btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block2();
            [self removeFromSuperview];
        }];
    }
    return self;
}
- (instancetype)initDarkColorWithFrame:(CGRect)frame title:(NSString *)title btnTitle:(NSString *)btn1Title block:(void (^)(void))block1 btn2Title:(NSString *)btn2Title block2:(void (^)(void))block2
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.left.mas_equalTo(self.mas_left).offset(22);
        }];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = RGBColorFrom16(0x000000);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.font = CHINESE_SYSTEM(12);
        _titleLabel.text = title;
        [_bgView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.top.mas_equalTo(_bgView.mas_top).offset(24);
        }];
        
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.titleLabel.font = CHINESE_BOLD(14);
        [_btn setTitleColor:[UIColor whiteColor] forState:0];
        _btn.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn setTitle:btn1Title forState:0];
        [_bgView addSubview:_btn];
        [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(24);
        }];
        [[_btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block1();
            [self removeFromSuperview];
        }];
        
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.titleLabel.font = CHINESE_BOLD(14);
        [_btn2 setTitleColor:[UIColor whiteColor] forState:0];
        _btn2.backgroundColor = RGBColorFrom16(0xFF1659);
        [_btn2 setTitle:btn2Title forState:0];
        [_bgView addSubview:_btn2];
        [_btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_bgView.mas_left).offset(24);
            make.centerX.equalTo(_bgView);
            make.height.mas_equalTo(46);
            make.top.mas_equalTo(_btn.mas_bottom).offset(12);
            make.bottom.mas_equalTo(_bgView.mas_bottom).offset(-24);
        }];
        [[_btn2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            block2();
            [self removeFromSuperview];
        }];
    }
    return self;
}

@end
