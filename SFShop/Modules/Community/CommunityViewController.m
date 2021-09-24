//
//  CommunityViewController.m
//  SFShop
//
//  Created by Jacue on 2021/9/22.
//

#import "CommunityViewController.h"
#import "CommunityChildController.h"
#import <JKCategories/JKCategories.h>
#import <Masonry/Masonry.h>

@interface CommunityViewController () <VTMagicViewDelegate, VTMagicViewDataSource>

@property(nonatomic, strong) NSArray *menuList;
@property(nonatomic, assign) NSInteger currentMenuIndex;

@end

@implementation CommunityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Community";
    
    self.currentMenuIndex = 0;
    self.menuList = @[@"Recommend", @"Phone", @"House", @"Car", @"Computer", @"Camera"];
    
    self.magicView.navigationColor = [UIColor whiteColor];
    self.magicView.sliderColor = [UIColor jk_colorWithHexString: @"#FF1659"];
    self.magicView.sliderHeight = 1.0f;
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    self.magicView.switchStyle = VTSwitchStyleDefault;
    self.magicView.navigationHeight = 40.f;
    self.magicView.dataSource = self;
    self.magicView.delegate = self;
    
    [self.magicView reloadData];
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
        [menuItem setTitleColor: [UIColor jk_colorWithHexString: @"#7B7B7B"] forState:UIControlStateNormal];
        [menuItem setTitleColor: [UIColor blackColor] forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Trueno" size:17.f];
    }
    [menuItem setSelected: (itemIndex == self.currentMenuIndex)];
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    static NSString *gridId = @"community.childController.identifier";
    CommunityChildController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!gridViewController) {
        gridViewController = [[CommunityChildController alloc] init];
    }
    return gridViewController;
}

/// VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidAppear:%@", (long)pageIndex, viewController.view);
    self.currentMenuIndex = pageIndex;
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    NSLog(@"pageIndex:%ld viewDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}




@end
