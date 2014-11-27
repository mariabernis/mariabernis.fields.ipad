//
//  FieldTypesProvider.h
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FieldTypesProvider : NSObject
- (void)loadFieldTypesWithCompletion:(void(^)(NSArray *fieldTypes, NSError *error))completionBlock;
@end
