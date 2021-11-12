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

@end

@implementation DistributorRelationOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *pendingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pendingAction)];
    [_pendingView addGestureRecognizer:pendingTap];
    UITapGestureRecognizer *settledTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(settledAction)];
    [_settledView addGestureRecognizer:settledTap];
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
