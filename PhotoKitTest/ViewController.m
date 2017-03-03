//
//  ViewController.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "ViewController.h"
#import "PHCollectionTableViewCell.h"
#import "AssetCollectionTableViewCell.h"
#import "AssetCollectionViewController.h"
#import "AssetViewController.h"
@import Photos;

@interface ViewController ()
@property (nonatomic, assign) BOOL isSelectedCollectionList;
@property (nonatomic, assign) NSInteger listType;
@property (nonatomic, assign) NSInteger subType;
@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSDictionary *collectionListSubTypeName;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [[NSMutableArray alloc] init];
    
    self.isSelectedCollectionList = YES;
    self.listType = PHCollectionListTypeMomentList;
    self.subType = PHCollectionListSubtypeAny;
    [self _changedSubType];
}

#pragma mark - Actions

- (IBAction)changedCollectionListType:(UISegmentedControl *)sender {
    self.isSelectedCollectionList = YES;
    if (sender.selectedSegmentIndex == 0) {
        self.listType = PHCollectionListTypeMomentList;
    } else if (sender.selectedSegmentIndex == 1) {
        self.listType = PHCollectionListTypeFolder;
    } else if (sender.selectedSegmentIndex == 2) {
        self.listType = PHCollectionListTypeSmartFolder;
    }
    self.subType = PHCollectionListSubtypeAny;
    self.assetCollectionSegment.selectedSegmentIndex = -1;
    [self _changedSubType];
}

- (IBAction)changedAssetCollectionType:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        _listType = PHAssetCollectionTypeAlbum;
    } else if (sender.selectedSegmentIndex == 1) {
        _listType = PHAssetCollectionTypeSmartAlbum;
    } else if (sender.selectedSegmentIndex == 2) {
        _listType = PHAssetCollectionTypeMoment;
    }
    self.isSelectedCollectionList = NO;
    self.subType = PHAssetCollectionSubtypeAny;
    self.collectionListSegment.selectedSegmentIndex = -1;
    [self _changedSubType];
}

- (IBAction)showSubtypeOption:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Sub Type" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSMutableArray *types = [[NSMutableArray alloc] init];
    if (_isSelectedCollectionList) {
        [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeAny]];
        if (_listType == PHCollectionListTypeMomentList) {
            [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeMomentListCluster]];
            [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeMomentListYear]];
        } else if (_listType == PHCollectionListTypeFolder) {
            [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeRegularFolder]];
        } else if (_listType == PHCollectionListTypeSmartFolder) {
            [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeSmartFolderEvents]];
            [types addObject:[NSNumber numberWithInteger:PHCollectionListSubtypeSmartFolderFaces]];
        }
    } else {
        [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAny]];
        if (_listType == PHAssetCollectionTypeAlbum) {
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumRegular]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumSyncedEvent]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumSyncedFaces]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumSyncedAlbum]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumImported]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeAlbumCloudShared]];
        } else if (_listType == PHAssetCollectionTypeMoment) {
            
        } else if (_listType == PHAssetCollectionTypeSmartAlbum) {
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumGeneric]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumPanoramas]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumVideos]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumFavorites]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumTimelapses]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumAllHidden]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumRecentlyAdded]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumBursts]];
            [types addObject:[NSNumber numberWithInteger:PHAssetCollectionSubtypeSmartAlbumSlomoVideos]];
        }
    }
    
    for (NSNumber *num in types) {
        NSInteger subtype = num.integerValue;
        NSString *name = _isSelectedCollectionList ? [self _stringOFCollectionListSubtypes:subtype] : [self _stringOFAssetCollectionSubtypes:subtype];
        [alertController addAction:[UIAlertAction actionWithTitle:name style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            self.subType = subtype;
            [self _changedSubType];
        }]];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //Nothing todo
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSString *)_stringOFCollectionListSubtypes:(PHCollectionListSubtype) subType {
    switch (subType) {
        case PHCollectionListSubtypeAny:
            return @"Any";
        case PHCollectionListSubtypeMomentListCluster:
            return @"ListCluster";
        case PHCollectionListSubtypeMomentListYear:
            return @"ListYear";
        case PHCollectionListSubtypeRegularFolder:
            return @"RegularFolder";
        case PHCollectionListSubtypeSmartFolderEvents:
            return @"Events";
        case PHCollectionListSubtypeSmartFolderFaces:
            return @"Faces";
    }
}

