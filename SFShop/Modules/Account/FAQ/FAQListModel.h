//
//  FAQListModel.h
//  SFShop
//
//  Created by 游挺 on 2021/10/28.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FAQListModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*faqCatgId;
@property (nonatomic,copy) NSString <Optional>*faqCatgName;
@property (nonatomic,copy) NSString <Optional>*fileName;
@property (nonatomic,copy) NSString <Optional>*filePath;
@property (nonatomic,copy) NSString <Optional>*priority;
@property (nonatomic,copy) NSString <Optional>*fileType;
@end

@interface FAQQuestionModel : JSONModel
@property (nonatomic,copy) NSString <Optional>*contentM;
@property (nonatomic,copy) NSString <Optional>*contentP;
@property (nonatomic,copy) NSString <Optional>*faqCatgId;
@property (nonatomic,copy) NSString <Optional>*faqCatgName;
@property (nonatomic,copy) NSString <Optional>*faqId;
@property (nonatomic,copy) NSString <Optional>*faqName;
@property (nonatomic,copy) NSString <Optional>*priority;
@property (nonatomic,copy) NSString <Optional>*state;
/**
 {
     contentM = "<p>Q :Di mana saya memasukkan kode diskon/nomor voucher?</p><p><em><span style=\"font-size:12px\">Where do I input the discount code/voucher number ?</span></em></p><p></p><p>A :Ada dua cara untuk menukarkan kode atau voucher :</p><p>1. Anda dapat menemukannya di menu &quot;Akun&quot;, dan klik &quot;Voucher Saya&quot;, dan &quot;Gunakan Sekarang&quot; lalu pilih produk Anda dan tambahkan ke keranjang belanja Anda, Atau</p><p>2. Anda dapat memilih voucher, pada saat \U201ccheck out\U201d</p><p><em><span style=\"font-size:12px\">There are two ways to redeem a code or voucher : </span></em></p><p><em><span style=\"font-size:12px\">1. You can find it in the &quot;Account&quot; menu, and click on &quot;My Vouchers&quot;, and  \U201cUse Now\U201d  then pick your products and add to your shopping cart, Or</span></em></p><p><em><span style=\"font-size:12px\">2. You can choose a voucher, at the time of \U201ccheck out\U201d</span></em></p>";
     contentP = "<p>Q :Di mana saya memasukkan kode diskon/nomor voucher?</p><p><em><span style=\"font-size:12px\">Where do I input the discount code/voucher number ?</span></em></p><p></p><p>A :Ada dua cara untuk menukarkan kode atau voucher :</p><p>1. Anda dapat menemukannya di menu &quot;Akun&quot;, dan klik &quot;Voucher Saya&quot;, dan &quot;Gunakan Sekarang&quot; lalu pilih produk Anda dan tambahkan ke keranjang belanja Anda, Atau</p><p>2. Anda dapat memilih voucher, pada saat \U201ccheck out\U201d</p><p><em><span style=\"font-size:12px\">There are two ways to redeem a code or voucher : </span></em></p><p><em><span style=\"font-size:12px\">1. You can find it in the &quot;Account&quot; menu, and click on &quot;My Vouchers&quot;, and  \U201cUse Now\U201d  then pick your products and add to your shopping cart, Or</span></em></p><p><em><span style=\"font-size:12px\">2. You can choose a voucher, at the time of \U201ccheck out\U201d</span></em></p>";
     faqCatgId = 1050;
     faqCatgName = Purchase;
     faqId = 1061;
     faqName = "Pembayaran - Di mana saya memasukkan kode diskon/nomor voucher?";
     priority = 13;
     state = Active;
 }
 **/

@end

NS_ASSUME_NONNULL_END
