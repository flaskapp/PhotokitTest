//
//  ViewController.h
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *subtitleButton;
@property (nonatomic, weak) IBOutlet UISegmentedControl *collectionListSegment;
@property (nonatomic, weak) IBOutlet UISegmentedControl *assetCollectionSegment;

- (IBAction)changedCollectionListType:(UISegmentedControl *)sender;
- (IBAction)changedAssetCollectionType:(UISegmentedControl *)sender;
@end

