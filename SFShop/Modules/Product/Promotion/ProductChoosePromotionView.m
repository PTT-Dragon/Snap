//
//  ProductChoosePromotionView.m
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import "ProductChoosePromotionView.h"
#import "ProductChoosePromotionCell.h"
#import "ProductChoosePromotionTitleCell.h"

@interface ProductChoosePromotionView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation ProductChoosePromotionView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _titleLabel.text = kLocalizedString(@"PROMOTIONS");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductChoosePromotionCell" bundle:nil] forCellReuseIdentifier:@"ProductChoosePromotionCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductChoosePromotionTitleCell" bundle:nil] forCellReuseIdentifier:@"ProductChoosePromotionTitleCell"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self.topView addGestureRecognizer:tap];
}
- (void)removeSelf
{
    [self removeFromSuperview];
}
- (void)setCmpBuygetns:(NSArray<cmpBuygetnsModel> *)cmpBuygetns
{
    _cmpBuygetns = cmpBuygetns;
    [_tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    cmpBuygetnsModel *model = _cmpBuygetns[section];
    return model.sel ? 1: 2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _cmpBuygetns.count>3 ? 3: _cmpBuygetns.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProductChoosePromotionTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductChoosePromotionTitleCell"];
        cell.model = _cmpBuygetns[indexPath.section];
        cell.block = ^(BOOL sel) {
            [self.tableView reloadData];
        };
        return cell;
    }
    ProductChoosePromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductChoosePromotionCell"];
    cell.model = _cmpBuygetns[indexPath.section];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
