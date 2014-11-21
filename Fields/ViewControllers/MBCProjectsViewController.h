//
//  MBCProjectsViewController.h
//  Fields
//
//  Created by Maria Bernis on 19/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBCoreDataCollectionViewController.h"

@interface MBCProjectsViewController : MBCoreDataCollectionViewController
@property (nonatomic, strong) NSArray *collection;
@property (nonatomic, strong) NSString *projectTitle;
@end
