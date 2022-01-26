//
//  CommunitySelectTableViewCell.m
//  SFShop
//
//  Created by Lufer on 2022/1/23.
//

#import "CommunitySelectTableViewCell.h"

@interface CommunitySelectTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *selectTypeImageView;

@end

@implementation CommunitySelectTableViewCell

+ (instancetype)selectCellWithTableView:(UITableView *)tableView
                                 cellId:(NSString *)cellId {
    CommunitySelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle
                           reuseIdentifier:cellId];
        cell.backgroundColor = UIColor.whiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        [self initLayout];
    }
    return self;
}


#pragma mark - init

- (void)initView {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.selectTypeImageView];
}

- (void)initLayout {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.left.mas_equalTo(20);
    }];
    [self.selectTypeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
    }];
}


#pragma mark - configData

- (void)configDataWithTitle:(NSString *)title
             isFavoriteType:(BOOL)isFavoriteType isRecommend:(BOOL)isRecommend {
    self.titleLabel.text = title;
    if (isRecommend) {
        self.selectTypeImageView.image = [UIImage imageNamed:@""];
    } else if(isFavoriteType){
        self.selectTypeImageView.image = [UIImage imageNamed:@"ic_community_close"];
    }else{
        self.selectTypeImageView.image = [UIImage imageNamed:@"ic_community_add"];
    }
}


#pragma mark - setter && getter


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor jk_colorWithHexString:@"#666666"];
    }
    return _titleLabel;
}

- (UIImageView *)selectTypeImageView {
    if (!_selectTypeImageView) {
        _selectTypeImageView = [[UIImageView alloc] init];
        _selectTypeImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _selectTypeImageView;
}

@end
