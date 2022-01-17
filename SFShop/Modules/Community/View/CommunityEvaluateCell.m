//
//  CommunityEvaluateCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/19.
//

#import "CommunityEvaluateCell.h"

@interface CommunityEvaluateCell ()
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UIButton *likeBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,strong) UILabel *likeLabel;
@end

@implementation CommunityEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initUI];
    }
    return self;
}
- (void)initUI
{
    _imgView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(28);
        make.left.mas_equalTo(self.contentView.mas_left).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
    }];
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = RGBColorFrom16(0x7b7b7b);
    _nameLabel.font = CHINESE_SYSTEM(12);
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.imgView.mas_right).offset(8);
        make.top.equalTo(self.imgView);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font = CHINESE_SYSTEM(12);
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(51);
        make.right.mas_equalTo(self.contentView.mas_right).offset(15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(32);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_likeBtn];
    [_likeBtn setImage:[UIImage imageNamed:@"heart"] forState:0];
    [_likeBtn setImage:[UIImage imageNamed:@"love-2"] forState:UIControlStateSelected];
    [_likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-38);
        make.top.mas_equalTo(self.contentView.mas_top).offset(5);
    }];
    _likeLabel = [[UILabel alloc] init];
    _likeLabel.font = CHINESE_SYSTEM(14);
    [self.contentView addSubview:_likeLabel];
    [_likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-14);
        make.centerY.equalTo(_likeBtn);
    }];
}
- (void)setModel:(ArticleEvaluateChildrenModel *)model
{
    _model = model;
    _contentLabel.text = model.evalComments;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.userLogo)] placeholderImage:[UIImage imageNamed:@"account-black"]];
    _nameLabel.text = model.userName;
    _likeBtn.selected = [model.isUseful isEqualToString:@"Y"];
    _likeLabel.textColor = [model.isUseful isEqualToString:@"Y"] ? RGBColorFrom16(0xFF1659): RGBColorFrom16(0x7b7b7b);
    _likeLabel.text = model.usefulCnt;
}
- (void)setType:(NSInteger)type
{
    _type = type;
    [_contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(_type == 1 ? 51:79);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15);
        make.top.mas_equalTo(self.contentView.mas_top).offset(32);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    [_imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(_type == 1 ? 15:51);
        make.width.height.mas_equalTo(_type == 1 ? 28: 20);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
    }];
}
- (void)likeAction:(UIButton *)btn
{
    MPWeakSelf(self)
    [MBProgressHUD showHudMsg:@""];
    [SFNetworkManager post:[SFNet.article likeEvaluatelOf:_model.articleEvalId] parameters:@{@"action":[_model.isUseful isEqualToString:@"Y"] ? @"C": @"A"} success:^(id  _Nullable response) {
        weakself.model.isUseful = [weakself.model.isUseful isEqualToString:@"Y"] ? @"N": @"Y";
        [weakself setModel:weakself.model];
        [MBProgressHUD hideFromKeyWindow];
    } failed:^(NSError * _Nonnull error) {
        [MBProgressHUD hideFromKeyWindow];
        [MBProgressHUD autoDismissShowHudMsg:[NSMutableString getErrorMessage:error][@"message"]];
    }];
}
@end
