
#import <Foundation/Foundation.h>

/**
 *  This category adds convenient methods to Foundation's NSString class.
 */
@interface NSString (MBExtensions)
- (NSString*)mb_stringByEscapingForURLArgument;
- (NSString*)mb_stringByUnescapingFromURLArgument;
- (BOOL)mb_isURLString;
- (BOOL)mb_stringNoWhitesHasMinimumLenght:(NSInteger)minimumLenght;
- (NSString *)mb_trimmedString;
//- (BOOL)mb_isEmpty;
@end
