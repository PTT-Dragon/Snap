//
//  HomeViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "HomeViewController.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, readwrite, strong) UITableView *tableView;
@property (nonatomic, readwrite, strong) NSMutableArray *dataArray;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadDatas];
    [self loadsubviews];
    // Do any additional setup after loading the view.
}

- (void)loadDatas {
    SFNet.page.buyer_homepage;
//    [SFNetworkManager get:<#(nonnull NSString *)#> parameters:<#(nullable NSDictionary *)#> success:<#^(id  _Nullable response)success#> failed:<#^(NSError * _Nonnull error)failed#>]
}

- (void)loadsubviews {
    
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Getter
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, navBarHei, self.view.bounds.size.width, self.view.bounds.size.height - navBarHei) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
