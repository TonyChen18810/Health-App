

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIAlertController(MyAdditions)
+(void)infoAlertWithMessage:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller;
+(void)infoAlertWithMessageWithCancel:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller buttonTitle: (NSString*)buttonTitle;
+(void)infoAlertWithokAction:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller completion :(void(^)(BOOL)) okCompletion;
+(void)infoAlertWithokCancelAction:(NSString*)strMessage andTitle:(NSString*)title controller:(UIViewController*)controller completion :(void(^)(BOOL)) selectCompletion;
@end
