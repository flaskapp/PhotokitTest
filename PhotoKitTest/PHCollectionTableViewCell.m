//
//  PHCollectionTableViewCell.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "PHCollectionTableViewCell.h"

@implementation PHCollectionTableViewCell

- (void)updateUI:(PHCollectionList *)collection {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    _startDateLabel.text = [formatter stringFromDate:collection.startDate];
    _endDateLabel.text = [formatter stringFromDate:collection.endDate];
    _classNameLabel.text = [NSString stringWithFormat:@"%@", collection.class];
    _nameLabel.text = collection.localizedTitle;
    _identifierLabel.text = collection.localIdentifier;
}

@end
