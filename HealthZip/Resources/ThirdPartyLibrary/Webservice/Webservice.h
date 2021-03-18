
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "NSString+AESEncryption.h"
#import "UIAlertView+utils.h"

typedef void(^ResponseReceivedSuccessfully)(NSMutableDictionary *dict);
typedef void(^ResponseFail)(NSError *error);
typedef void(^DataRateProgress)(float progressInPercent);
@protocol WebserviceDelegate;

@interface Webservice : NSObject {
	NSURLConnection *conn;
	NSMutableData *mutableData;
    BOOL busy;
    long long expectedContentLength;
    BOOL encryptionOn;
}

@property (nonatomic) NSInteger tagWebservice;
@property (nonatomic) BOOL busy;
@property (nonatomic,strong) ResponseReceivedSuccessfully responseSuccessful;
@property (nonatomic,strong) ResponseFail responseFail;
@property (nonatomic,strong) DataRateProgress progressblock;

-(void)cancelWebservice;

-(void) callGetWebServiceUsingURL:(NSURL *) url onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;

-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;

-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock;

-(void)callJSONMethod:(NSString *)methodName withVideo:(NSData*)videoData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock;

-(void)callJSONMethod:(NSString *)methodName withFilePathArray:(NSMutableArray*)imagePathArray andParams:(NSMutableDictionary*)params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;


-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params   onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam;


@end

