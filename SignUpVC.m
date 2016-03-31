//
//  SignUpVC.m
//  SafeTPins
//
//  Created by Vrinsoft_Technolog on 18/02/16.
//  Copyright © 2016 Vrinsoft_Technolog. All rights reserved.
//

#import "SignUpVC.h"

#define NUMBER_ONLY @"1234567890"

//#define kPayPalEnvironment PayPalEnvironmentSandbox

#define kPayPalEnvironment PayPalEnvironmentProduction

@interface SignUpVC ()

@end

@implementation SignUpVC

#pragma mark - ViewDidLoad -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configurePayPal];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    [self setPayPalEnvironment:self.environment];
}



#pragma mark - Paypal Methods -

- (void)configurePayPal
{
//    // Set up payPalConfig
//    _payPalConfig = [[PayPalConfiguration alloc] init];
//    _payPalConfig.acceptCreditCards = YES;
//    _payPalConfig.merchantName = @"iHart Developers";
//    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
//     _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
//
//      // Setting the languageOrLocale property is optional.
//      //
//      // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
//      // its user interface according to the device's current language setting.
//      //
//      // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
//      // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
//      // to use that language/locale.
//      //
//      // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
//      
//      _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
//      
//      
//      // Setting the payPalShippingAddressOption property is optional.
//      //
//      // See PayPalConfiguration.h for details.
//      
//      _payPalConfig.payPalShippingAddressOption =
//      PayPalShippingAddressOptionPayPal;
//      
//      // use default environment, should be Production in real life
//      [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
    
    
    
        _payPalConfig = [[PayPalConfiguration alloc] init];
        _payPalConfig.acceptCreditCards = YES;
        _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
        _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
        _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
        _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    NSLog(@"%@",[NSLocale preferredLanguages]);
    
        // Setting the payPalShippingAddressOption property is optional.
        //
        // See PayPalConfiguration.h for details.
    
      //  _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
        // Do any additional setup after loading the view, typically from a nib.
    
//        self.successView.hidden = YES;
    
        // use default environment, should be Production in real life
        self.environment = PayPalEnvironmentProduction;
    
          [PayPalMobile preconnectWithEnvironment:kPayPalEnvironment];
}

- (void) PayPalCall
{
    // Note: For purposes of illustration, this example shows a payment that includes
    //       both payment details (subtotal, shipping, tax) and multiple items.
    //       You would only specify these if appropriate to your situation.
    //       Otherwise, you can leave payment.items and/or payment.paymentDetails nil,
    //       and simply set payment.amount to your total charge.
    
    // Optional: include multiple items
    PayPalItem *item1 = [PayPalItem
                         itemWithName:@"iOS Application Development"
                         withQuantity:2
                         withPrice:[NSDecimalNumber
                                    decimalNumberWithString:@"0.01"]
                         withCurrency:@"BRL"
                         withSku:@"Hip-00037"];
    
    
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
//    // Optional: include payment details
//    NSDecimalNumber *shipping = [[NSDecimalNumber alloc]
//                                 initWithString:@"0.50"];
//    NSDecimalNumber *tax = [[NSDecimalNumber alloc]
//                            initWithString:@"0.50"];
    PayPalPaymentDetails *paymentDetails =
    [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                        withShipping:nil
                                             withTax:nil];
//
//    NSDecimalNumber *total = [[subtotal
//                               decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = subtotal;
    payment.currencyCode = @"BRL";
    payment.shortDescription = @"Subscription Fee";
    payment.items = items;
    // if not including multiple items, then leave payment.items as nil
    
    payment.paymentDetails = paymentDetails;
    // if not including payment details, then leave payment. paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    PayPalPaymentViewController *paymentViewController =
    [[PayPalPaymentViewController alloc]
     initWithPayment:payment
     configuration:self.payPalConfig
     delegate:self];
    
    [self presentViewController:paymentViewController
                       animated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success! : %@", completedPayment.confirmation);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    strWhichWebService = @"Payment";
    
    NSString *str = [NSString stringWithFormat:@"%@Payment",MAINURL];
    
    APP_DELEGATE.strUserID = [[arrAllData valueForKey:@"user_id"] objectAtIndex:0];
    
    NSDictionary *dic = @{
                          @"UserID" : APP_DELEGATE.strUserID,
                          @"TransactionID" : [[completedPayment.confirmation valueForKey:@"response"] valueForKey:@"id"]
                          };
    
    
    [APP_DELEGATE.webServiceObj callWebService:str dictionarywithdata:dic withType:@"get"];
    APP_DELEGATE.webServiceObj._delegate = self;
    [APP_DELEGATE.HUD show:YES];
}




#pragma mark - Memory Warning -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
