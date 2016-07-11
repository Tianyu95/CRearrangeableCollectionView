//
//  CRearrangeableCollectionViewFlowLayout.m
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import "CRearrangeableCollectionViewFlowLayout.h"
#import "CRearrangeableCollectionViewCell.h"


@implementation Bundle

@end

/*
struct Bundle {

    CGPoint offset;
    UICollectionViewCell *sourceCell;
    UIView *representationImageView;
    NSIndexPath *currentIndexPath;
    
};
typedef struct Bundle bundle;
*/

@implementation CRearrangeableCollectionViewFlowLayout

- (void)setBundle:(CGPoint)oft cell:(UICollectionViewCell *)cell view:(UIView *)view index:(NSIndexPath *)index {
    
    self.bundle.offset = oft;
    self.bundle.sourceCell = cell;
    self.bundle.representationImageView = view;
    self.bundle.currentIndexPath = index;
}

//- (void)setCanvas:(UIView *)canvas {
//    
//    if (canvas != nil) {
//        
//        [self calculateBorders];
//        
//    }
//}

- (id)init {

    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.axis = 0;
    animating = NO;
    self.draggable = YES;
    
    self.bundle.offset = CGPointZero;

    [self setup];
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.axis = 0;
    animating = NO;
    self.draggable = YES;
    
    if (self.bundle) {
        NSLog(@"ye ss");
    } else {
        self.bundle = [[Bundle alloc] init];
    }
    self.bundle.offset = CGPointZero;

    
    [self setup];
    
}

- (void)setup {
    
    UICollectionView *collectionView = self.collectionView;
    
    UILongPressGestureRecognizer *longPressGestureRecogniser = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];


    longPressGestureRecogniser.minimumPressDuration = 0.2;
    longPressGestureRecogniser.delegate = self;//会冲突
    
    [collectionView addGestureRecognizer:longPressGestureRecogniser];

    
    if (self.canvas == nil) {

        self.canvas = self.collectionView.superview;

    }
    
}

- (void)prepareLayout {
    [super prepareLayout];
    
    [self calculateBorders];
}

- (void)calculateBorders {
    UICollectionView *collectionView = self.collectionView;

    collectionViewFrameInCanvas = collectionView.frame;
    
    
    if (self.canvas != collectionView.superview) {
        
        collectionViewFrameInCanvas = [self.canvas convertRect:collectionViewFrameInCanvas fromView:collectionView];
    }
    
    
    [self hitTestRectagles:@""];
//    CGRect leftRect = collectionViewFrameInCanvas;
//    leftRect.size.width = 20.0;
//    hitTestRectagles["left"] = leftRect
//    
//    var topRect : CGRect = collectionViewFrameInCanvas
//    topRect.size.height = 20.0
//    hitTestRectagles["top"] = topRect
//    
//    var rightRect : CGRect = collectionViewFrameInCanvas
//    rightRect.origin.x = rightRect.size.width - 20.0
//    rightRect.size.width = 20.0
//    hitTestRectagles["right"] = rightRect
//    
//    var bottomRect : CGRect = collectionViewFrameInCanvas
//    bottomRect.origin.y = bottomRect.origin.y + rightRect.size.height - 20.0
//    bottomRect.size.height = 20.0
//    hitTestRectagles["bottom"] = bottomRect
}

- (CGRect)hitTestRectagles:(NSString *)str {
    
    leftRect = collectionViewFrameInCanvas;
    topRect = collectionViewFrameInCanvas;
    rightRect = collectionViewFrameInCanvas;
    bottomRect = collectionViewFrameInCanvas;

    leftRect.size.width = 20.0;
    
    topRect.size.height = 20.0;
    
    rightRect.origin.x = rightRect.size.width - 20.0;
    rightRect.size.width = 20.0;

    bottomRect.origin.y = bottomRect.origin.y + rightRect.size.height - 20.0;
    bottomRect.size.height = 20.0;


    
    CGRect tempRect;

    if ([str isEqualToString:@"left"]) {
        
        tempRect = leftRect;

    } else if ([str isEqualToString:@"top"]) {
        
        tempRect = topRect;
        
    } else if ([str isEqualToString:@"right"]) {
        
        tempRect = rightRect;
        
    } else if ([str isEqualToString:@"bottom"]) {
        
        tempRect = bottomRect;

    }
    
    return tempRect;
    
}

