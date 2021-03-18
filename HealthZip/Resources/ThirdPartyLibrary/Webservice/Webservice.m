

#import "Webservice.h"
#import "Constants.h"
#import "NSString+Extensions.h"
#import "AppDelegate.h"
#import "NullReplacement.h"

#define CURRENT_APPVERSION_KEY @"version_key_iphone"
#define DEVICE_TOKEN @"device_token"

@implementation Webservice

@synthesize busy;
@synthesize responseSuccessful;
@synthesize responseFail;
@synthesize tagWebservice;
//Change
-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
    NSString * strCurrentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [params setObject:strCurrentAppVersion forKey:CURRENT_APPVERSION_KEY];
    
    NSString *token = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]];
    if ([token isEqualToString:@""]) {
         [params setObject:@"" forKey:DEVICE_TOKEN];
    }
    else
    {
        [params setObject:token forKey:DEVICE_TOKEN];
    }
   
    
    busy = YES;
    NSURL *url=nil;
    [self cancelWebservice];
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    encryptionOn=true;
    if(encryptionOn) {
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
        NSLog(@"Encrypted URL ->>>>>>>>>>>>>>>>> %@",url);
    }else{
        url = [NSURL URLWithString:WEBSERVICE_URL];
        NSLog(@"Not Encrypted URL ->>>>>>>>>>>>>>>>> %@",url);
    }
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
    if(encryptionOn){
        NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
        NSString* returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        strRequest = [NSString stringWithFormat:@"json=%@",[returnString applyLocalEncryption]];
        NSLog(@"Encrypted Request ->>>>>>>>>>>>>>>>> %@",strRequest);
    }else{
        strRequest = [NSString stringWithFormat:@"json=%@",strRequest];
        NSLog(@"Not Encrypted Request ->>>>>>>>>>>>>>>> %@",strRequest);
    }

    
    NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
	[request setHTTPBody:data];
    
	mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


