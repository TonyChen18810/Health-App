//
//  NSStringNullReplacing.h
//  TruePal
//
//  Created by Parth on 11/06/16.
//  Copyright © 2016 TriState. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSDictionary (NullReplacement)
- (NSDictionary *) dictionaryByReplacingNullsWithString:(NSString*)string;
@end
