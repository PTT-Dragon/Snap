//
//  CollectionHeaderEmptyView.m
//  SFShop
//
//  Created by MasterFly on 2022/1/22.
//

#import "CollectionHeaderEmptyView.h"
#import "EmptyModel.h"

@interface CollectionHeaderEmptyView ()
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel *emptyTipLabel;
@property (nonatomic, strong) UILabel *sectionTitleLabel;
@end
@implementation CollectionHeaderEmptyView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [self initView];
    [self initLayout];
}

- (void)initView {
    [self addSubview:self.emptyImageView];
    [self addSubview:self.emptyTipLabel];
    [self addSubview:self.sectionTitleLabel];
}

- (void)initLayout {
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [self.emptyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
    
    [self.sectionTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-5);
    }];
}


#pragma mark - config
- (void)configDataWithEmptyType:(EmptyViewType)type {
    EmptyModel *model = [EmptyModel getEmptyModelWithType:type];
    self.emptyTipLabel.text = model.tip;
    self.emptyImageView.image = [UIImage imageNamed:model.imageName];
}

- (void)updateTitle:(NSString *)title {
    self.sectionTitleLabel.text = title;
    self.sectionTitleLabel.hidden = !title.length;
}

#pragma mark - setter && getter

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _emptyImageView;
}

- (UILabel *)emptyTipLabel {
    if (!_emptyTipLabel) {
        _emptyTipLabel = [[UILabel alloc] init];
        _emptyTipLabel.font = [UIFont systemFontOfSize:14];
        _emptyTipLabel.textColor = UIColor.blackColor;
        _emptyTipLabel.textAlignment = NSTextAlignmentCenter;
        _emptyTipLabel.numberOfLines = 0;
    }
    return _emptyTipLabel;
}

- (UILabel *)sectionTitleLabel {
    if (!_sectionTitleLabel) {
        _sectionTitleLabel = [[UILabel alloc] init];
        _sectionTitleLabel.font = [UIFont systemFontOfSize:14];
        _sectionTitleLabel.textColor = UIColor.blackColor;
        _sectionTitleLabel.textAlignment = NSTextAlignmentLeft;
        _sectionTitleLabel.hidden = YES;
    }
    return _sectionTitleLabel;
}

@end
