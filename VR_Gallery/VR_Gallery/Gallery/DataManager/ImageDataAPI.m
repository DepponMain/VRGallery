//
//  ImageDataAPI.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "ImageDataAPI.h"
#import "PHSourceManager.h"

@interface ImageDataAPI ()

@property (nonatomic, strong) PHSourceManager *phManager;

@end

@implementation ImageDataAPI

- (instancetype)init{
    self = [super init];
    if (self){
        self.phManager = [[PHSourceManager alloc] init];
    }
    return self;
}

+ (ImageDataAPI *)sharedInstance{
    static ImageDataAPI *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^ {
        _sharedInstance = [[ImageDataAPI alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Integrated API
- (void)getMomentsWithBatchReturn:(BOOL)batch ascending:(BOOL)ascending completion:(void (^)(BOOL done, id obj))completion{
    [self.phManager getMomentsWithAscending:ascending completion:^(BOOL ret, id obj){
        completion(ret, obj);
    }];
}

- (void)getThumbnailForAssetObj:(id)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion{
    [self.phManager getImageForPHAsset:asset withSize:size completion:^(BOOL ret, UIImage *image){
        completion(ret, image);
    }];
}

- (void)getURLForAssetObj:(id)asset completion:(void (^)(BOOL ret, NSURL *URL))completion{
    [self.phManager getURLForPHAsset:asset completion:^(BOOL ret, NSURL *URL){
        completion(ret, URL);
    }];
}

- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion{
    [self.phManager getAlbumsWithCompletion:^(BOOL ret, id obj){
        completion(ret, obj);
    }];
}

- (void)getPosterImageForAlbumObj:(id)album completion:(void (^)(BOOL ret, id obj))completion{
    [self.phManager getPosterImageForAlbumObj:album completion:^(BOOL ret, id obj){
        completion(ret, obj);
    }];
}

- (void)getPhotosWithGroup:(id)group completion:(void (^)(BOOL ret, id obj))completion{
    [self.phManager getPhotosWithGroup:group completion:^(BOOL ret, id obj){
        completion(ret, obj);
    }];
}

- (void)getImageForPhotoObj:(id)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion{
    [self.phManager getImageForPHAsset:asset withSize:size completion:^(BOOL ret, UIImage *image){
        completion(ret, image);
    }];
}

- (BOOL)haveAccessToPhotos{
    return [self.phManager haveAccessToPhotos];
}

@end
