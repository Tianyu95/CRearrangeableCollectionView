//
//  CRearrangeableCollectionViewCell.h
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRearrangeableCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (assign, nonatomic) BOOL dragging;
@property (nonatomic, strong) UIColor *baseBackgroundColor;

@end
