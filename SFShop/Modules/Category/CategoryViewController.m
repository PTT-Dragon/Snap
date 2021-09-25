//
//  CategoryViewController.m
//  SFShop
//
//  Created by MasterFly on 2021/9/24.
//

#import "CategoryViewController.h"
#import "CategorySideTableView.h"
#import "CategorySideModel.h"

@interface CategoryViewController ()
@property (nonatomic, readwrite, strong) CategorySideTableView *sideTableView;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self loadsubviews];
    
//    self.sideTableView.dataArray = @[CategorySideModel.new,CategorySideModel.new];
    // Do any additional setup after loading the view.
}

- (void)loadDatas {
    [SFNetworkManager get:SFNet.page.buyer_displaycatgs parameters:@{@"catgLevel":@"1"} success:^(id  _Nullable response) {
        NSArray *array = response;
        for (NSDictionary *dict in array) {
            CategorySideModel *model = [CategorySideModel yy_modelWithDictionary:dict];
            [self.sideTableView.dataArray addObject:model];
        }
        NSLog(@"");
        [self.sideTableView reloadData];
        [self.sideTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    } failed:^(NSError * _Nonnull error) {
        NSLog(@"");
    }];
}

- (void)loadsubviews {
    [self.view addSubview:self.sideTableView];
}

#pragma mark - Getter
- (CategorySideTableView *)sideTableView {
    if (_sideTableView == nil) {
        _sideTableView = [[CategorySideTableView alloc] initWithFrame:CGRectMake(0, navBarHei, 95, self.view.bounds.size.height - navBarHei - tabbarHei) style:UITableViewStylePlain];
    }
    return _sideTableView;
}
@end
