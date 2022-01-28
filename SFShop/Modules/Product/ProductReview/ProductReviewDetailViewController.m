//
//  ProductReviewDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/17.
//

#import "ProductReviewDetailViewController.h"
#import "ProductEvalationCell.h"
#import "ProductReviewReplyCell.h"
#import "ProductViewController.h"
#import "ProductReviewAddCell.h"

@interface ProductReviewDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;

@end

@implementation ProductReviewDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = kLocalizedString(@"Review_detail");
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductEvalationCell" bundle:nil] forCellReuseIdentifier:@"ProductEvalationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductReviewReplyCell" bundle:nil] forCellReuseIdentifier:@"ProductReviewReplyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductReviewAddCell" bundle:nil] forCellReuseIdentifier:@"ProductReviewAddCell"];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.model.productImgUrl)]];
    self.nameLabel.text = self.model.productName;
    self.skuLabel.text = [NSString stringWithFormat:@"  %@  ",self.model.attrValues];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toProductDetail)];
    [_imgView addGestureRecognizer:tap];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProductEvalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductEvalationCell"];
        cell.showLine = NO;
        cell.model = self.model;
        return cell;
    }else if (indexPath.row == 1){
        ProductReviewAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductReviewAddCell"];
        cell.model = self.model.review;
        return cell;
    }
    ProductReviewReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductReviewReplyCell"];
    cell.model = self.model.reply;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? self.model.itemHie : indexPath.row == 1 ? self.model.review.itemHie : self.model.reply.itemHie;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)toProductDetail
{
    ProductViewController *vc = [[ProductViewController alloc] init];
    vc.offerId = [self.model.offerId integerValue];
    vc.productId = self.model.productId.integerValue;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
