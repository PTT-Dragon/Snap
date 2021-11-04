//
//  CartChooseAddressViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartChooseAddressViewController.h"
#import "CartChooseAddressCell.h"

@interface CartChooseAddressViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHei;

@end

@implementation CartChooseAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"CartChooseAddressCell" bundle:nil] forCellReuseIdentifier:@"CartChooseAddressCell"];
    self.tableViewHei.constant = self.addressListArr.count * 66;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressListArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartChooseAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartChooseAddressCell"];
    [cell setContent:self.addressListArr[indexPath.row]];
    MPWeakSelf(self)
    cell.selBlock = ^(addressModel *model) {
        if (weakself.selBlock) {
            weakself.selBlock(model);
            [weakself closeAction:nil];
        }
    };
    return cell;
}

- (IBAction)closeAction:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
- (IBAction)anotherAddressAction:(UIButton *)sender {
}

@end
