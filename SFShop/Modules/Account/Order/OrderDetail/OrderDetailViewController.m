//
//  OrderDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/24.
//

#import "OrderDetailViewController.h"
#import "DeliveryInformationCell.h"

@interface OrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Order Details";
    _dataSource = [NSMutableArray array];
    self.view.backgroundColor = RGBColorFrom16(0xf5f5f5);
    [self.view addSubview:self.tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"DeliveryInformationCell" bundle:nil] forCellReuseIdentifier:@"DeliveryInformationCell"];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(16);
        make.right.mas_equalTo(self.view.mas_right).offset(-16);
        make.top.bottom.mas_equalTo(self.view);
    }];
    [self loadDatas];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryInformationCell"];
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (void)loadDatas
{
    
}
@end
