//
//  MGCShareCollectionViewCell.m
//  Pods-MiguDMShare_Example
//
//  Created by 陆锋 on 2021/5/6.
//

#import "MGCShareCollectionViewCell.h"
#import "UIView+YYAdd.h"

@interface MGCShareCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MGCShareCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    [self.contentView addSubview:self.iconImageView];
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.width.height.mas_equalTo(42);
        make.centerX.equalTo(self.contentView);
    }];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(4);
        make.left.right.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
}

- (void)configDataWithItemModel:(MGCShareItemModel *)itemModel{
    self.itemModel = itemModel;
    self.iconImageView.image = [UIImage imageNamed:itemModel.itemImage];
    self.titleLabel.text = itemModel.itemName;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = BOLDSYSTEMFONT(11);
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
@end
