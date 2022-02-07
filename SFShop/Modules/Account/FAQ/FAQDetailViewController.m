//
//  FAQDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "FAQDetailViewController.h"
#import "BaseNavView.h"
#import "BaseMoreView.h"

@interface FAQDetailViewController ()<BaseNavViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic,strong) BaseNavView *navView;
@property (nonatomic,strong) BaseMoreView *moreView;

@end

@implementation FAQDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)baseNavViewDidClickBackBtn:(BaseNavView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baseNavViewDidClickMoreBtn:(BaseNavView *)navView {
    [_moreView removeFromSuperview];
    _moreView = [[BaseMoreView alloc] init];
    [self.view addSubview:_moreView];
    [_moreView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.navView.mas_bottom);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _navView = [[BaseNavView alloc] init];
    _navView.delegate = self;
    [_navView updateIsOnlyShowMoreBtn:YES];
    [self.view addSubview:_navView];
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(navBarHei);
    }];
    [_navView configDataWithTitle:kLocalizedString(@"Help_center")];
    self.titleLabel.text = self.model.faqName;
    NSAttributedString *attributedString1 = [[NSAttributedString alloc] initWithData:[[NSString stringWithFormat:@"%@",_model.contentM] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSAttributedString *attributedString2 = [[NSAttributedString alloc] initWithData:[_model.contentP dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    self.textView.attributedText = attributedString1;
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
