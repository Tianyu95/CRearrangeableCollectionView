//
//  ViewController.h
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRearrangeableCollectionViewFlowLayout.h"
//#import "CCollectionViewCell.h"


@interface ViewController : UIViewController <CRearrangeableCollectionViewDelegate>

@property (nonatomic, strong)NSMutableArray *data;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet CRearrangeableCollectionViewFlowLayout *collectionViewRearrangeableLayout;
@end