-(void)callJSONMethod:(NSString *)methodName withImage:(NSData*)imageData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock
{
    NSString * strCurrentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [params setObject:strCurrentAppVersion forKey:CURRENT_APPVERSION_KEY];
   
    NSString *token = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]];
    if ([token isEqualToString:@""]) {
        [params setObject:@"" forKey:DEVICE_TOKEN];
    }
    else
    {
        [params setObject:@"" forKey:DEVICE_TOKEN];
    }

    busy = YES;
    NSURL *url=	nil;
    [self cancelWebservice];
    encryptionOn=isencrypted;
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    self.progressblock=proBlock;
     encryptionOn=true;
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url=[NSURL URLWithString:WEBSERVICE_URL];
    
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    
   
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    
  
  //  strRequest = [NSString stringWithFormat:@"json=%@",[strRequest applyLocalEncryption]];
    strRequest = [NSString stringWithFormat:@"%@",[strRequest applyLocalEncryption:NO]];
    NSLog (@"decrepted : %@",[strRequest applyLocalDecryption]);
    NSMutableData *body = [NSMutableData data];
    NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     NSString *paramsFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"json"];
    [body appendData:[paramsFormat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//
//    // file
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"pi_uploaded_image\"; filename=\"temp.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
//      NSString* returnString = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
   
//
//    NSString* returnString = [[NSString alloc] initWithData:body encoding:NSASCIIStringEncoding];
//    strRequest = [NSString stringWithFormat:@"json=%@",[returnString applyLocalEncryption]];
//    NSData *datas = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:datas];
//    mutableData = [[NSMutableData alloc] init];
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}



-(void)callJSONMethod:(NSString *)methodName withVideo:(NSData*)videoData andParams:(NSMutableDictionary*)params isEncrpyted:(BOOL)isencrypted  onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam onProgress:(void(^)(float progressInPercent)) proBlock
{
    NSString * strCurrentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [params setObject:strCurrentAppVersion forKey:CURRENT_APPVERSION_KEY];
   
    NSString *token = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]];
    if ([token isEqualToString:@""]) {
        [params setObject:@"" forKey:DEVICE_TOKEN];
    }
    else
    {
        [params setObject:token forKey:DEVICE_TOKEN];
    }

    busy = YES;
    NSURL *url=	nil;
    [self cancelWebservice];
    encryptionOn=isencrypted;
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    self.progressblock=proBlock;
    encryptionOn=true;
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url=[NSURL URLWithString:WEBSERVICE_URL];
    
	NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	NSString *boundary = [NSString stringWithFormat:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    NSMutableData *body = [NSMutableData data];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
	


    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    strRequest = [NSString stringWithFormat:@"%@",strRequest];
//strRequest = [NSString stringWithFormat:@"json=%@",strRequest];
    
	NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *paramsFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"json"];
    [body appendData:[paramsFormat dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //Video File
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"pi_uploaded_Video\"; filename=\"temp.mov\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:videoData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    mutableData = [[NSMutableData alloc] init];
	conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}




-(void) callGetWebServiceUsingURL:(NSURL *) url onSuccessfulResponse:(void (^)(NSMutableDictionary *dict)) responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
    [self cancelWebservice];
     busy = YES;
     encryptionOn=NO;
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    
    mutableData = [[NSMutableData alloc] init];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)cancelWebservice{
    busy = NO;
    if(mutableData){
        [mutableData setLength:0];
        mutableData = nil;
    }
    if(conn){
        [conn cancel];
        conn = nil;
    }
    self.responseFail=nil;
    self.responseSuccessful=nil;
    self.progressblock=nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)conection didReceiveResponse:(NSURLResponse *)response{
    expectedContentLength = response.expectedContentLength;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    [mutableData appendData:data];
//    NSString* returnString = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
     busy = NO;
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		
		conn = nil;
	}
	
	self.responseFail(error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    busy = NO;
	NSString* returnString = [[NSString alloc] initWithData:mutableData encoding:NSUTF8StringEncoding];
    
    
    if(encryptionOn)
        returnString = [returnString applyLocalDecryption];
//        returnString=[returnString convertToPlainTextDirect:mutableData];
    
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u0022__" withString:@"''"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u0026__" withString:@"&"];
    returnString = [returnString stringByReplacingOccurrencesOfString:@"__u000a__" withString:@"\\n"];
   
    NSData *data = [returnString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    
//    dict=[dict dictionaryByReplacingNullsWithString:@""].mutableCopy;
//    if ([[dict objectForKey:@"data"] isKindOfClass:[NSMutableArray class]]) {
//        for (int i = 0; i < [[dict objectForKey:@"data"] count] ; i++) {
//            NSMutableDictionary *dictCopy =[[dict objectForKey:@"data"] objectAtIndex:i];
//            dictCopy =[dictCopy dictionaryByReplacingNullsWithString:@""].mutableCopy;
//            [[dict objectForKey:@"data"] replaceObjectAtIndex:i withObject:dictCopy];
//        }
//    }
    NSLog(@"Response Dictionary Connection ->>>>>>>>>>>>>>>>>>>>>>>>>>>>> \n%@",dict);
    
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		conn = nil;
	}
    
    if ([[dict objectForKey:@"status"] isEqualToString:@"-1"]){
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        [UIAlertController infoAlertWithMessage:[dict objectForKey:@"message"] andTitle:APPNAME controller:[[appDelegate window]rootViewController]];
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    }
    else
        self.responseSuccessful(dict);

}

- (void)connection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
    if(self.progressblock){
        
        float percent=totalBytesWritten*100.0f/totalBytesExpectedToWrite;
        NSLog(@"PER - %f",percent);
        self.progressblock(percent);
    }
}


-(void)dealloc{
    if(mutableData){
		[mutableData setLength:0];
		mutableData = nil;
	}
	if(conn){
		conn = nil;
	}
    
    self.responseFail=nil;
    self.responseSuccessful=nil;
    self.progressblock=nil;
  
}

-(NSString *) getJsonFromDictionary:(NSDictionary *) dictData
{
    NSString *jsonString=nil;
    NSError *error=nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}


