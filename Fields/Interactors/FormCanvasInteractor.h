//
//  FormCanvasInteractor.h
//  Fields
//
//  Created by Maria Bernis on 26/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseInteractor.h"

@class Form;
@interface FormCanvasInteractor : BaseInteractor
- (NSFetchRequest *)requestAllFieldsForForm:(Form *)form;
@end
