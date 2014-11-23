//
//  BaseInteractor.m
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import "BaseInteractor.h"
#import "MBCoreDataStack.h"
#import "MBCheck.h"

NSString *const FLDErrorDomain = @"com.mariabernis.fields.error";

@implementation BaseInteractor

- (NSManagedObjectContext *)defaultMOC {
    return [NSManagedObjectContext MR_defaultContext];
}

/* Implement in subclass
- (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm
                              ascending:(BOOL)ascending {
    return nil;
}
*/

+ (NSError *)createFLDError:(FLDError)errorCode
       withTitleDescription:(NSString *)displayTitle
       additionalSuggestion:(NSString *)extendedTxt
{
    if ([displayTitle mb_isEmpty]) {
        displayTitle = @"Action not allowed";
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:displayTitle forKey:NSLocalizedDescriptionKey];
    if (![extendedTxt mb_isEmpty]) {
        [dict setValue:extendedTxt forKey:NSLocalizedRecoverySuggestionErrorKey];
    }
    
    NSError *error = [NSError errorWithDomain:FLDErrorDomain code:errorCode userInfo:dict];
    return error;
}

@end