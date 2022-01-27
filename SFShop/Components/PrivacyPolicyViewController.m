//
//  PrivacyPolicyViewController.m
//  SFShop
//
//  Created by 游挺 on 2022/1/27.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)request
{
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.agreement parameters:@{@"agreeType":_privacyType} success:^(id  _Nullable response) {
        NSString *content = [(NSArray *)response firstObject][@"agreeContent"];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        weakself.contentLabel.attributedText = attrStr;
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
