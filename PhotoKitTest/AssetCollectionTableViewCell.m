//
//  AssetCollectionTableViewCell.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "AssetCollectionTableViewCell.h"
@import CoreLocation;

@implementation AssetCollectionTableViewCell

- (void)updateUI:(PHAssetCollection *)assetCollection {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    _startDateLabel.text = [formatter stringFromDate:assetCollection.startDate];
    _endDateLabel.text = [formatter stringFromDate:assetCollection.endDate];
    _classNameLabel.text = [NSString stringWithFormat:@"%@", assetCollection.class];
    _nameLabel.text = assetCollection.localizedTitle;
    _countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)assetCollection.estimatedAssetCount];
    if (assetCollection.approximateLocation == nil) {
        _locationLabel.text = @"No Location";
    } else {
        _locationLabel.text = [NSString stringWithFormat:@"lat:%f, lon:%f", (double)assetCollection.approximateLocation.coordinate.latitude, (double)assetCollection.approximateLocation.coordinate.longitude];
    }
}

@end
