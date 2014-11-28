//
//  FormsViewController.h
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCoreDataCollectionViewController.h"

@class Project;
@interface FormsViewController : MBCoreDataCollectionViewController
@property (nonatomic, strong) Project *parentProject;

/* Designated initializer */
- (instancetype)initWithProject:(Project *)project;

@end
