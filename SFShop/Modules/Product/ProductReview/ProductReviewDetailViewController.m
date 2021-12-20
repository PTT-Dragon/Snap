//
//  ProductReviewDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/17.
//

#import "ProductReviewDetailViewController.h"
#import "ProductEvalationCell.h"
#import "ProductReviewReplyCell.h"

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
    self.title = @"Review Detail";
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductEvalationCell" bundle:nil] forCellReuseIdentifier:@"ProductEvalationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ProductReviewReplyCell" bundle:nil] forCellReuseIdentifier:@"ProductReviewReplyCell"];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(self.model.productImgUrl)]];
    self.nameLabel.text = self.model.productName;
//    NSDictionary *dic = [self.model.productName jk_dictionaryValue];
//    self.skuLabel.text = [NSString stringWithFormat:@"  %@  ",dic.allValues.firstObject];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+(self.model.reply?1:0);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        ProductEvalationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductEvalationCell"];
        cell.model = self.model;
        return cell;
    }
    ProductReviewReplyCell *cell = [[ProductReviewReplyCell alloc] init];
    cell.model = self.model.reply;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? self.model.itemHie : self.model.reply.itemHie; 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
