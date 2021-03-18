//
//  NSStringNullReplacing.m
//  TruePal
//
//  Created by Parth on 11/06/16.
//  Copyright © 2016 TriState. All rights reserved.
//
#import "NullReplacement.h"
#import "NULLValidation.h"
@implementation NSDictionary (NullReplacement)

- (NSDictionary *) dictionaryByReplacingNullsWithString:(NSString*)string {
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    
    NSString *blank = string;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isNull]) {
            [replaced setObject:blank forKey: key];
        }
        else if ([obj isKindOfClass: [NSDictionary class]]) {
            [replaced setObject: [(NSDictionary *) obj dictionaryByReplacingNullsWithString:string] forKey: key];
        }
    }];
    
    return replaced ;
}
@end