#pragma mark UIGestureRecognizerDelegate

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.draggable == NO) {
        return NO;
    }
    
    UIView *ca = self.canvas;
    
    UICollectionView *cv = self.collectionView;

    CGPoint pointPressedInCanvas = [gestureRecognizer locationInView:cv];
    

    for (UICollectionViewCell *cell in cv.visibleCells) {
        
        CGRect cellInCanvasFrame = [ca convertRect:cell.frame fromView:cv];

        NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));
NSLog(@"cellInCanvasFrame = %@",NSStringFromCGRect(cellInCanvasFrame));
        
        if (CGRectContainsPoint(cell.frame, pointPressedInCanvas)) {//cellInCanvasFrame, pointPressedInCanvas
            
//            NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));
//            NSLog(@"cellInCanvasFrame = %@",NSStringFromCGRect(cellInCanvasFrame));
//            NSLog(@"pointPressedInCanvas = %@",NSStringFromCGPoint(pointPressedInCanvas));

            CRearrangeableCollectionViewCell *kdcell = (CRearrangeableCollectionViewCell *)cell;
            kdcell.dragging = YES;                // Override he dragging setter to apply and change in style that you want
        
            //生成透明or No 的图形
            UIGraphicsBeginImageContextWithOptions(cell.bounds.size, cell.opaque, 0);
            [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            UIImageView *representationImage = [[UIImageView alloc] initWithImage:img];
            representationImage.frame = cell.frame;//cellInCanvasFrame;

            CGPoint oft = CGPointMake(pointPressedInCanvas.x - cell.frame.origin.x, pointPressedInCanvas.y - cell.frame.origin.y);//cellInCanvasFrame
            
            
            NSIndexPath *indexPath = [cv indexPathForCell:(UICollectionViewCell *)cell];
            
            [self setBundle:oft cell:cell view:representationImage index:indexPath];
            
            break;
            
        }
    }
    
    
    if (self.bundle.representationImageView) {
        return YES;
    } else {
        return NO;
    }
    
    return self.bundle != nil;
}

- (BOOL)checkForDraggingAtTheEdgeAndAnimatePaging:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (animating) {
        return YES;
    }
    
    Bundle *tempBundle = self.bundle;
    
    CGRect nextPageRect = self.collectionView.bounds;
    
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        
        if (CGRectIntersectsRect(tempBundle.representationImageView.frame, [self hitTestRectagles:@"left"])) {
            
            nextPageRect.origin.x -= nextPageRect.size.width;
            
            if (nextPageRect.origin.x < 0.0) {
                
                nextPageRect.origin.x = 0.0;
                
            }
        } else if (CGRectIntersectsRect(tempBundle.representationImageView.frame, [self hitTestRectagles:@"right"])) {
            
            nextPageRect.origin.x += nextPageRect.size.width;
            
            if (nextPageRect.origin.x + nextPageRect.size.width > self.collectionView.contentSize.width) {
                
                nextPageRect.origin.x = self.collectionView.contentSize.width - nextPageRect.size.width;
                
            }
        }
        
    } else if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
        
        if (CGRectIntersectsRect(tempBundle.representationImageView.frame, [self hitTestRectagles:@"top"])) {
            
            nextPageRect.origin.y -= nextPageRect.size.height;
            
            if (nextPageRect.origin.y < 0.0) {
                
                nextPageRect.origin.y = 0.0;
                
            }
        } else if (CGRectIntersectsRect(tempBundle.representationImageView.frame, [self hitTestRectagles:@"bottom"])) {
            
            nextPageRect.origin.y += nextPageRect.size.height;
            
            if (nextPageRect.origin.y + nextPageRect.size.height > self.collectionView.contentSize.height) {
                
                nextPageRect.origin.y = self.collectionView.contentSize.height - nextPageRect.size.height;
                
            }
        }
        
        
    }

    
    if (!CGRectEqualToRect(nextPageRect, self.collectionView.bounds)) {
        
//        NSInteger delayTime = dispatch_time(DISPATCH_TIME_NOW, (0.8 * (NSEC_PER_SEC)));
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            animating = NO;
            
            [self handleGesture:gestureRecognizer];

        });
        
        animating = YES;
        
        [self.collectionView scrollRectToVisible:nextPageRect animated:YES];

    }
    

    
    
    return YES;
}



