

#import "UIAlertView+utils.h"
#import "AppDelegate.h"

@implementation UIAlertController(MyAdditions)

+(void)infoAlertWithMessage:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}


+(void)infoAlertWithMessageWithCancel:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller buttonTitle: (NSString*)buttonTitle{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)infoAlertWithokAction:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller completion :(void(^)(BOOL)) okCompletion {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {okCompletion(true);}];
    
    [alert addAction:defaultAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

+(void)infoAlertWithokCancelAction:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller completion :(void(^)(BOOL)) selectCompletion{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:strMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {selectCompletion(true);}];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive
    handler:^(UIAlertAction * action) {selectCompletion(false);}];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [controller presentViewController:alert animated:YES completion:nil];
}

@end
