
#import "NSString+MBExtensions.h"

@implementation NSString (MBExtensions)
- (NSString *)mb_stringByEscapingForURLArgument
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    CFStringRef escaped =
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    NSString *result = (__bridge NSString *)escaped;
    CFRelease(escaped);
    return result;
}

- (NSString *)mb_stringByUnescapingFromURLArgument
{
    NSMutableString *resultString = [NSMutableString stringWithString:self];
    [resultString replaceOccurrencesOfString:@"+"
                                  withString:@" "
                                     options:NSLiteralSearch
                                       range:NSMakeRange(0, [resultString length])];
    return [resultString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)mb_isURLString
{
    NSRange match = [self rangeOfString:@"http://"];
    NSRange matchS = [self rangeOfString:@"https://"];
    if (match.length != 0 || matchS.length != 0)
    {
        // We can load web content
        return YES;
    }
    return NO;
}


- (BOOL)mb_stringNoWhitesHasMinimumLenght:(NSInteger)minimumLenght {
    
    BOOL result = NO;
    
    if (self) {
        
        NSString *noWhites=[self mb_trimmedString];
        
        if ([noWhites length] >= minimumLenght) {
            result = YES;
        }
    }
    
    return result;
}

- (NSString *)mb_trimmedString {
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
}

- (BOOL)mb_isEmpty {
    
    if (self == nil || [self length] == 0) {
        return YES;
    }
//    NSString *makeSureString = [NSString stringWithFormat:@"%@", ];
    NSString *trimTxt = [self mb_trimmedString];
    
    if (([trimTxt isEqualToString:@""]) ||
        (trimTxt.length == 0))
    {
        return YES;
    }
    return NO;
}

@end
