//
//  F2FCheck.h
//  F2F Utils
//
//  Created by Maria Bernis on 04/10/12.
//  Copyright (c) 2012 flash2flash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NSString+MBExtensions.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define  IS_3_5INCHS_SCREEN ([[UIScreen mainScreen] bounds].size.height == 480.0f)
#define  IS_4_0INCHS_SCREEN ([[UIScreen mainScreen] bounds].size.height == 568.0f)

#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

/**
 *  Provides helpful methods for common validation tasks. 
 */
@interface MBCheck : NSObject

+ (BOOL)isValidEmail:(NSString*)email;
+ (BOOL)isValidEmail:(NSString*)email andDifferentFromPlaceholder:(NSString *)placeholder;
+ (BOOL)isEmpty:(NSString *)text;
+ (BOOL)isNotEmpty:(NSString *)text;
+ (BOOL)isNotEmpty:(NSString *)text andDifferentFromPlaceholder:(NSString *)placeholder;
+ (BOOL)isNumeric:(NSString*)string;
+ (BOOL)isValidLocale:(NSString *)locale;
+ (BOOL)isASCIILettersOnly:(NSString *)string;
+ (BOOL)isLettersOnly:(NSString *)string;
+ (BOOL)isValidScan;
+ (NSString *) machineName;
+ (BOOL)isValidVersionForScan;
+ (BOOL)isValidDeviceForScan;
+ (BOOL)canSendMailAndIsConfigured;
+ (BOOL)isValidForNSURL:(NSString*)string;
+(NSString*)validStringForNSURLTryingCompletion:(NSString*)stringUrl;
+(NSURL*)validNSURLForStringTryingCompletion:(NSString*)stringUrl;

@end
