//
//  AssetCollectionViewController.m
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import "AssetCollectionViewController.h"
#import "AssetCollectionTableViewCell.h"
#import "AssetViewController.h"
@import Photos;

@interface AssetCollectionViewController()
@property (nonatomic, strong) NSMutableArray *lists;
@end

@implementation AssetCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lists = [[NSMutableArray alloc] init];
    PHFetchResult *result = [PHAssetCollection fetchCollectionsInCollectionList:_collectionList  options:nil];
    [result enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL *stop) {
        [_lists addObject:obj];
    }];
}

#pragma mark - UITableViewDataSource implements

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AssetCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    PHAssetCollection *asset = [_lists objectAtIndex:indexPath.row];
    [cell updateUI:asset];
    return cell;
}

#pragma mark - UITableViewDelegate implements

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PHAssetCollection *asset = [_lists objectAtIndex:indexPath.row];
    AssetViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AssetViewController"];
    controller.assetCollection = asset;
    [self.navigationController pushViewController:controller animated:true];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end
