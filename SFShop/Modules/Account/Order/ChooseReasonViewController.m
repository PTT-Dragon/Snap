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
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ChooseReasonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSource = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CancelOrderReasonCell" bundle:nil] forCellReuseIdentifier:@"CancelOrderReasonCell"];
    [self loadDatas];
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
    CancelOrderReasonModel *model = self.dataSource[indexPath.row];
    [self.delegate chooseReason:model];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:[SFNet.order getReasonlOf:@"1"] success:^(id  _Nullable response) {
        [weakself.dataSource addObjectsFromArray:[CancelOrderReasonModel arrayOfModelsFromDictionaries:response error:nil]];
        [weakself.tableView reloadData];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
