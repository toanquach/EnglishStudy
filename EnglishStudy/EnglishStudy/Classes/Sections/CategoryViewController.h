//
//  CategoryViewController.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchControlView.h"

@interface CategoryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, SearchControlViewDelegate>

@property (nonatomic) int categotyType;

@end
