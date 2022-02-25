//
//  PolicesDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/21.
//

#import "PolicesDetailViewController.h"

@interface PolicesDetailViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation PolicesDetailViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadDatas];
}

- (void)loadDatas
{
//    NSString *type = [self.title isEqualToString:kLocalizedString(@"MEMBERSHIP_AGREEMENT")] ? @"A":@"B";
    MPWeakSelf(self)
    [SFNetworkManager get:SFNet.h5.agreement parameters:@{@"agreeType":_type} success:^(id  _Nullable response) {
        NSString *content = [(NSArray *)response firstObject][@"agreeContent"];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
//        weakself.contentLabel.attributedText = attrStr;
        weakself.textView.attributedText = attrStr;
    } failed:^(NSError * _Nonnull error) {
        
    }];
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    return YES;
}
@end
