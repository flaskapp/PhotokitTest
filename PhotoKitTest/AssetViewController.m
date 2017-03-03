//
//  AssetViewController.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "AssetViewController.h"
#import "AssetTableViewCell.h"
#import "AssetDetailViewController.h"
@import Photos;

@interface AssetViewController()
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation AssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [[NSMutableArray alloc] init];
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:_assetCollection options:nil];
    [result enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
        [_lists addObject:obj];
    }];
}

#pragma mark - UITableViewDataSource implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetViewCell" forIndexPath:indexPath];
    PHAsset *asset = [_lists objectAtIndex:indexPath.row];
    
    cell.classNameLabel.text = [NSString stringWithFormat:@"%@", asset.class];
    cell.nameLabel.text = asset.localIdentifier;
    cell.widthLabel.text = [NSString stringWithFormat:@"%ld", (long)asset.pixelWidth];
    cell.heightLabel.text = [NSString stringWithFormat:@"%ld", (long)asset.pixelHeight];
    cell.mediaLabel.text = [self _mediaTypeStr:asset.mediaType];
    cell.mediaSubLabel.text = [self _mediaSubTypeStr:asset.mediaSubtypes];
    
    cell.hiddenLabel.text = asset.hidden ? @"YES" : @"NO";
    cell.favoriteLabel.text = asset.favorite ? @"YES" : @"NO";
    cell.burstLabel.text = asset.representsBurst ?  @"YES" : @"NO";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    cell.createDateLabel.text = [formatter stringFromDate:asset.creationDate];
    cell.modifyDateLabel.text = [formatter stringFromDate:asset.modificationDate];
    return cell;
}

- (NSString *)_mediaTypeStr:(PHAssetMediaType) type {
    switch (type) {
        case PHAssetMediaTypeImage:
            return @"Image";
        case PHAssetMediaTypeAudio:
            return @"Audio";
        case PHAssetMediaTypeVideo:
            return @"Video";
        case PHAssetMediaTypeUnknown:
            return @"Unknown";
    }
}

- (NSString *)_mediaSubTypeStr:(PHAssetMediaSubtype) type {
    switch (type) {
        case PHAssetMediaSubtypePhotoHDR:
            return @"PhotoHDR";
        case PHAssetMediaSubtypePhotoPanorama:
            return @"PhotoPanorama";
        case PHAssetMediaSubtypeVideoHighFrameRate:
            return @"VideoHighFrameRate";
        case PHAssetMediaSubtypeVideoStreamed:
            return @"VideoStreamed";
        case PHAssetMediaSubtypeVideoTimelapse:
            return @"VideoTimelapse";
        case PHAssetMediaSubtypeNone:
            return @"None";
        case PHAssetMediaSubtypePhotoScreenshot:
            return @"PhotoScreenshot";
        case PHAssetMediaSubtypePhotoLive:
            return @"PhotoLive";
        case PHAssetMediaSubtypePhotoDepthEffect:
            return @"PhotoDepthEffect";
    }
}

#pragma mark - UITableViewDelegate implements

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAsset *asset = [_lists objectAtIndex:indexPath.row];
    AssetDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetDetailViewController"];
    controller.asset = asset;
    [self.navigationController pushViewController:controller animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

