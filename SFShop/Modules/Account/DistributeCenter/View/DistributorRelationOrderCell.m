//
//  DistributorRelationOrderCell.m
//  SFShop
//
//  Created by 游挺 on 2021/11/1.
//

#import "DistributorRelationOrderCell.h"
#import "RelationOrderViewController.h"

@interface DistributorRelationOrderCell ()
@property (weak, nonatomic) IBOutlet UIView *pendingView;
@property (weak, nonatomic) IBOutlet UIView *settledView;
@property (weak, nonatomic) IBOutlet UILabel *pendingLabel;
@property (weak, nonatomic) IBOutlet UILabel *settledLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pendingTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *settledTitleLabel;

@end

@implementation DistributorRelationOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *pendingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pendingAction)];
    [_pendingView addGestureRecognizer:pendingTap];
    UITapGestureRecognizer *settledTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settledAction)];
    [_settledView addGestureRecognizer:settledTap];
    _titleLabel.text = kLocalizedString(@"RELATION_ORDER");
    _pendingTitleLabel.text = kLocalizedString(@"PENDING");
    _settledTitleLabel.text = kLocalizedString(@"SETTLED");
}
- (void)setModel:(DistributorModel *)model
{
    _model = model;
    _pendingLabel.text = [NSString stringWithFormat:@"%ld",model.kolOrderStatusNum.pendingNum];
    _settledLabel.text = [NSString stringWithFormat:@"%ld",model.kolOrderStatusNum.settledNum];
}
- (void)pendingAction
{
    RelationOrderViewController *vc = [[RelationOrderViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
- (void)settledAction
{
    RelationOrderViewController *vc = [[RelationOrderViewController alloc] init];
    [[baseTool getCurrentVC].navigationController pushViewController:vc animated:YES];
}
@end
