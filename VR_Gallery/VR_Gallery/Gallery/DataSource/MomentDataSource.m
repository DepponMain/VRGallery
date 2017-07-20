//
//  MomentDataSource.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import "MomentDataSource.h"
#import "MomentModel.h"

@implementation MomentDataSource

- (id)initWithCellIdentifier:(NSString *)cellID headerIdentifier:(NSString *)headerID configureCellBlock:(CellConfigureBlock)block{
    self.headerIdentifier = headerID;
    return [self initWithCellIdentifier:cellID configureCellBlock:block];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.items count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    MomentModel *group = [self.items objectAtIndex:section];
    
    return [group.assetObjs count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    MomentModel *group = [self.items objectAtIndex:indexPath.section];
    
    id item = group.assetObjs[indexPath.row];
    
    self.block(cell, item, indexPath); return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:self.headerIdentifier forIndexPath:indexPath];
        while ([headerView.subviews lastObject] != nil){
            [(UIView*)[headerView.subviews lastObject] removeFromSuperview];
        }
        
        headerView.userInteractionEnabled = YES;
        headerView.tag = indexPath.section;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
        [headerView addGestureRecognizer:tapGes];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 105.0 * Pt)];
        [view setBackgroundColor:[UIColor colorWithHex:0xeeeeee]];
        
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:45.0 * Pt]];
        
        if (self.isEdit) {
            NSString *SecStr = [NSString stringWithFormat:@"%ld",(long)indexPath.section];
            NSString *Sec = [self.selectSections objectForKey:SecStr];
            if ([Sec isEqualToString:@"isSelected"]) {
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gallery_image_select"]];
                image.frame = CGRectMake(0, (105.0 * Pt - 17) / 2, 17, 17);
                [view addSubview:image];
            }else{
                UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_not_select"]];
                image.frame = CGRectMake(0, (105.0 * Pt - 17) / 2, 17, 17);
                [view addSubview:image];
            }
            label.frame = CGRectMake(90.0 * Pt, 0, ScreenWidth - 130.0 * Pt, 105.0 * Pt);
        }else{
            label.frame = CGRectMake(15.0 * Pt, 0, ScreenWidth - 70.0 * Pt, 105.0 * Pt);
        }
        
        MomentModel *group = (MomentModel *)[self.items objectAtIndex:indexPath.section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%lu-%lu-%lu",
                                                      (unsigned long)group.year,
                                                      (unsigned long)group.month,
                                                      (unsigned long)group.day]];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit  fromDate:[NSDate date]];
        NSUInteger month = [components month];
        NSUInteger year  = [components year];
        NSUInteger day   = [components day];
        
        NSLocale *currentLocal = [NSLocale currentLocale];
        
        dateFormatter.locale    = currentLocal;
        dateFormatter.dateStyle = kCFDateFormatterLongStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        
        if (year == group.year){
            NSString *longFormatWithoutYear = [NSDateFormatter dateFormatFromTemplate:@"MMMM d" options:0 locale:currentLocal];
            [dateFormatter setDateFormat:longFormatWithoutYear];
        }
        
        NSString *resultString = [dateFormatter stringFromDate:date];
        
        if (year == group.year && month == group.month){
            if (day == group.day){
                resultString = NSLocalizedString(@"今天", nil);
            }
            else if (day - 1 == group.day){
                resultString = NSLocalizedString(@"昨天", nil);
            }
        }
        
        if (!group.year && !group.day && !group.month) {
            resultString = NSLocalizedString(@"今天", nil);
        }
        
        [label setText:resultString]; [view addSubview:label];
        [headerView addSubview:view]; reusableview = headerView;
    }
    
    return reusableview;
}

- (void)tapGes:(UITapGestureRecognizer *)sender{
    if (self.isEdit) {
        
        NSString *Sec = [NSString stringWithFormat:@"%ld",(long)sender.view.tag];
        
        if ([[self.selectSections valueForKey:Sec] isEqualToString:@"isSelected"]) {
            
            NSString *tag = [NSString stringWithFormat:@"%ld",(long)sender.view.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionDidDeselected" object:tag];
            
        }else{
            
            NSString *tag = [NSString stringWithFormat:@"%ld",(long)sender.view.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sectionDidSelected" object:tag];
            
        }
    }else{
        return;
    }
}

@end
