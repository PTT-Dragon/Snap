//
//  CartChoosePromotion.m
//  SFShop
//
//  Created by 游挺 on 2021/12/26.
//

#import "CartChoosePromotion.h"
#import "CartPromotionCell.h"
#import "NSString+Fee.h"
#import "UIButton+EnlargeTouchArea.h"

@interface CartChoosePromotion ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation CartChoosePromotion
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CartPromotionCell" bundle:nil] forCellReuseIdentifier:@"CartPromotionCell"];
    self.titleLabel.text = kLocalizedString(@"CHANGE_PROMOTION");
    [self.confirmBtn setTitle:kLocalizedString(@"CONFIRM") forState:0];
    [_closeBtn setEnlargeEdgeWithTop:5 right:5 bottom:5 left:5];
}
- (void)setModel:(CartItemModel *)model
{
    _model = model;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.imgUrl)]];
    _nameLabel.text = model.productName;
    _priceLabel.text = [[NSString stringWithFormat:@"%f",model.salesPrice] currency];
    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.campaigns.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartPromotionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartPromotionCell"];
    cell.model = _model.campaigns[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (IBAction)confirmAction:(UIButton *)sender {
    
}
- (IBAction)closeAction:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
