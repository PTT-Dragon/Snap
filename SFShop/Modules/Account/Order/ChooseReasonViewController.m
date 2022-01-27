//
//  ChooseReasonViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/31.
//

#import "ChooseReasonViewController.h"
#import "CancelOrderReasonCell.h"

@interface ChooseReasonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHei;

@end

@implementation ChooseReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CancelOrderReasonCell" bundle:nil] forCellReuseIdentifier:@"CancelOrderReasonCell"];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, App_Frame_Width, iPhoneXBottomOffset)];
    self.tableViewHei.constant = self.dataSource.count * 56+100+iPhoneXBottomOffset;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CancelOrderReasonModel *model = self.dataSource[indexPath.row];
    CancelOrderReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderReasonCell"];
    cell.contentLabel.text = model.orderReasonName;
    cell.selBtn.selected = model.sel;
    cell.selBtn.userInteractionEnabled = NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.dataSource enumerateObjectsUsingBlock:^(CancelOrderReasonModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.sel = NO;
    }];
    CancelOrderReasonModel *model = self.dataSource[indexPath.row];
    model.sel = YES;
    [self.delegate chooseReason:model];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

#pragma mark - <click event>
- (IBAction)dissEvent:(id)sender {
    
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
}

@end
