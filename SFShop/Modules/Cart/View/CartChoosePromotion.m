//
//  CartChoosePromotion.m
//  SFShop
//
//  Created by 游挺 on 2021/12/26.
//

#import "CartChoosePromotion.h"

@interface CartChoosePromotion ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CartChoosePromotion
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
}
- (IBAction)confirmAction:(UIButton *)sender {
    
}

@end
