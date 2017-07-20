//
//  PHSourceManager.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import "PHSourceManager.h"
#import "MomentModel.h"
#import "AlbumModel.h"
#import "VRAlbumModel.h"

@implementation PHSourceManager

- (instancetype)init{
    self = [super init];
    
    if (self){
        self.manager = [[PHImageManager alloc] init];
    }
    return self;
}

- (BOOL)haveAccessToPhotos{
    return ( [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusRestricted && [PHPhotoLibrary authorizationStatus] != PHAuthorizationStatusDenied );
}

- (void)getMomentsWithAscending:(BOOL)ascending completion:(void (^)(BOOL ret, id obj))completion{
    PHFetchOptions *options  = [[PHFetchOptions alloc] init];
    options.sortDescriptors  = @[[NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:ascending]];
    
    PHFetchResult  *momentRes = [PHAssetCollection fetchMomentsWithOptions:options];
    NSMutableArray *momArray  = [[NSMutableArray alloc] init];
    
    for (PHAssetCollection *collection in momentRes){
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:collection.endDate];
        NSUInteger month = [components month];
        NSUInteger year  = [components year];
        NSUInteger day   = [components day];
        
        MomentModel *moment = [MomentModel new];
        moment.month = month; moment.year = year; moment.day = day;
        
        PHFetchOptions *option  = [[PHFetchOptions alloc] init];
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
        
        moment.assetObjs = [PHAsset fetchAssetsInAssetCollection:collection options:option];
        if ([moment.assetObjs count]) [momArray addObject:moment];
    }
    
    completion(YES, momArray);
}

- (void)getImageForPHAsset:(PHAsset *)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    NSInteger r = [UIScreen mainScreen].scale;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    [options setSynchronous:YES]; // called exactly once
    
    [self.manager requestImageForAsset:asset targetSize:CGSizeMake(size.width*r, size.height*r) contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info){
        completion(YES, result);
    }];
}

- (void)getURLForPHAsset:(PHAsset *)asset completion:(void (^)(BOOL ret, NSURL *URL))completion{
    if (![asset isKindOfClass:[PHAsset class]]){
        completion(NO, nil); return;
    }
    
    [asset requestContentEditingInputWithOptions:nil completionHandler:^(PHContentEditingInput *contentEditingInput, NSDictionary *info){
        NSURL *imageURL = contentEditingInput.fullSizeImageURL;
        
        completion(YES, imageURL);
    }];
}

- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion{
    NSMutableArray *tmpAry   = [[NSMutableArray alloc] init];
    PHFetchOptions *option   = [[PHFetchOptions alloc] init];
    option.predicate         = [NSPredicate predicateWithFormat:@"mediaType = %d", PHAssetMediaTypeImage];
    option.sortDescriptors   = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                               ascending:NO]];
    PHFetchResult  *cameraRo = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    PHAssetCollection *colt  = [cameraRo lastObject];
    PHFetchResult *fetchR    = [PHAsset fetchAssetsInAssetCollection:colt
                                                             options:option];
    
    
    AlbumModel *obj   = [[AlbumModel alloc] init];
    VRAlbumModel *VRObj = [[VRAlbumModel alloc] init];
    obj.count = fetchR.count;
    obj.collection  = fetchR;
    
    NSMutableArray *myArr = [[NSMutableArray alloc] init];
    __block NSInteger allCount = 0;
    for (int i = 0; i < obj.count; i++) {
        [self getImageForPHAsset:obj.collection[i] withSize:CGSizeZero completion:^(BOOL ret, UIImage *image) {
            if (image.size.width == 2 * image.size.height) {
                [myArr addObject:obj.collection[i]];
                VRObj.type = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
                VRObj.name = colt.localizedTitle;
                allCount += 1;
            }
        }];
    }
    if (allCount > 0) {
        VRObj.count = allCount;
        VRObj.collection = myArr;
        [tmpAry addObject:VRObj];
    }else{
        completion(YES, nil);
    }
    
    PHAssetCollectionSubtype tp = PHAssetCollectionSubtypeAlbumRegular | PHAssetCollectionSubtypeAlbumSyncedAlbum;
    PHFetchResult *albums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:tp options:nil];
    
    for (PHAssetCollection *col in albums){
        @autoreleasepool{
            PHFetchResult *fRes = [PHAsset fetchAssetsInAssetCollection:col options:option];
            
            AlbumModel *obj = [AlbumModel new];
            VRAlbumModel *VRObj2 = [[VRAlbumModel alloc] init];
            obj.collection = fRes;
            obj.count = fRes.count;
            
            NSMutableArray *myArr2 = [[NSMutableArray alloc] init];
            __block NSInteger allCount = 0;
            for (int i = 0; i < obj.count; i++) {
                [self getImageForPHAsset:obj.collection[i] withSize:CGSizeZero completion:^(BOOL ret, UIImage *image) {
                    if (image.size.width == 2 * image.size.height) {
                        [myArr2 addObject:obj.collection[i]];
                        VRObj2.type = PHAssetCollectionSubtypeSmartAlbumUserLibrary;
                        VRObj2.name = col.localizedTitle;
                        allCount += 1;
                    }
                }];
            }
            if (allCount > 0) {
                VRObj2.count = allCount;
                VRObj2.collection = myArr2;
                [tmpAry addObject:VRObj2];
            }
        }
    }
    
    completion(YES, tmpAry);
}

- (void)getPosterImageForAlbumObj:(AlbumModel *)album completion:(void (^)(BOOL ret, id obj))completion{
    PHAsset *asset = [album.collection firstObject];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    CGFloat scale = [UIScreen mainScreen].scale; CGFloat dimension = 60.f;
    CGSize  size  = CGSizeMake(dimension * scale, dimension * scale);
    
    [self.manager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info){
        completion((result != nil), result);
    }];
}

- (void)getPhotosWithGroup:(AlbumModel *)obj completion:(void (^)(BOOL ret, id obj))completion{
    if (![obj.collection isKindOfClass:[PHFetchResult class]]){
        completion(NO, nil); return;
    }
    
    completion(YES, (PHFetchResult *)obj.collection);
}

@end
