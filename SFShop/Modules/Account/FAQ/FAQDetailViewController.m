//
//  FAQDetailViewController.m
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "FAQDetailViewController.h"

@interface FAQDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FAQDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Help Center";
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
