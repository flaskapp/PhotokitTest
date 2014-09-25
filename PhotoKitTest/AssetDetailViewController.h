//
//  AssetDetailViewController.h
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@interface AssetDetailViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UILabel *editContentLabel;
@property (nonatomic, weak) IBOutlet UILabel *editDeleteLabel;
@property (nonatomic, weak) IBOutlet UILabel *editPropertyLabel;
@property (nonatomic, weak) IBOutlet UILabel *createDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *modifyDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *hiddenLabel;
@property (nonatomic, weak) IBOutlet UILabel *favoriteLabel;
@property (nonatomic, weak) IBOutlet UILabel *burstLabel;
@property (nonatomic, weak) IBOutlet UILabel *widthLabel;
@property (nonatomic, weak) IBOutlet UILabel *heightLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@property (nonatomic, weak) IBOutlet UISwitch *favSwitch;
@property (nonatomic, weak) IBOutlet UISwitch *hiddenSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *imageSizeSegment;
@property (nonatomic, weak) IBOutlet UITextView *imageLoadLogTextView;
@property (nonatomic, weak) IBOutlet UIScrollView *metaScrollView;
@property (nonatomic, weak) IBOutlet UILabel *metaLabel;

@property (nonatomic, strong) PHAsset *asset;

- (IBAction)editAsset:(id)sender;
- (IBAction)deleteAsset:(id)sender;
- (IBAction)changedFavorite:(UISwitch *)sender;
- (IBAction)changedHidden:(UISwitch *)sender;
- (IBAction)changedImageSize:(UISegmentedControl *)sender;
- (IBAction)showMetadata:(id)sender;

@end
