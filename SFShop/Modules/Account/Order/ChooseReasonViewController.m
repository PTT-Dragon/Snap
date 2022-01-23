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

@end

@implementation ChooseReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CancelOrderReasonCell" bundle:nil] forCellReuseIdentifier:@"CancelOrderReasonCell"];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CancelOrderReasonModel *model = self.dataSource[indexPath.row];
    CancelOrderReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CancelOrderReasonCell"];
    cell.contentLabel.text = model.orderReasonName;
    cell.selBtn.selected = model.sel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath\
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
