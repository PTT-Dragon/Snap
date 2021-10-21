//
//  PolicesDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "PolicesDetailViewController.h"

@interface PolicesDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation PolicesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDatas];
}

- (void)loadDatas
{
    NSString *type = [self.title isEqualToString:@"Membership Agreement"] ? @"A":@"B";
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.agreement parameters:@{@"agreeType":type} success:^(id  _Nullable response) {
        NSString *content = [(NSArray *)response firstObject][@"agreeContent"];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        weakself.contentLabel.attributedText = attrStr;
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
@end
