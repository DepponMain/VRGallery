//
//  PHSourceManager.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface PHSourceManager : NSObject

@property (nonatomic, strong) PHImageManager *manager;

- (BOOL)haveAccessToPhotos;

- (void)getMomentsWithAscending:(BOOL)ascending completion:(void (^)(BOOL ret, id obj))completion;

- (void)getImageForPHAsset:(PHAsset *)asset withSize:(CGSize)size completion:(void (^)(BOOL ret, UIImage *image))completion;

- (void)getURLForPHAsset:(PHAsset *)asset completion:(void (^)(BOOL ret, NSURL *URL))completion;

- (void)getAlbumsWithCompletion:(void (^)(BOOL ret, id obj))completion;

- (void)getPosterImageForAlbumObj:(id)album completion:(void (^)(BOOL ret, id obj))completion;

- (void)getPhotosWithGroup:(id)group completion:(void (^)(BOOL ret, id obj))completion;

@end
