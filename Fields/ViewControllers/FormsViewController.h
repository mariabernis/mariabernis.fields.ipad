//
//  FormsViewController.h
//  Fields
//
//  Created by Maria Bernis on 22/11/14.
//  Copyright (c) 2014 mariabernis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Project;
@interface FormsViewController : UICollectionViewController
@property (nonatomic, strong) NSArray *collection;
//@property (nonatomic, strong) NSString *projectTitle;
@property (nonatomic, strong) Project *parentProject;
@end
