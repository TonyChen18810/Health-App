//
//  NSString+Extensions.h
//
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)documentsDirectoryPath;
- (NSString *)cacheDirectoryPath;
- (NSString *)privateDirectoryPath;
- (NSString *)pathInDocumentDirectory;
- (NSString *)pathInCacheDirectory;
- (NSString *)pathInPrivateDirectory;
- (NSString *)pathInDirectory:(NSString *)dir cachedData:(BOOL)yesOrNo;
- (NSString *)pathInDirectory:(NSString *)dir;
- (NSString *)removeWhiteSpace;
- (NSString *)stringByNormalizingCharacterInSet:(NSCharacterSet *)characterSet withString:(NSString *)replacement;
- (NSString *)bindSQLCharacters;
- (NSString *)trimSpaces;
- (NSString *)stringByTrimmingLeadingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingLeadingWhitespaceAndNewlineCharacters;
- (NSString *)stringByTrimmingTrailingCharactersInSet:(NSCharacterSet *)characterSet;
- (NSString *)stringByTrimmingTrailingWhitespaceAndNewlineCharacters;
- (NSString *)MD5;
+ (BOOL)validateEmail:(NSString *)candidate;
+ (BOOL)validateForNumericAndCharacets:(NSString *)candidate WithLengthRange:(NSString *)strRange;
+ (BOOL)validatPhoneNumber:(NSString*) phonenum;
+ (BOOL) validatePhone: (NSString *) candidate;
@end
