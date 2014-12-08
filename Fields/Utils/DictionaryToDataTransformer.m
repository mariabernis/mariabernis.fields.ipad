
#import "DictionaryToDataTransformer.h"

@implementation DictionaryToDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
    NSData *data = nil;
    if ([NSJSONSerialization isValidJSONObject:value]) {
        data = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
    }
	return data;
}


- (id)reverseTransformedValue:(id)value {
    if (value == nil) return nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:value options:0 error:nil];
	return dict;
}

@end
