//
//  FlashSaleViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/12/10.
//

#import "FlashSaleViewController.h"
#import <VTMagic/VTMagic.h>
#import "FlashSaleChildViewController.h"
#import "FlashSaleModel.h"

@interface FlashSaleViewController ()<VTMagicViewDelegate, VTMagicViewDataSource>
@property (nonatomic,strong) VTMagicController *magicController;
@property(nonatomic, strong) NSMutableArray *menuList;
@property(nonatomic, strong) NSMutableArray *dateArr;
@property(nonatomic, assign) NSInteger currentMenuIndex;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FlashSaleViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = kLocalizedString(@"FLASH_DEAL");
    [self loadDatas];
}
- (void)loadDatas
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.flashSale.next parameters:@{} success:^(id  _Nullable response) {
        weakself.dateArr = [FlashSaleDateModel arrayOfModelsFromDictionaries:response error:nil];
        [weakself initUI];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initUI
{
    _menuList = [NSMutableArray array];
    for (FlashSaleDateModel *dateModel in self.dateArr) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *nowDate = [formatter dateFromString:dateModel.now];
        NSTimeInterval timeInterval = [nowDate timeIntervalSince1970];
        
        NSDate *effDate = [formatter dateFromString:dateModel.effDate];
        NSTimeInterval effTimeInterval = [effDate timeIntervalSince1970];
        
        NSDate *expDate = [formatter dateFromString:dateModel.expDate];
        NSTimeInterval expTimeInterval = [expDate timeIntervalSince1970];
        NSString *str ;
        if (effTimeInterval > timeInterval) {
            //未开始
            str = kLocalizedString(@"Coming_soon");
        }else if (expTimeInterval > timeInterval){
            //进行中
            str = kLocalizedString(@"ON_going");
        }else{
            //已结束
            
        }
        NSString *title = [NSString stringWithFormat:@"%@\n%@",dateModel.campaignName,str];
        [_menuList addObject:title];
    }
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    _magicController.view.frame = CGRectMake(0, navBarHei+100, MainScreen_width, MainScreen_height-navBarHei-100);
    [_magicController.magicView reloadData];
}
/// VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return self.menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor: [UIColor jk_colorWithHexString: @"#bbbbbb"] forState:UIControlStateNormal];
        [menuItem setTitleColor: [UIColor whiteColor] forState:UIControlStateSelected];
        menuItem.titleLabel.numberOfLines = 2;
        menuItem.titleLabel.textAlignment = NSTextAlignmentCenter;
        menuItem.titleLabel.font = kFontBlod(14);
    }
    [menuItem setSelected: (itemIndex == self.currentMenuIndex)];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"myFavorite.childController.identifier";
    FlashSaleChildViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//    if (!gridViewController) {
        gridViewController = [[FlashSaleChildViewController alloc] init];
    gridViewController.selDateModel = self.dateArr[pageIndex];
//    }
    return gridViewController;
}

/// VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
    self.currentMenuIndex = pageIndex;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
//    viewController.view.frame = magicView.bounds;
    NSLog(@"pageIndex:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)shareAction:(id)sender {
    NSString *shareUrl = [NSString stringWithFormat:@"%@/spike",Host];
    [[MGCShareManager sharedInstance] showShareViewWithShareMessage:shareUrl];
}

- (VTMagicController *)magicController
{
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        _magicController.magicView.navigationColor = [UIColor clearColor];
        _magicController.magicView.sliderColor = [UIColor whiteColor];
        _magicController.magicView.layoutStyle = VTLayoutStyleCenter;
        _magicController.magicView.switchStyle = VTSwitchStyleDefault;
        _magicController.magicView.navigationHeight = 80.f;
        _magicController.magicView.itemSpacing = 20;
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
        _magicController.magicView.scrollEnabled = NO;
    }
    return _magicController;
}
@end
