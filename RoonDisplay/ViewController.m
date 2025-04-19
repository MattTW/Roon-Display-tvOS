//
//  ViewController.m
//  Browser
//

#import "ViewController.h"


@interface ViewController ()
@property id webview;
@end

@implementation ViewController


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // SET YOUR ROON WEB DISPLAY URL HERE
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: @"http://192.168.2.239:9100/display/"]]];
}


-(void)initWebView {

    self.view.insetsLayoutMarginsFromSafeArea = NO;
    self.additionalSafeAreaInsets = UIEdgeInsetsZero;
    self.webview = [[NSClassFromString(@"UIWebView") alloc] init];
    [self.webview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.webview setClipsToBounds:NO];
    

    [self.browserContainerView addSubview: self.webview];

    [self.webview setFrame:self.view.frame];
    [self.webview setDelegate:self];
    [self.webview setLayoutMargins:UIEdgeInsetsZero];
    UIScrollView *scrollView = [self.webview scrollView];
    [scrollView setLayoutMargins:UIEdgeInsetsZero];
    scrollView.insetsLayoutMarginsFromSafeArea = NO;
    scrollView.contentInsetAdjustmentBehavior = NO;

    scrollView.contentOffset = CGPointZero;
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.frame = self.view.frame;
    scrollView.clipsToBounds = NO;
    [scrollView setNeedsLayout];
    [scrollView layoutIfNeeded];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    scrollView.bounces = YES;
    scrollView.panGestureRecognizer.allowedTouchTypes = @[ @(UITouchTypeIndirect) ];
    scrollView.scrollEnabled = NO;

    [self.webview setUserInteractionEnabled:NO];
}

-(void)viewDidLoad {
    self.definesPresentationContext = YES;
    [self initWebView];
    [super viewDidLoad];
}

#pragma mark - Menus

-(void)showSetRoonURLMenu
{
    UIAlertController *alertController2 = [UIAlertController
                                           alertControllerWithTitle:@"Enter Roon Web Display URL"
                                           message:@""
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController2 addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.keyboardType = UIKeyboardTypeURL;
         textField.placeholder = @"Enter Roon Web Display URL";
         textField.textColor = [UIColor blackColor];
         textField.backgroundColor = [UIColor whiteColor];
         [textField setReturnKeyType:UIReturnKeyDone];
         [textField addTarget:self
                       action:@selector(alertTextFieldShouldReturn:)
             forControlEvents:UIControlEventEditingDidEnd];
         
     }];
    
    
    UIAlertAction *loadAction = [UIAlertAction
                               actionWithTitle:@"Load"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *urltextfield = alertController2.textFields[0];
                                   NSString *toMod = urltextfield.text;
                                   
                                   if (![toMod isEqualToString:@""]) {
                                       if ([toMod containsString:@"http://"] || [toMod containsString:@"https://"]) {
                                           [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", toMod]]]];
                                       }
                                       else {
                                           [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", toMod]]]];
                                       }
                                   }
                                   else {
                                       [self showSetRoonURLMenu];
                                   }
                                   
                               }];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];

    
    [alertController2 addAction:loadAction];
    [alertController2 addAction:cancelAction];
    
    [self presentViewController:alertController2 animated:YES completion:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UITextField *urltextfield = alertController2.textFields[0];
            [urltextfield becomeFirstResponder];
        });
        
    }];
    
    
    
    
}

-(void)showQuickMenu
{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Quick Menu"
                                          message:@""
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *inputAction = [UIAlertAction
                                  actionWithTitle:@"Set Roon Display URL"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {
                                      
                                      [self showSetRoonURLMenu];
                                      
                                  }];
    
    UIAlertAction *reloadAction = [UIAlertAction
                                   actionWithTitle:@"Reload Page"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self.webview reload];
                                   }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                   }];
    
    
    UIAlertAction *clearCacheAction = [UIAlertAction
                                       actionWithTitle:@"Clear Cache"
                                       style:UIAlertActionStyleDestructive
                                       handler:^(UIAlertAction *action)
                                       {
                                           [[NSURLCache sharedURLCache] removeAllCachedResponses];
                                           [[NSUserDefaults standardUserDefaults] synchronize];
                                           [self.webview reload];
                                           
                                       }];
    UIAlertAction *clearCookiesAction = [UIAlertAction
                                         actionWithTitle:@"Clear Cookies"
                                         style:UIAlertActionStyleDestructive
                                         handler:^(UIAlertAction *action)
                                         {
                                             NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
                                             for (NSHTTPCookie *cookie in [storage cookies]) {
                                                 [storage deleteCookie:cookie];
                                             }
                                             [[NSUserDefaults standardUserDefaults] synchronize];
                                             [self.webview reload];
                                             
                                         }];
    
    
    [alertController addAction:inputAction];
    
    NSURLRequest *request = [self.webview request];
    if (request != nil) {
        if (![request.URL.absoluteString  isEqual: @""]) {
            [alertController addAction:reloadAction];

        }
    }
    
    [alertController addAction:clearCacheAction];
    [alertController addAction:clearCookiesAction];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];

}

#pragma mark - Web Page load error

- (void)webView:(id)webView didFailLoadWithError:(NSError *)error {
    if (![[NSString stringWithFormat:@"%lid", (long)error.code] containsString:@"999"] && ![[NSString stringWithFormat:@"%lid", (long)error.code] containsString:@"204"]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Could Not Load Roon Display URL"
                                              message:[error localizedDescription]
                                              preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *reloadAction = [UIAlertAction
                                       actionWithTitle:@"Reload Page"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self.webview reload];
                                       }];
        UIAlertAction *newurlAction = [UIAlertAction
                                       actionWithTitle:@"Set a New Roon Display URL"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self showSetRoonURLMenu];
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Dismiss"
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                       }];
        NSURLRequest *request = [self.webview request];
        if (request != nil) {
            if (![request.URL.absoluteString  isEqual: @""]) {
                [alertController addAction:reloadAction];
            }
            else {
                [alertController addAction:newurlAction];
            }
        }
        else {
            [alertController addAction:newurlAction];
        }
        
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)alertTextFieldShouldReturn:(UITextField *)sender
{
    [sender resignFirstResponder];
    
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        [alertController becomeFirstResponder];
    }
}

- (id)findFirstResponder
{
    if (self.isFirstResponder) {
        return self;
    }
    for (UIView *subView in self.view.subviews) {
        if ([subView isFirstResponder]) {
            return subView;
        }
    }
    return nil;
}


#pragma mark - inputs handling

-(void)pressesEnded:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    
    
    if (presses.anyObject.type == UIPressTypePlayPause)
    {
        UIView *firstRes = [self findFirstResponder];
        
        if(firstRes != nil && [firstRes isKindOfClass:[UITextField class]]) {
            [firstRes endEditing:YES];
            return;
        }
        
        UIViewController *vc = (UIViewController *)self.presentedViewController;
        if (vc)
        {
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            return;
        }
        
        [self showQuickMenu];
    }
}


@end
