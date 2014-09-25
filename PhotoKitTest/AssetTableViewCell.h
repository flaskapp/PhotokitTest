//
//  AssetTableViewCell.h
//  PhotoKitTest
//
//  Created by ogawa on 2014/09/25.
//  Copyright (c) 2014年 Flask LLP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *classNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *mediaLabel;
@property (nonatomic, weak) IBOutlet UILabel *mediaSubLabel;
@property (nonatomic, weak) IBOutlet UILabel *createDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *modifyDateLabel;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *hiddenLabel;
@property (nonatomic, weak) IBOutlet UILabel *favoriteLabel;
@property (nonatomic, weak) IBOutlet UILabel *burstLabel;
@property (nonatomic, weak) IBOutlet UILabel *widthLabel;
@property (nonatomic, weak) IBOutlet UILabel *heightLabel;

@end
