//
//  CCollectionViewCell.m
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import "CCollectionViewCell.h"

@implementation CCollectionViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.layer.cornerRadius = self.frame.size.width * 0.5;
    
    self.clipsToBounds = YES;
    
}

@end
