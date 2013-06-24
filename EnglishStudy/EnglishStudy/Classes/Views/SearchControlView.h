//
//  SearchControlView.h
//  EnglishStudy
//
//  Created by Toan.Quach on 6/21/13.
//  Copyright (c) 2013 Toan Quach. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchControlViewDelegate <NSObject>

@optional

- (void)SearchControlViewWithKeyword:(NSString *)keyword;

@end

@interface SearchControlView : UIView<UITextFieldDelegate>
{
    __unsafe_unretained IBOutlet UIImageView *searchImageView;
    __unsafe_unretained IBOutlet UITextField *searchTextField;
    __unsafe_unretained IBOutlet UIButton *clearButton;
    dispatch_time_t delaySearchUntilQueryUnchangedForTimeOffset;
}

@property(nonatomic, assign) id<SearchControlViewDelegate> delegate;

- (void)setupView;

- (IBAction)clearButtonClicked:(id)sender;

@end
