//
//  EmptyViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/3/3.
//

#import "EmptyViewController.h"
#import "EmptyView.h"

@interface EmptyViewController ()
@property (nonatomic,strong) EmptyView *emptyView;
@property (nonatomic, strong) UIButton *gotoShopping;
@end

@implementation EmptyViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(140);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    [self.view addSubview:self.gotoShopping];
    [self.gotoShopping mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(24);
        make.right.bottom.mas_offset(-24);
        make.height.mas_offset(46);
    }];
}
#pragma mark - <click event>
- (void)gotoShoppingEvent{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.tabVC setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (EmptyView *)emptyView {
    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] init];
        [_emptyView configDataWithEmptyType:EmptyViewNoPageType];
        _emptyView.hidden = NO;
    }
    return _emptyView;
}
- (UIButton *)gotoShopping{
    
    if (!_gotoShopping) {
        
        _gotoShopping = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gotoShopping setTitle:kLocalizedString(@"Go_Shopping") forState:UIControlStateNormal];
        [_gotoShopping setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_gotoShopping setBackgroundColor:[UIColor jk_colorWithHexString:@"FF1659"]];
        [_gotoShopping addTarget:self action:@selector(gotoShoppingEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }return _gotoShopping;
}
@end
