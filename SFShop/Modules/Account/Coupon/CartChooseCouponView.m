//
//  CartChooseCouponView.m
//  SFShop
//
//  Created by 游挺 on 2021/12/26.
//

#import "CartChooseCouponView.h"
#import "MyCouponCell.h"

@interface CartChooseCouponView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation CartChooseCouponView
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MyCouponCell" bundle:nil] forCellReuseIdentifier:@"MyCouponCell"];
    _titleLabel.text = kLocalizedString(@"COUPON");
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCouponCell"];
    [cell setContent:_couponDataSource[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponDataSource.count>3?3:_couponDataSource.count;
}

- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

@end
