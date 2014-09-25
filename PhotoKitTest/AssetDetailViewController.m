//
//  AssetDetailViewController.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "AssetDetailViewController.h"
@import CoreLocation;

@interface AssetDetailViewController()
@property (nonatomic, strong) NSDictionary *imageInfo;
@end

@implementation AssetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _updateProperties];
    [self changedImageSize:_imageSizeSegment];
}

- (void)_updateProperties {
    _editContentLabel.text = [_asset canPerformEditOperation:PHAssetEditOperationContent] ? @"YES" : @"NO";
    _editDeleteLabel.text = [_asset canPerformEditOperation:PHAssetEditOperationDelete] ? @"YES" : @"NO";
    _editPropertyLabel.text = [_asset canPerformEditOperation:PHAssetEditOperationProperties] ? @"YES" : @"NO";
    _favSwitch.on = _asset.favorite;
    _hiddenSwitch.on = _asset.hidden;
    _widthLabel.text = [NSString stringWithFormat:@"%ld", (long)_asset.pixelWidth];
    _heightLabel.text = [NSString stringWithFormat:@"%ld", (long)_asset.pixelHeight];
    _hiddenLabel.text = _asset.hidden ? @"YES" : @"NO";
    _favoriteLabel.text = _asset.favorite ? @"YES" : @"NO";
    _burstLabel.text = _asset.representsBurst ?  @"YES" : @"NO";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    _createDateLabel.text = [formatter stringFromDate:_asset.creationDate];
    _modifyDateLabel.text = [formatter stringFromDate:_asset.modificationDate];
    if (_asset.location == nil) {
        _locationLabel.text = @"No Location";
    } else {
        _locationLabel.text = [NSString stringWithFormat:@"%f, %f", (double)_asset.location.coordinate.latitude, (double)_asset.location.coordinate.longitude];
    }
}

#pragma mark - Action

- (void)changedImageSize:(UISegmentedControl *)sender {
    NSMutableString *log = [[NSMutableString alloc] init];
    _imageLoadLogLabel.text = @"";
    CGSize imageSize = CGSizeMake(160 * (sender.selectedSegmentIndex + 1), 160 * (sender.selectedSegmentIndex + 1));
    NSTimeInterval startTime = [NSDate date].timeIntervalSince1970;
    [[PHImageManager defaultManager] requestImageForAsset:_asset targetSize:imageSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage *result, NSDictionary *info) {
        _imageView.image = result;
        NSTimeInterval diff = [NSDate date].timeIntervalSince1970 - startTime;
        [log appendString:[NSString stringWithFormat:@"%fmsec ", diff]];
        [log appendString:NSStringFromCGSize(result.size)];
        [log appendString:@", SCALE:"];
        [log appendString:[NSString stringWithFormat:@"%.0f ", result.scale]];
        [log appendString:@"\n"];
        _imageLoadLogLabel.text = log;
        
        self.imageInfo = info;
        //NSLog(@"%@", info);
    }];
}

- (void)editAsset:(id)sender {
    
}

- (void)deleteAsset:(id)sender {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest deleteAssets:@[_asset]];
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"Deleted!");
        }
        NSLog(@"%@", error);
    }];

}

- (void)changedFavorite:(UISwitch *)sender {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:_asset];
        request.favorite = _favSwitch.on;
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            _favSwitch.on = !_favSwitch.on;
        }
        NSLog(@"%@", error);
    }];
}

- (void)changedHidden:(UISwitch *)sender {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest changeRequestForAsset:_asset];
        request.hidden = sender.on;
        
    } completionHandler:^(BOOL success, NSError *error) {
        if (!success) {
            sender.on = !sender.on;
        }
        NSLog(@"%@", error);
    }];
}

- (void)showMetadata:(UIButton *)sender {
    _showPhotoInfoButton.selected = NO;
    if (sender.selected) {
        _metaScrollView.hidden = YES;
        sender.selected = NO;
        return;
    }
    
    [[PHImageManager defaultManager] requestImageDataForAsset:_asset options:nil resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
        NSDictionary *metadata = [self metadataFromImageData:imageData];
        _metaScrollView.hidden = NO;
        _metaLabel.text = [NSString stringWithFormat:@"%@", metadata];
        _metaScrollView.contentOffset = CGPointZero;
        sender.selected = YES;
    }];
}

- (NSDictionary*)metadataFromImageData:(NSData*)imageData {
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(imageData), NULL);
    if (imageSource) {
        NSDictionary *options = @{(NSString *)kCGImageSourceShouldCache : [NSNumber numberWithBool:NO]};
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, (__bridge CFDictionaryRef)options);
        if (imageProperties) {
            NSDictionary *metadata = (__bridge NSDictionary *)imageProperties;
            CFRelease(imageProperties);
            CFRelease(imageSource);
            return metadata;
        }
        CFRelease(imageSource);
    }
    return nil;
}

- (void)showImageInfo:(UIButton *)sender {
    _showMetaButton.selected = NO;
    if (sender.selected) {
        _metaScrollView.hidden = YES;
        sender.selected = NO;
        return;
    }
    sender.selected = YES;
    _metaScrollView.hidden = NO;
    _metaLabel.text = [NSString stringWithFormat:@"%@", _imageInfo];
    _metaScrollView.contentOffset = CGPointZero;
}

@end
