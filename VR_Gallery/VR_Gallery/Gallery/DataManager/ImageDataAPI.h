//
//  ImageDataAPI.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDataAPI : NSObject

+ (ImageDataAPI *)sharedInstance;

// Integrated API
- (void)getMomentsWithBatchReturn:(BOOL)batch ascending:(BOOL)ascending completion:(void (^)(BOOL done, id obj))completion;

- (void)getThumbnailForAssetObj:(id)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion;

- (void)getURLForAssetObj:(id)asset completion:(void (^)(BOOL ret, NSURL *URL))completion;

- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion;

- (void)getPosterImageForAlbumObj:(id)album completion:(void (^)(BOOL ret, id obj))completion;

- (void)getPhotosWithGroup:(id)group completion:(void (^)(BOOL ret, id obj))completion;

- (void)getImageForPhotoObj:(id)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion;

- (BOOL)haveAccessToPhotos;

@end
