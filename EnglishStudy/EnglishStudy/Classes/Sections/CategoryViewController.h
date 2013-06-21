//
//  CategoryViewController.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "SearchControlView.h"

@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) int categotyType;

@end
