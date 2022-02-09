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
    [cell setContent:_couponDataSource[indexPath.section]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 118;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _couponDataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainScreen_width, 10)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}


- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

@end
