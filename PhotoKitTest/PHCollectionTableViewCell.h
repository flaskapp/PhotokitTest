//
//  PHCollectionTableViewCell.h
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface PHCollectionTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *classNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *startDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *endDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *identifierLabel;

- (void)updateUI:(PHCollectionList *)collection;

@end