-(id) getJsonDictFromString:(NSString *)strPatam
{
  NSData *data = [strPatam dataUsingEncoding:NSUTF8StringEncoding];
  id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

#pragma  mark -Multiple IMAGES Uploading Method-

-(void)callJSONMethod:(NSString *)methodName withFilePathArray:(NSMutableArray*)imagePathArray andParams:(NSMutableDictionary*)params onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
    NSString * strCurrentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [params setObject:strCurrentAppVersion forKey:CURRENT_APPVERSION_KEY];
    NSString *token = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]];
    if ([token isEqualToString:@""]) {
        [params setObject:@"" forKey:DEVICE_TOKEN];
    }
    else
    {
        [params setObject:token forKey:DEVICE_TOKEN];
    }
    NSURL *url=nil;
    busy = YES;
    encryptionOn=true;
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url = [NSURL URLWithString:WEBSERVICE_URL];
    
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = [NSString stringWithFormat:@"%@",@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    
//    //    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:nil];
//    //    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
//    NSString *strRequest = [NSString stringWithFormat:@"%@",[requestDict JSONRepresentation]];
//    
//    //	NSString *strRequest = [NSString stringWithFormat:@"%@",[requestDict JSONRepresentation]];

    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    strRequest = [NSString stringWithFormat:@"json=%@",strRequest];

    
    NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *paramsFormat = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",@"json"];
    [body appendData:[[NSString stringWithFormat:@"%@",paramsFormat] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    [body appendData:[[NSString stringWithFormat:@"%@",@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // file
    
    for(NSInteger i =0; i<imagePathArray.count; i++){
        NSString *filePath = [imagePathArray objectAtIndex:i];
        NSString *fileName = [filePath lastPathComponent];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"%@_%d\"; filename=\"%@\"\r\n",@"pi_uploaded_image",(int)i,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *data = [NSData dataWithContentsOfFile:[filePath pathInCacheDirectory]];
        [body appendData:[NSData dataWithData:data]];
        [body appendData:[[NSString stringWithFormat:@"%@",@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


#pragma mark - FITBIT WEBSERVICE -

-(void)callJSONMethod: (NSString *)methodName withParameters: (NSMutableDictionary *) params   onSuccessfulResponse:(void (^)(NSMutableDictionary *dict))responseSuccessfullyReceived onFailure:(void(^)(NSError *error))responseFailparam
{
    NSString * strCurrentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [params setObject:strCurrentAppVersion forKey:CURRENT_APPVERSION_KEY];
    
    NSString *token = [NSString stringWithFormat:@"%@",[USERDEFAULTS valueForKey:USERDEFAULT_DEVICE_TOKEN]];
    if ([token isEqualToString:@""]) {
        [params setObject:@"" forKey:DEVICE_TOKEN];
    }
    else
    {
        [params setObject:token forKey:DEVICE_TOKEN];
    }
    
    
    busy = YES;
    NSURL *url=nil;
    [self cancelWebservice];
    self.responseSuccessful=responseSuccessfullyReceived;
    self.responseFail=responseFailparam;
    encryptionOn=true;
    if(encryptionOn)
        url=[NSURL URLWithString:WEBSERVICE_URL_ENCRYPTED];
    else
        url = [NSURL URLWithString:WEBSERVICE_URL];
    
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSMutableDictionary *requestDict = [NSMutableDictionary dictionary];
    [requestDict setObject:methodName forKey:@"method_name"];
    [requestDict setObject:params forKey:@"body"];
    //    NSString *strRequest =nil;
    //    NSString *jsonString=[requestDict NSJSONRepresentation];
    //    if(isencrypted){}
    ////        strRequest = [NSString stringWithFormat:@"json=%@",[jsonString convertToCipherTextDirectWithNumber:NO]];
    //	else
    //        strRequest = [NSString stringWithFormat:@"json=%@",jsonString];
    NSError *error = nil;
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestDict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *strRequest = [[NSString alloc] initWithData:requestData encoding:NSUTF8StringEncoding];
    strRequest = [NSString stringWithFormat:@"json=%@",strRequest];
    
    NSData *data = [strRequest dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    mutableData = [[NSMutableData alloc] init];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
