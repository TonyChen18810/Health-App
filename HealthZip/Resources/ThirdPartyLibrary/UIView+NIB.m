#import "UIView+NIB.h"

@implementation UIView (Extend)

+ (id)loadView
{
	NSArray* objects = [[NSBundle mainBundle] loadNibNamed:[self nibName] owner:self options:nil];
	
	for (id object in objects) {
		if ([object isKindOfClass:self]) {
			return object;
		}
	}
	
	[NSException raise:@"WrongNibFormat" format:@"Nib for '%@' must contain one UIView, and its class must be '%@'", [self nibName], [self class]];	
	
	return nil;
}


+ (NSString*)nibName
{ 
    return [self description]; 
}

@end