#pragma mark gesture
- (void)handleGesture:(UILongPressGestureRecognizer *)gesture {
    
    
//    guard let bundle = self.bundle else {
//        return
//    }
    
    Bundle *tempBundle = self.bundle;
    
    if (!tempBundle) {
        return;
    }
    
    CGPoint dragPointOnCanvas = [gesture locationInView:self.canvas];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            
            tempBundle.sourceCell.hidden = YES;
            [self.canvas addSubview:tempBundle.representationImageView];

            CGRect imageViewFrame = tempBundle.representationImageView.frame;
            CGPoint point = CGPointZero;
            point.x = dragPointOnCanvas.x - tempBundle.offset.x;
            point.y = dragPointOnCanvas.y - tempBundle.offset.y;
            
            imageViewFrame.origin = point;
            tempBundle.representationImageView.frame = imageViewFrame;
            
            break;
            
            
        case UIGestureRecognizerStateChanged:
        {
            // Update the representation image
            CGRect imageViewFrame = tempBundle.representationImageView.frame;
            
            CGPoint point = CGPointMake(dragPointOnCanvas.x - tempBundle.offset.x, dragPointOnCanvas.y - tempBundle.offset.y);
            if (self.axis == X) {
                point.y = imageViewFrame.origin.y;
            }
            if (self.axis == Y){
                point.x = imageViewFrame.origin.x;
            }
            
            
            imageViewFrame.origin = point;
            tempBundle.representationImageView.frame = imageViewFrame;
            
            
            CGPoint dragPointOnCollectionView = [gesture locationInView:self.collectionView];
            
            if (self.axis == X) {
                dragPointOnCollectionView.y = tempBundle.representationImageView.center.y;
            }
            if (self.axis == Y) {
                dragPointOnCollectionView.x = tempBundle.representationImageView.center.x;
            }
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:dragPointOnCollectionView];

            [self checkForDraggingAtTheEdgeAndAnimatePaging:gesture];
            
            if (![indexPath isEqual:tempBundle.currentIndexPath] ) {
                
                // If we have a collection view controller that implements the delegate we call the method first
                
                [self.delegate moveDataItem:tempBundle.currentIndexPath toIndexPath:indexPath];
                
                [self.collectionView moveItemAtIndexPath:tempBundle.currentIndexPath toIndexPath:indexPath];
                
                self.bundle.currentIndexPath = indexPath;

            }
            
        }
            break;

        case UIGestureRecognizerStateEnded:
            
            [self endDraggingAction:tempBundle];
            
            break;

        case UIGestureRecognizerStateCancelled:
            
            [self endDraggingAction:tempBundle];

            break;

        case UIGestureRecognizerStateFailed:
            
            [self endDraggingAction:tempBundle];

            break;

        case UIGestureRecognizerStatePossible:
            break;

        default:
            break;
    }
}

- (void)endDraggingAction:(Bundle *)bbb {
    
    bbb.sourceCell.hidden = NO;
    
    CRearrangeableCollectionViewCell *kdcell = (CRearrangeableCollectionViewCell *)bbb.sourceCell;
    kdcell.dragging = NO;
    
    [bbb.representationImageView removeFromSuperview];

    // if we have a proper data source then we can reload and have the data displayed correctly
//    if let cv = self.collectionView where cv.delegate is KDRearrangeableCollectionViewDelegate {
//        cv.reloadData()
//    }
    [self.collectionView reloadData];
    
    self.bundle = nil;
    
    self.bundle = [[Bundle alloc] init];

}









@end
