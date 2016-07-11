//
//  CRearrangeableCollectionViewCell.m
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import "CRearrangeableCollectionViewCell.h"

@implementation CRearrangeableCollectionViewCell



- (void)setDragging:(BOOL)dragging {
    
    if (dragging) {
        
        self.baseBackgroundColor = self.backgroundColor;
        
        self.backgroundColor = [UIColor redColor];
        
    } else {
        
        self.backgroundColor = self.baseBackgroundColor;
        
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
}
@end
