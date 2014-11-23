//
//  F2FCheck.m
//  F2F Utils
//
//  Created by Maria Bernis on 04/10/12.
//  Copyright (c) 2012 flash2flash. All rights reserved.
//

#import "MBCheck.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/utsname.h>

@implementation MBCheck

#pragma mark - Form validations
// Validación de correo
+ (BOOL)isValidEmail:(NSString*)email
{
    return [self isValidEmail:email andDifferentFromPlaceholder:nil];
}

+ (BOOL)isValidEmail:(NSString*)email andDifferentFromPlaceholder:(NSString *)placeholder
{
    BOOL resultado = NO;
    
    if ([self isNotEmpty:email andDifferentFromPlaceholder:placeholder])
    {
        NSString *emailRegEx =
        @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
        @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
        @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
        @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
        @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
        @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
        @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        resultado = [emailTest evaluateWithObject:email];
        
    }
    return resultado;
}

+ (BOOL)isEmpty:(NSString *)text
{
    if (text == nil || [text length] == 0) {
        return YES;
    }
    NSString *makeSureString = [NSString stringWithFormat:@"%@",text];
    NSString *trimTxt = [makeSureString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (
        ([trimTxt isEqualToString:@""]) ||
        (trimTxt.length == 0)
        )
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isNotEmpty:(NSString *)text
{
    return [MBCheck isNotEmpty:text andDifferentFromPlaceholder:nil];
}

// Campo rellenado: ni vacío ni rellenado con espacios en blanco
/**
 * @param placeholder es opcional. Si distinto de nil se comprueba 
 * que texto a validar es distinto de placeholder.
 */
+ (BOOL)isNotEmpty:(NSString *)text andDifferentFromPlaceholder:(NSString *)placeholder
{
    if (text == nil) {
        return NO;
    }
    
    NSString *makeSureString = [NSString stringWithFormat:@"%@",text];
    NSString *trimTxt = [makeSureString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ((text != nil) &&
        (![trimTxt isEqualToString:@""]) &&
        (trimTxt.length > 0)
        )
    {
        // Y si hay placeholder, que sea distinto del placeholder...
        if (placeholder != nil)
        {
            if (trimTxt != placeholder)
            {
                return YES;
            }
        }
        else
        {
            return YES;
        }
        
    }    
    return NO;

}

+ (BOOL)isNumeric:(NSString*)string
{
    if ([MBCheck isNotEmpty:string andDifferentFromPlaceholder:nil])
    {
        BOOL result = NO;
        
        NSUInteger tam = [string length];
        
        int i = 0;
        
        while (i<tam)
        {
            NSInteger codigo = [string characterAtIndex:i];
            codigo = codigo - 47;
            if(codigo > 0 && codigo < 11){
                i = i + 1;
                result = YES;
            }else {
                return NO;
            }
        }
        return result;
    }
    return NO;

}

+ (BOOL)isValidLocale:(NSString *)locale
{
    NSUInteger length = locale != nil ? [locale length] : 0;
    BOOL isValid = NO;
    if (length == 2) {
        isValid = [MBCheck isASCIILettersOnly:locale];
    }
    return isValid;
}

+ (BOOL)isASCIILettersOnly:(NSString *)string
{
    if ([self isEmpty:string]) {
        return NO;
    }
    BOOL result = NO;
    NSString *regex = @"^[a-zA-Z]+$";
    result = [self string:string matchesRegex:regex];
    return result;
}

+ (BOOL)isLettersOnly:(NSString *)string
{
    if ([self isEmpty:string]) {
        return NO;
    }
    BOOL result = NO;
    NSString *regex = @"\\P{L}";
    BOOL containsOtherThanLetters = [self string:string matchesRegex:regex];
    result = !containsOtherThanLetters;
    return result;
}

+ (BOOL)string:(NSString *)string matchesRegex:(NSString *)regex
{
    BOOL result = NO;
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    result = [test evaluateWithObject:string];
    return result;
}

// Validacion que puede mandar emails
+ (BOOL)canSendMailAndIsConfigured
{
    // The MFMailComposeViewController class is only available in iPhone OS 3.0 or later.
    // So, we must verify the existence of the above class and provide a workaround for devices running
    // earlier versions of the iPhone OS.
    // We display an email composition interface if MFMailComposeViewController exists and the device
    // can send emails.	Display feedback message, otherwise.
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    BOOL resultado = NO;
    
    if (mailClass != nil) {
        // We must always check whether the current device is configured for sending emails
        if ([mailClass  canSendMail])
        {
            resultado = YES;
        }
    }
    return resultado;
}


#pragma mark - Web services
/* Project specific
+ (BOOL)serverReturnedError:(NSMutableArray*) respuestaParseada
{
    BOOL isError = NO;
    NSMutableDictionary *codeError = [respuestaParseada lastObject];
    NSString *resultado = [codeError objectForKey:kWScode];
    //Simular Errores
    //    NSString *resultado = @"[{\"code\":\"ERR01\",\"desc_error\":\"FALLLLOOOOO\"}]";
    
    if (resultado == nil || (![resultado isEqualToString:@"ERR00"]))
    {
        isError = YES;
    }
    return isError;
}

+ (BOOL)serverReturnedUserId:(NSString *) respuestaString
{
    BOOL isUser = NO;
    
    // Buscar key "paises", si lo hay, hay que pedir pais de registro.
    NSRange matchPaises = [respuestaString rangeOfString:kWSpaises];
    NSRange matchUser = [respuestaString rangeOfString:kWSuser_id];
    if (matchPaises.length != 0)
    {
        isUser = NO;
    }
    else if (matchUser.length != 0)
    {
        isUser = YES;
    }

    return isUser;
}
 */

#pragma mark - Zbarsdk compatibility checks
+ (NSString *) machineName
{
	//	@"i386"      on the simulator
    //  @"x86_64"    on the simulator
	//	@"iPod1,1"   on iPod Touch
	//	@"iPhone1,1" on iPhone
	//	@"iPhone1,2" on iPhone 3G
	//	@"iPhone2,1" on iPhone 3GS
	//	@"iPad1,1"   on iPad
	//	@"iPhone3,1" on iPhone 4.
	struct utsname systemInfo;
	uname(&systemInfo);
	return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (BOOL)isValidVersionForScan
{
    // Not necessary for current Deployment Target (4.2)
    // ZBARSDK requires iOS 3.1 or higher. 4.0 or higher recommended
    NSString *reqSysVer = @"3.1";
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(reqSysVer))
    {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isValidDeviceForScan
{
    NSString *deviceVersion = [self machineName];
    BOOL validOnSimulator = YES;
    // ZBARSDK requires camera with autofocus, ence iPhone 3GS or higher
    if ([deviceVersion isEqualToString:@"iPhone1,2"]||
        [deviceVersion isEqualToString:@"iPhone1,1"]||
        [deviceVersion isEqualToString:@"iPod1,1"])
    {
        return NO;
        
	}
    
    // Try it on simulator
    if (!validOnSimulator)
    {
        if ([deviceVersion isEqualToString:@"i386"]||
            [deviceVersion isEqualToString:@"x86_64"])
        {
            return NO;
        }
    }
    
    return YES;
    
}

+ (BOOL)isValidScan
{
    if ([self isValidDeviceForScan] && [self isValidVersionForScan])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isValidForNSURL:(NSString*)string{

    BOOL isValid=NO;
    
    if ([MBCheck isNotEmpty:string]) {
        NSURL *candidateURL = [NSURL URLWithString:string];
        NSString *scheme=candidateURL.scheme;
        NSString *host=candidateURL.host;
        if (candidateURL && scheme && host) {
            isValid=YES;
        }
    }

    return isValid;
}

+(NSString*)validStringForNSURLTryingCompletion:(NSString*)stringUrl{

    NSString *stringReturn=nil;
    
    if (stringUrl && [self isValidForNSURL:stringUrl]) {
        stringReturn=stringUrl;
    }else{
        NSString *stringUrlTryingCompletion=[NSString stringWithFormat:@"http://%@", stringUrl];
        if ([self isValidForNSURL:stringUrlTryingCompletion]) {
            stringReturn=stringUrlTryingCompletion;
        }
    }
    
    return stringReturn;
    
}

+(NSURL*)validNSURLForStringTryingCompletion:(NSString*)stringUrl{
    
    NSString *testString=[self validStringForNSURLTryingCompletion:stringUrl];
    
    if (testString) {
        return [NSURL URLWithString:testString];
    }else{
        return nil;
    }
    
}

@end
