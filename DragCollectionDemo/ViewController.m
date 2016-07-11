//
//  ViewController.m
//  DragCollectionDemo
//
//  Created by ChenTianyu on 16/7/8.
//  Copyright © 2016年 ChenTianyu. All rights reserved.
//

#import "ViewController.h"
#import "CCollectionViewCell.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.collectionView registerClass:<#(nullable Class)#> forCellWithReuseIdentifier:<#(nonnull NSString *)#>
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"names" ofType:@"txt"];
    
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *allNamesArray = [content componentsSeparatedByString:@"\n"];
    
    NSInteger index = 0;
    NSInteger section = 0;

    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString *name in allNamesArray) {
        
        if (array.count <= section) {
            
            [array addObject:[NSMutableArray arrayWithCapacity:0]];

        }
        
        NSRange  range = [name rangeOfString:@" "];
    
        NSString *clean = [name substringToIndex:range.location];

        
        [array[section] addObject:clean];
        
        if (index == 20) {
            index = 0;
            section += 1;
        } else {
            index += 1;
        }
        
    }
    self.data = [NSMutableArray arrayWithArray:array];
    
    self.collectionViewRearrangeableLayout.draggable = YES;
    
    self.collectionViewRearrangeableLayout.axis = 0;

    self.collectionViewRearrangeableLayout.delegate = self;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.data.count;

}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.data[section] count];

}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    CCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:@"CollectionViewCell" withReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    CCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CCollectionViewCell" forIndexPath:indexPath];

    NSString * name = self.data[indexPath.section][indexPath.item];
    cell.titleLabel.text = name;
    return cell;

}

#pragma mark CRearrangeableCollectionViewDelegate

- (void)moveDataItem:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSString * name = self.data[fromIndexPath.section][fromIndexPath.item];
    
    [self.data[fromIndexPath.section] removeObjectAtIndex:fromIndexPath.item];
    
    [self.data[toIndexPath.section] insertObject:name atIndex:toIndexPath.item];

}

@end
