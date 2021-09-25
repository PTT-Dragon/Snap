//
//  CategorySideCell.m
//  SFShop
//
//  Created by MasterFly on 2021/9/25.
//

#import "CategorySideCell.h"


@interface CategorySideCell ()
@property (nonatomic, readwrite, strong) UIView *lineView;
@property (nonatomic, readwrite, strong) UILabel *titlelabel;
@end
@implementation CategorySideCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadsubviews];
        [self layout];
    }
    return self;
}

- (void)loadsubviews {
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.titlelabel];
}

- (void)layout {
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(4);
    }];
    
    [self.titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(65);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.lineView.hidden = !selected;
    self.contentView.backgroundColor = selected?[UIColor jk_colorWithHexString:@"#FFFFFF"]:[UIColor jk_colorWithHexString:@"#F4F4F4"];
}

#pragma mark - Getter
- (void)setModel:(CategorySideModel *)model {
    _model = model;
    _titlelabel.text = model.model.catgName;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor jk_colorWithHexString:@"#FF1659"];
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UILabel *)titlelabel {
    if (_titlelabel == nil) {
        _titlelabel = [[UILabel alloc] init];
        _titlelabel.textAlignment = NSTextAlignmentLeft;
        _titlelabel.font = [UIFont systemFontOfSize:12];
        _titlelabel.textColor = [UIColor jk_colorWithHexString:@"#000000"];
        _titlelabel.numberOfLines = 0;
    }
    return _titlelabel;
}


@end
