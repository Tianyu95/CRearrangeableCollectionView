//
//  CRearrangeableCollectionViewFlowLayout.h
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CRearrangeableCollectionViewDelegate <NSObject>

- (void)moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

@end

typedef NS_ENUM(NSInteger, CDraggingAxis) {
    Free,
    X,
    Y,
    XY
};


@interface Bundle : NSObject

@property (nonatomic) CGPoint offset;
@property (nonatomic, strong) UICollectionViewCell *sourceCell;
@property (nonatomic, strong) UIView *representationImageView;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@end

@interface CRearrangeableCollectionViewFlowLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate, CRearrangeableCollectionViewDelegate> {
    
    
    BOOL animating;
    
    CGRect collectionViewFrameInCanvas;
        
    
    CGRect leftRect;
    CGRect topRect;
    CGRect rightRect;
    CGRect bottomRect;

    
}
@property (nonatomic, strong) Bundle *bundle;

@property (nonatomic, strong) UIView *canvas;

@property (nonatomic, assign) id <CRearrangeableCollectionViewDelegate> delegate;

@property (nonatomic)     BOOL draggable;
@property (nonatomic)     CDraggingAxis axis;

@end