- (NSString *)_stringOFAssetCollectionSubtypes:(PHAssetCollectionSubtype) subType {
    switch (subType) {
        case PHAssetCollectionSubtypeAny:
            return @"Any";
        case PHAssetCollectionSubtypeAlbumCloudShared:
            return @"AlbumCloudShared";
        case PHAssetCollectionSubtypeAlbumImported:
            return @"AlbumImported";
        case PHAssetCollectionSubtypeAlbumRegular:
            return @"AlbumRegular";
        case PHAssetCollectionSubtypeAlbumSyncedAlbum:
            return @"AlbumSyncedAlbum";
        case PHAssetCollectionSubtypeAlbumSyncedEvent:
            return @"SyncedEvent";
        case PHAssetCollectionSubtypeAlbumSyncedFaces:
            return @"SyncedFaces";
        case PHAssetCollectionSubtypeSmartAlbumAllHidden:
            return @"AllHidden";
        case PHAssetCollectionSubtypeSmartAlbumBursts:
            return @"Bursts";
        case PHAssetCollectionSubtypeSmartAlbumFavorites:
            return @"Favorites";
        case PHAssetCollectionSubtypeSmartAlbumGeneric:
            return @"AlbumGeneric";
        case PHAssetCollectionSubtypeSmartAlbumPanoramas:
            return @"Panoramas";
        case PHAssetCollectionSubtypeSmartAlbumRecentlyAdded:
            return @"RecentlyAdded";
        case PHAssetCollectionSubtypeSmartAlbumSlomoVideos:
            return @"SlomoVideos";
        case PHAssetCollectionSubtypeSmartAlbumTimelapses:
            return @"Timelapses";
        case PHAssetCollectionSubtypeSmartAlbumVideos:
            return @"Videos";
        case PHAssetCollectionSubtypeAlbumMyPhotoStream:
            return @"MyPhotoStream";
        case PHAssetCollectionSubtypeSmartAlbumUserLibrary:
            return @"AlbumUserLibrary";
        case PHAssetCollectionSubtypeSmartAlbumScreenshots:
            return @"Screenshots";
        case PHAssetCollectionSubtypeSmartAlbumSelfPortraits:
            return @"SelfPortraits";
        case PHAssetCollectionSubtypeSmartAlbumDepthEffect:
            return @"DepthEffect";
    }
}

- (void)_changedSubType {
    if (_isSelectedCollectionList) {
        [_subtitleButton setTitle:[self _stringOFCollectionListSubtypes:_subType] forState:UIControlStateNormal];
    } else {
        [_subtitleButton setTitle:[self _stringOFAssetCollectionSubtypes:_subType] forState:UIControlStateNormal];
    }
    [self _loadPhotoList];
}

- (void)_loadPhotoList {
    if (_isSelectedCollectionList) {
        self.fetchResult = [PHCollectionList fetchCollectionListsWithType:_listType subtype:_subType options:nil];
    } else {
        self.fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:_listType subtype:_subType options:nil];
    }
    [self.lists removeAllObjects];
    [_tableView reloadData];

    [_fetchResult enumerateObjectsUsingBlock:^(PHCollectionList *list, NSUInteger idx, BOOL *stop) {
        if (list == nil) {
            [_tableView reloadData];
        } else {
            [self.lists addObject:list];
            [_tableView reloadData];
        }
    }];
}



#pragma mark - UITableViewDataSource implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *item = [_lists objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[PHCollectionList class]]) {
        PHCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
        PHCollectionList *list = [_lists objectAtIndex:indexPath.row];
        [cell updateUI:list];
        return cell;
    } else if ([item isKindOfClass:[PHAssetCollection class]]) {
        AssetCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetCollectionViewCell" forIndexPath:indexPath];
        PHAssetCollection *assetCollection = [_lists objectAtIndex:indexPath.row];
        [cell updateUI:assetCollection];
        return cell;
    } else {
        return nil;
    }
}

#pragma mark - UITableViewDelegate implements

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isSelectedCollectionList) {
        PHCollectionList *list = [_lists objectAtIndex:indexPath.row];
        AssetCollectionViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetCollectionViewController"];
        controller.collectionList = list;
        [self.navigationController pushViewController:controller animated:YES];
        
    } else {
        PHAssetCollection *assetCollection = [_lists objectAtIndex:indexPath.row];
        AssetViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetViewController"];
        controller.assetCollection = assetCollection;
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
