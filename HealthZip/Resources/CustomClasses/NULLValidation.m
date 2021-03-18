//
//  NullValidation.m
//  TruePal
//
//  Created by Parth on 11/06/16.
//  Copyright © 2016 TriState. All rights reserved.
//

#import "NULLValidation.h"

@implementation NSObject (NULLValidation)

- (BOOL)isNull{
    if (!self) return YES;
    else if (self == [NSNull null]) return YES;
    else if ([self isKindOfClass:[NSString class]]) {
        return ([((NSString *)self)isEqualToString : @""]
                || [((NSString *)self)isEqualToString : @"null"]
                || [((NSString *)self)isEqualToString : @"<null>"]
                || [((NSString *)self)isEqualToString : @"(null)"]
                );
    }
    return NO;
    
}
@end
