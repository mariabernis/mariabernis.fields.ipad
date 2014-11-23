//
//  BaseInteractor.h
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    FLDErrorProjectTitleNil = 1,
}FLDError;

@class NSManagedObjectContext;
@interface BaseInteractor : NSObject
@property (nonatomic, strong) NSManagedObjectContext *defaultMOC;

/* Implement in subclass
- (NSFetchRequest *) requestAllSortedBy:(NSString *)sortTerm
                              ascending:(BOOL)ascending;
*/

+ (NSError *)createFLDError:(FLDError)errorCode;

@end
