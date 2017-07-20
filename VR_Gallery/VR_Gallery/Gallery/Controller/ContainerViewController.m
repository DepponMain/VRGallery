//
//  ContainerViewController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "ContainerViewController.h"
#import "MomentViewController.h"
#import "AlbumViewController.h"

@interface ContainerViewController ()

@property (nonatomic, assign) BOOL transitionInProgress;
@property (nonatomic, copy) NSString *currentSegueIdentifier;
@property (nonatomic, strong) MomentViewController *momentController;
@property (nonatomic, strong) AlbumViewController *albumViewController;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transitionInProgress   = NO;
    self.currentSegueIdentifier = SegueIdentifierMoment;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

//- (void)selectBtnClick{
//    [self.momentController selectBtnClick];
//    __weak ContainerViewController *weakSelf = self;
//    self.momentController.block = ^(NSInteger count){
//        weakSelf.block(count);
//    };
//}
//- (void)cancleBtnClick{
//    [self.momentController cancleBtnClick];
//}
//- (void)selectAllBtnClick{
//    [self.momentController selectAllBtnClick];
//}
//- (void)deselectAllBtnClick{
//    [self.momentController deselectAllBtnClick];
//}
//- (void)deleteBtnClick{
//    [self.momentController deleteBtnClick];
//}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if ([segue.identifier isEqualToString:SegueIdentifierMoment]){
        self.momentController = segue.destinationViewController;
    }
    
    if ([segue.identifier isEqualToString:SegueIdentifierAlbum]){
        self.albumViewController = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierMoment]){
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0){
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0]
                        toViewController:self.momentController];
        }else{
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView *destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierAlbum]){
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0]
                    toViewController:self.albumViewController];
    }
}

- (void)swapFromViewController:(UIViewController *)fromViewController
              toViewController:(UIViewController *)toViewController{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController
                      toViewController:toViewController
                              duration:0.3
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:nil
                            completion:^(BOOL finished){
         [fromViewController removeFromParentViewController];
         [toViewController didMoveToParentViewController:self];
         self.transitionInProgress = NO;
     }];
}

- (BOOL)swapToViewControllerWithSigueID:(NSString *)ID{
    if (self.transitionInProgress || self.currentSegueIdentifier == ID) return NO;
    
    self.transitionInProgress = YES; self.currentSegueIdentifier = ID;
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierMoment]) && self.momentController){
        [self swapFromViewController:self.albumViewController
                    toViewController:self.momentController];
        return YES;
    }
    
    if (([self.currentSegueIdentifier isEqualToString:SegueIdentifierAlbum]) && self.albumViewController){
        [self swapFromViewController:self.momentController
                    toViewController:self.albumViewController];
        return YES;
    }
    
    [self performSegueWithIdentifier:self.currentSegueIdentifier
                              sender:nil];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
