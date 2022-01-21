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
@end
@implementation CollectionHeaderEmptyView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
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
}

- (void)initLayout {
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self.emptyTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom).offset(16);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
    }];
}


#pragma mark - config
- (void)configDataWithEmptyType:(EmptyViewType)type {
    EmptyModel *model = [EmptyModel getEmptyModelWithType:type];
    self.emptyTipLabel.text = model.tip;
    self.emptyImageView.image = [UIImage imageNamed:model.imageName];
}


#pragma mark - setter && getter

- (UIImageView *)emptyImageView {
    if (!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_emptyImageView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_emptyImageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        [_emptyImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_emptyImageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
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
@end
