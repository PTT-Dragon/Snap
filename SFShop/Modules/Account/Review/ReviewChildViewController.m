//
//  ReviewChildViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "ReviewChildViewController.h"
#import "OrderModel.h"

@interface ReviewChildViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation ReviewChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSource = [NSMutableArray array];
    [self loadDatas];
}
- (void)loadDatas
{
    NSString *evaluateFlag = _type == 1 ? @"N": @"Y";
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.order.list parameters:@{@"evaluateFlag":evaluateFlag} success:^(id  _Nullable response) {
        NSArray *arr = response[@"list"];
        for (NSDictionary *dic in arr) {
            [weakself.dataSource addObject:[[OrderModel alloc] initWithDictionary:dic error:nil]];
            
        }
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
