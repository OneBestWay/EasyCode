//
// MHFacebookImageViewer.m
// Version 2.0
//
// Copyright (c) 2013 Michael Henry Pantaleon (http://www.iamkel.net). All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "MHFacebookImageViewer.h"
#import "UIImageView+AFNetworking.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
static const CGFloat kMinBlackMaskAlpha = 0.3f;
static const CGFloat kMaxImageScale = 2.5f;
static const CGFloat kMinImageScale = 1.0f;

@interface MHFacebookImageViewerCell : UITableViewCell<UIGestureRecognizerDelegate,UIScrollViewDelegate>{
    UIImageView * __imageView;
    UIScrollView * __scrollView;
    NSMutableArray *_gestures;
    CGPoint _panOrigin;
    BOOL _isAnimating;
    BOOL _isDoneAnimating;
    BOOL _isLoaded;
    CGRect imgFrame;
   // BOOL isPan;
}

@property(nonatomic,assign) CGRect originalFrameRelativeToScreen;
@property(nonatomic,weak) UIViewController * rootViewController;
@property(nonatomic,weak) UIViewController * viewController;
@property(nonatomic,weak) UIView * blackMask;
@property(nonatomic,weak) UIButton * doneButton;
@property(nonatomic,weak) UIButton * crossButton;
@property(nonatomic, weak) UILabel *captionLbl, *countLbl;
@property(nonatomic,weak) UIImageView * senderView;
@property(nonatomic,assign) NSInteger imageIndex;
@property(nonatomic,weak) UIImage * defaultImage;
@property(nonatomic,assign) NSInteger initialIndex;
@property(nonatomic,strong) UIPanGestureRecognizer* panGesture;
//@property(nonatomic, strong)int isPan;

@property (nonatomic,weak) MHFacebookImageViewerOpeningBlock openingBlock;
@property (nonatomic,weak) MHFacebookImageViewerClosingBlock closingBlock;

@property(nonatomic,weak) UIView * superView;

@property(nonatomic) UIStatusBarStyle statusBarStyle;

- (void) loadAllRequiredViews;
- (void) setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex;

@end

@implementation MHFacebookImageViewerCell

@synthesize originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
@synthesize rootViewController = _rootViewController;
@synthesize viewController = _viewController;
@synthesize blackMask = _blackMask;
@synthesize closingBlock = _closingBlock;
@synthesize openingBlock = _openingBlock;
@synthesize doneButton = _doneButton;
@synthesize crossButton = _crossButton;
//@synthesize captionLbl = _captionLbl;
@synthesize senderView = _senderView;
@synthesize imageIndex = _imageIndex;
@synthesize superView = _superView;
@synthesize defaultImage = _defaultImage;
@synthesize initialIndex = _initialIndex;
@synthesize panGesture = _panGesture;
//@synthesize isPan = _isPan;

- (void) loadAllRequiredViews{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    CGRect frame = [UIScreen mainScreen].bounds;
    __scrollView = [[UIScrollView alloc]initWithFrame:frame];
    __scrollView.delegate = self;
    [self addSubview:__scrollView];
    
    [_doneButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
    [_crossButton addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
}



- (void) setImageURL:(NSURL *)imageURL defaultImage:(UIImage*)defaultImage imageIndex:(NSInteger)imageIndex {
    _imageIndex = imageIndex;
    _defaultImage = defaultImage;

    //_senderView.alpha = 0.0f;
    
    NSLog(@":%d", APP_DELEGATE.isPan);
    if(!__imageView && !APP_DELEGATE.isPan){
        __imageView = [[UIImageView alloc]init];
        [__scrollView addSubview:__imageView];
        __imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    __block UIImageView * _imageViewInTheBlock = __imageView;
    __block MHFacebookImageViewerCell * _justMeInsideTheBlock = self;
    __block UIScrollView * _scrollViewInsideBlock = __scrollView;

    if (APP_DELEGATE.isPan) {
        __imageView.frame = CGRectZero;
        [__imageView setImage:nil];
        __imageView = nil;
        return;
    }
    
        [__imageView setImageWithURLRequest:[NSURLRequest requestWithURL:imageURL] placeholderImage:[UIImage imageNamed:@"default_propertyImage"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            [_scrollViewInsideBlock setZoomScale:1.0f animated:YES];
            [_imageViewInTheBlock setImage:image];
            _imageViewInTheBlock.frame = [_justMeInsideTheBlock centerFrameFromImage:_imageViewInTheBlock.image];

        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Image From URL Not loaded");
        }];

        if(_imageIndex==_initialIndex && !_isLoaded){
            __imageView.frame = _originalFrameRelativeToScreen;
            [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
                __imageView.frame = [self centerFrameFromImage:__imageView.image];
                CGAffineTransform transf = CGAffineTransformIdentity;
                // Root View Controller - move backward
                _rootViewController.view.transform = CGAffineTransformScale(transf, 0.95f, 0.95f);
                // Root View Controller - move forward
                //                _viewController.view.transform = CGAffineTransformScale(transf, 1.05f, 1.05f);
                _blackMask.alpha = 1;
            }   completion:^(BOOL finished) {
                if (finished) {
                    _isAnimating = NO;
                    _isLoaded = YES;
                    if(_openingBlock)
                        _openingBlock();
                }
            }];

        }
        __imageView.userInteractionEnabled = YES;
        [self addPanGestureToView:__imageView];
        [self addMultipleGesture];

}

#pragma mark - Add Pan Gesture
- (void) addPanGestureToView:(UIView*)view
{
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecognizerDidPan:)];
    _panGesture.cancelsTouchesInView = NO;
    _panGesture.delegate = self;
//     __weak UITableView * weakSuperView = (UITableView*) view.superview.superview.superview.superview.superview;
//    [weakSuperView.panGestureRecognizer requireGestureRecognizerToFail:_panGesture];
    [view addGestureRecognizer:_panGesture];
    [_gestures addObject:_panGesture];

}

# pragma mark - Avoid Unwanted Horizontal Gesture
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:__scrollView];
    return fabs(translation.y) > fabs(translation.x) ;
}

#pragma mark - Gesture recognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    _panOrigin = __imageView.frame.origin;
    gestureRecognizer.enabled = YES;
    return !_isAnimating;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer == _panGesture) {
        return YES;
    }
    return NO;
}


-(void)viewControlsVisisbility:(BOOL)isHidden{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(isHidden? 0.0: 0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_doneButton setHidden:isHidden];
        [_crossButton setHidden:isHidden];
        [_countLbl setHidden:isHidden];
        [_captionLbl setHidden:isHidden];
    });
}

#pragma mark - Handle Panning Activity
- (void) gestureRecognizerDidPan:(UIPanGestureRecognizer*)panGesture {
    if(__scrollView.zoomScale != 1.0f || _isAnimating)return;
//    if(_imageIndex==_initialIndex){
//        if(_senderView.alpha!=0.0f)
//           // _senderView.alpha = 0.0f;
//    }else {
//        if(_senderView.alpha!=1.0f)
//            //_senderView.alpha = 1.0f;
//    }
    // Hide the Done Button
    [self hideDoneButton];
    
    [self viewControlsVisisbility:true];
    
    __scrollView.bounces = false;
    CGSize windowSize = _blackMask.bounds.size;
    CGPoint currentPoint = [panGesture translationInView:__scrollView];
    CGFloat y = currentPoint.y + _panOrigin.y;
    CGRect frame = __imageView.frame;
    frame.origin.y = y;

   
     APP_DELEGATE.isPan = true;
    __imageView.frame = frame;

    CGFloat yDiff = fabsf((y + __imageView.frame.size.height/2) - windowSize.height/2);
    _blackMask.alpha = MAX(1 - yDiff/(windowSize.height/0.5),kMinBlackMaskAlpha);

    if ((panGesture.state == UIGestureRecognizerStateEnded || panGesture.state == UIGestureRecognizerStateCancelled) && __scrollView.zoomScale == 1.0f) {
       // __imageView = nil;
        APP_DELEGATE.isPan = false;
        if(_blackMask.alpha < 0.85f ||  currentPoint.x < -35 || currentPoint.x > 50) {
            [self dismissViewController];
        }else {
            [self viewControlsVisisbility:false];
            [self rollbackViewController];
        }
    }
}

#pragma mark - Just Rollback
- (void)rollbackViewController
{
    _isAnimating = YES;
    APP_DELEGATE.isPan = false;
    [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
        __imageView.frame = imgFrame;
        
        _blackMask.alpha = 1;
    }   completion:^(BOOL finished) {
        if (finished) {
            _isAnimating = NO;
        }
    }];
}


#pragma mark - Dismiss
- (void)dismissViewController
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GalleryClosed" object: [NSString stringWithFormat:@"%d", APP_DELEGATE.imgIndex]];
    
    _isAnimating = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideDoneButton];
        __imageView.clipsToBounds = YES;
        CGFloat screenHeight =  [[UIScreen mainScreen] bounds].size.height;
        CGFloat imageYCenterPosition = __imageView.frame.origin.y + __imageView.frame.size.height/2 ;
        BOOL isGoingUp =  imageYCenterPosition < screenHeight/2;
        [UIView animateWithDuration:0.4f delay:0.0f options:0 animations:^{
            
            // image view back to holder of previous view image view
            
//            if(_imageIndex==_initialIndex){
//                __imageView.frame = _originalFrameRelativeToScreen;
//            }else {
                __imageView.frame = CGRectMake(__imageView.frame.origin.x, isGoingUp?-screenHeight:screenHeight, __imageView.frame.size.width, __imageView.frame.size.height);
          // }
            CGAffineTransform transf = CGAffineTransformIdentity;
            _rootViewController.view.transform = CGAffineTransformScale(transf, 1.0f, 1.0f);
            _blackMask.alpha = 0.0f;
            
            
            //_senderView.alpha = 1.0f;
            //[self close:nil];
//            _senderView.alpha = 1.0f;
//            [_viewController.view removeFromSuperview];
//            [_viewController removeFromParentViewController];
//            _senderView.alpha = 1.0f;
//            [UIApplication sharedApplication].statusBarHidden = NO;
//            [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
//            _isAnimating = NO;
//            if(_closingBlock)
//                _closingBlock();

        } completion:^(BOOL finished) {
            if (finished) {
                _senderView.alpha = 1.0f;
                [_viewController.view removeFromSuperview];
                [_viewController removeFromParentViewController];
                _senderView.alpha = 1.0f;
                [UIApplication sharedApplication].statusBarHidden = NO;
                [UIApplication sharedApplication].statusBarStyle = _statusBarStyle;
                _isAnimating = NO;
                if(_closingBlock)
                    _closingBlock();
            }
        }];
    });
}

#pragma mark - Compute the new size of image relative to width(window)
- (CGRect) centerFrameFromImage:(UIImage*) image {
    if(!image) return CGRectZero;

    CGRect windowBounds = _rootViewController.view.bounds;
    CGSize newImageSize = [self imageResizeBaseOnWidth:windowBounds
                           .size.width oldWidth:image
                           .size.width oldHeight:image.size.height];
    // Just fit it on the size of the screen
    newImageSize.height = MIN(windowBounds.size.height,newImageSize.height);
    imgFrame = CGRectMake(0.0f, windowBounds.size.height/2 - newImageSize.height/2, newImageSize.width, newImageSize.height);
    return CGRectMake(0.0f, windowBounds.size.height/2 - newImageSize.height/2, newImageSize.width, newImageSize.height);
}

- (CGSize)imageResizeBaseOnWidth:(CGFloat) newWidth oldWidth:(CGFloat) oldWidth oldHeight:(CGFloat)oldHeight {
    CGFloat scaleFactor = newWidth / oldWidth;
    CGFloat newHeight = oldHeight * scaleFactor;
    return CGSizeMake(newWidth, newHeight);

}

# pragma mark - UIScrollView Delegate
- (void)centerScrollViewContents {
    CGSize boundsSize = _rootViewController.view.bounds.size;
    CGRect contentsFrame = __imageView.frame;

    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }

    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    __imageView.frame = contentsFrame;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return __imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    _isAnimating = YES;
    [self hideDoneButton];
    [self centerScrollViewContents];
}

- (void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    _isAnimating = NO;
}

- (void)addMultipleGesture {
    UITapGestureRecognizer *twoFingerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTwoFingerTap:)];
    twoFingerTapGesture.numberOfTapsRequired = 1;
    twoFingerTapGesture.numberOfTouchesRequired = 2;
    [__scrollView addGestureRecognizer:twoFingerTapGesture];

    UITapGestureRecognizer *singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    singleTapRecognizer.numberOfTapsRequired = 1;
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:singleTapRecognizer];

    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDobleTap:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [__scrollView addGestureRecognizer:doubleTapRecognizer];

    [singleTapRecognizer requireGestureRecognizerToFail:doubleTapRecognizer];

    __scrollView.minimumZoomScale = kMinImageScale;
    __scrollView.maximumZoomScale = kMaxImageScale;
    __scrollView.zoomScale = 1;
    [self centerScrollViewContents];
}

#pragma mark - For Zooming
- (void)didTwoFingerTap:(UITapGestureRecognizer*)recognizer {
    CGFloat newZoomScale = __scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, __scrollView.minimumZoomScale);
    [__scrollView setZoomScale:newZoomScale animated:YES];
}

#pragma mark - Showing of Done Button if ever Zoom Scale is equal to 1
- (void)didSingleTap:(UITapGestureRecognizer*)recognizer {
    
    
    CGPoint touchLocation = [recognizer locationInView:_crossButton];
    if (touchLocation.x < 55 && touchLocation.y < 55 ) {
        [self close:_crossButton];
    }
    else if (touchLocation.x > self.bounds.size.width - 50 && touchLocation.y < 55){
         [self close:_crossButton];
    }
    
    //NSLog(@":%@", touchLocation);
    
    
    
//    UIButton *btn = (UIButton *)recognizer.view.subviews;
//    NSLog(@":%d", btn.tag);
//    
//    
//    NSLog(@":%@", recognizer.view.subviews);
//    NSLog(@":%@", recognizer.view);
    
//    if(_crossButton.superview){
//        [self hideDoneButton];
//    }else {
//        if(__scrollView.zoomScale == __scrollView.minimumZoomScale){
//            if(!_isDoneAnimating){
//                _isDoneAnimating = YES;
//               // [self.viewController.view addSubview:_doneButton];
//                [self.viewController.view addSubview:_crossButton];
//              //  _doneButton.alpha = 0.0f;
//                _crossButton.alpha = 0.0f;
//                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                  //  _doneButton.alpha = 1.0f;
//                    _crossButton.alpha = 1.0f;
//                } completion:^(BOOL finished) {
//                   // [self.viewController.view bringSubviewToFront:_doneButton];
//                     [self.viewController.view bringSubviewToFront:_crossButton];
//                    _isDoneAnimating = NO;
//                }];
//            }
//        }else if(__scrollView.zoomScale == __scrollView.maximumZoomScale) {
//            CGPoint pointInView = [recognizer locationInView:__imageView];
//            [self zoomInZoomOut:pointInView];
//        }
//    }
}

-(void)sharePropertyUrll{
    // definesPresentationContext = true;
    _viewController.definesPresentationContext = true;
     NSArray *urlToShare = @[@"Roman is coming"];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:urlToShare applicationActivities:nil];
   // [_viewController addChildViewController:activityController];
    [_viewController presentViewController:activityController animated:NO completion:^{
        NSLog(@":%@", _viewController);
        
        NSLog(@"present");
    }];
    
  //  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        //[self presentViewController:activityController animated:YES completion:nil];
        // NSArray *execludedType = @[UIActivityTypeAirDrop];
        //activityController.excludedActivityTypes = execludedType;
        //[[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:activityController.view];
        //[_blackMask presentViewController:activityController animated:YES completion:nil];
    //});
    
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"shareProperty" object: [NSString stringWithFormat:@"%ld", (long)_imageIndex]];
}

#pragma mark - Zoom in or Zoom out
- (void)didDobleTap:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:__imageView];
    [self zoomInZoomOut:pointInView];
}

- (void) zoomInZoomOut:(CGPoint)point {
    // Check if current Zoom Scale is greater than half of max scale then reduce zoom and vice versa
    CGFloat newZoomScale = __scrollView.zoomScale > (__scrollView.maximumZoomScale/2)?__scrollView.minimumZoomScale:__scrollView.maximumZoomScale;

    CGSize scrollViewSize = __scrollView.bounds.size;
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = point.x - (w / 2.0f);
    CGFloat y = point.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    [__scrollView zoomToRect:rectToZoomTo animated:YES];
}

#pragma mark - Hide the Done Button
- (void) hideDoneButton {
    if(!_isDoneAnimating){
        if(_crossButton.superview) {
            _isDoneAnimating = YES;
           // _doneButton.alpha = 1.0f;
           // _crossButton.alpha = 1.0f;
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
             //   _doneButton.alpha = 0.0f;
             //   _crossButton.alpha = 0.0f;
            } completion:^(BOOL finished) {
                _isDoneAnimating = NO;
               // [_crossButton removeFromSuperview];
            }];
        }
    }
}

- (void)close:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    [sender removeFromSuperview];
    [self dismissViewController];
}

- (void) dealloc {

}

@end

@interface MHFacebookImageViewer()<UIGestureRecognizerDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_gestures;

    UITableView * _tableView;
    UIView *_blackMask;
    UIImageView * _imageView;
    UIButton * _doneButton, * _crossButton;
    UIView * _superView, * _bottomView;
   UILabel * _captionLbl, * _countLbl;

    CGPoint _panOrigin;
    CGRect _originalFrameRelativeToScreen;

    BOOL _isAnimating;
    BOOL _isDoneAnimating;
    int previousindex;

    UIStatusBarStyle _statusBarStyle;
    
    CAGradientLayer *gradient1;
}

@end

@implementation MHFacebookImageViewer
@synthesize rootViewController = _rootViewController;
@synthesize imageURL = _imageURL;
@synthesize openingBlock = _openingBlock;
@synthesize closingBlock = _closingBlock;
@synthesize senderView = _senderView;
@synthesize initialIndex = _initialIndex;

#pragma mark - TableView datasource

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(self.view.bounds.size.width, collectionView.frame.size.height);
//}



- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Just to retain the old version
    
   // return 7;
    
    if(!self.imageDatasource) return 1;
    return [self.imageDatasource numberImagesForImageViewer:self];
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    static NSString * cellID = @"mhfacebookImageViewerCell";
    MHFacebookImageViewerCell * imageViewerCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
//    NSLog(@":%d", imageViewerCell.isPan);
//    
//    if (imageViewerCell.isPan) {
//         [imageViewerCell setImageURL:nil defaultImage:nil imageIndex:indexPath.row];
//        //imageViewerCell.imageView = nil;
//        return imageViewerCell;
//    }
  //  NSLog(@":%d", indexPath.row);
    
    if(!imageViewerCell) {
        CGRect windowFrame = [[UIScreen mainScreen] bounds];
        imageViewerCell = [[MHFacebookImageViewerCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        imageViewerCell.transform = CGAffineTransformMakeRotation(M_PI_2);
        imageViewerCell.frame = CGRectMake(0,0,windowFrame.size.width, windowFrame.size.height);
        imageViewerCell.originalFrameRelativeToScreen = _originalFrameRelativeToScreen;
        imageViewerCell.viewController = self;
        imageViewerCell.blackMask = _blackMask;
        imageViewerCell.rootViewController = _rootViewController;
        imageViewerCell.closingBlock = _closingBlock;
        imageViewerCell.openingBlock = _openingBlock;
        imageViewerCell.superView = _senderView.superview;
        imageViewerCell.senderView = _senderView;
        imageViewerCell.doneButton = _doneButton;
        imageViewerCell.captionLbl = _captionLbl;
        imageViewerCell.countLbl = _countLbl;
        imageViewerCell.crossButton = _crossButton;
        imageViewerCell.initialIndex = _initialIndex;
        imageViewerCell.statusBarStyle = _statusBarStyle;
        [imageViewerCell loadAllRequiredViews];
        imageViewerCell.backgroundColor = [UIColor clearColor];
    }
   
    
//    if (previousindex == indexPath.row) {
//        return  imageViewerCell;
//    }
    
   //  previousindex = indexPath.row;
    
    
    
    
    imageViewerCell.captionLbl.text = [NSString stringWithFormat:@"image %ld", (long)indexPath.row];
    if(!self.imageDatasource) {
        // Just to retain the old version
        [imageViewerCell setImageURL:_imageURL defaultImage:_senderView.image imageIndex:0];
    } else {
        [imageViewerCell setImageURL:[self.imageDatasource imageURLAtIndex:indexPath.row imageViewer:self] defaultImage:[self.imageDatasource imageDefaultAtIndex:indexPath.row imageViewer:self]imageIndex:indexPath.row];
    }
    return imageViewerCell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    APP_DELEGATE.isPan = false;
    CGRect windowFrame = [[UIScreen mainScreen] bounds];
    MHFacebookImageViewerCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0  ]];
    [cell setImageURL:[self.imageDatasource imageURLAtIndex:scrollView.contentOffset.y/windowFrame.size.width imageViewer:self] defaultImage:[self.imageDatasource imageDefaultAtIndex:scrollView.contentOffset.y/windowFrame.size.width imageViewer:self]imageIndex:scrollView.contentOffset.y/windowFrame.size.width];
    APP_DELEGATE.imgIndex = scrollView.contentOffset.y/windowFrame.size.width;
    NSLog(@":%d", APP_DELEGATE.imgIndex);
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _rootViewController.view.bounds.size.width;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    _statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    [UIApplication sharedApplication].statusBarHidden = YES;
    CGRect windowBounds = [[UIScreen mainScreen] bounds];

    // Compute Original Frame Relative To Screen
    CGRect newFrame = [_senderView convertRect:windowBounds toView:nil];
    newFrame.origin = CGPointMake(newFrame.origin.x, newFrame.origin.y);
    newFrame.size = _senderView.frame.size;
    _originalFrameRelativeToScreen = newFrame;

    self.view = [[UIView alloc] initWithFrame:windowBounds];
    //    NSLog(@"WINDOW :%@",NSStringFromCGRect(windowBounds));
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    // Add a Tableview
    _tableView = [[UITableView alloc]initWithFrame:windowBounds style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    //rotate it -90 degrees
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    _tableView.frame = CGRectMake(0,0,windowBounds.size.width,windowBounds.size.height);
    _tableView.pagingEnabled = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delaysContentTouches = YES;
    [_tableView setShowsVerticalScrollIndicator:NO];
    [_tableView setContentOffset:CGPointMake(0, _initialIndex * windowBounds.size.width)];

    _blackMask = [[UIView alloc] initWithFrame:windowBounds];
    _blackMask.backgroundColor = [UIColor blackColor];
    _blackMask.alpha = 0.0f;
    _blackMask.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [
     self.view insertSubview:_blackMask atIndex:0];

    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_doneButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];  // make click area bigger
    [_doneButton setImage:[UIImage imageNamed:@"Done"] forState:UIControlStateNormal];
    _doneButton.frame = CGRectMake(windowBounds.size.width - (51.0f + 9.0f),15.0f, 51.0f, 26.0f);
  
//    [_doneButton addTarget:self
//                    action:@selector(sharePropertyUrll)
//          forControlEvents:UIControlEventTouchDown];
  //  [_doneButton setBackgroundColor:defaultColor];
    [self.view addSubview:_doneButton];
    [self.view bringSubviewToFront:_doneButton];
    
    _crossButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_crossButton setImageEdgeInsets:UIEdgeInsetsMake(-10, -10, -10, -10)];
    [_crossButton setImage:[UIImage imageNamed:@"cross"] forState:UIControlStateNormal];
    [_crossButton setFrame:CGRectMake(0, 15.0f, 51.0f, 26.0f)];
 //   [_crossButton setBackgroundColor:defaultColor];
    [self.view addSubview:_crossButton];
    [self.view bringSubviewToFront:_crossButton];
    
    
    _captionLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, windowBounds.size.height - 40, windowBounds.size.width - 137, 35)];
   // [_captionLbl setText:@"Property1"];
    [_captionLbl setNumberOfLines:2];
    [_captionLbl setTextColor: [UIColor whiteColor]];
    [_captionLbl setFont: [UIFont systemFontOfSize:17.0]];
    //[_captionLbl setBackgroundColor: [UIColor greenColor]];
    [self.view addSubview:_captionLbl];
    [self.view bringSubviewToFront:_captionLbl];
    
    _countLbl = [[UILabel alloc] initWithFrame:CGRectMake(windowBounds.size.width - 94 , windowBounds.size.height - 40, 82, 35)];
    // [_captionLbl setText:@"Property1"];
    [_countLbl setTextColor: [UIColor whiteColor]];
    [_countLbl setFont: [UIFont systemFontOfSize:17.0]];
    [_countLbl setTextAlignment:NSTextAlignmentRight];

    [self.view addSubview:_countLbl];
    [self.view bringSubviewToFront:_countLbl];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, windowBounds.size.height - 44, windowBounds.size.width, 44)];
    //[_bottomView setBackgroundColor:defaultColor];
    
    [self.view addSubview:_bottomView];
    [self.view bringSubviewToFront:_bottomView];
    [self initialiseGradientView:_bottomView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"captionNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captionText:) name:@"captionNotification" object:nil];
}

- (void)initialiseGradientView:(UIView *)gradView {
    
    if (gradient1) {
        gradient1.frame = CGRectMake(0, gradView.frame.origin.y, gradView.frame.size.width, gradView.frame.size.height);
        return;
    }

    gradient1 = [CAGradientLayer layer];
    gradient1.frame = CGRectMake(0, gradView.frame.origin.y, gradView.frame.size.width, gradView.frame.size.height);
    gradient1.colors =  [NSArray arrayWithObjects:(id)[[[UIColor clearColor] colorWithAlphaComponent:0.01] CGColor],(id)[[[UIColor clearColor] colorWithAlphaComponent:0.05] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor], nil];
    [gradView.layer insertSublayer:gradient1 atIndex:0];
    
    //    [shadowView.layer insertSublayer:gradient1 atIndex:0];
    
//    gradient2 = [CAGradientLayer layer];
//    gradient2.frame = CGRectMake(0, 0, bottomView.frame.size.width, bottomView.frame.size.height);
//    gradient2.colors =  [NSArray arrayWithObjects:(id)[[[UIColor clearColor] colorWithAlphaComponent:0.01] CGColor],(id)[[[UIColor clearColor] colorWithAlphaComponent:0.05] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:0.1] CGColor], nil];
//    [bottomView.layer insertSublayer:gradient2 atIndex:0];
}


-(void)addTapGesture:(UIButton *)btn{
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(captionText:)];
    [gesture setNumberOfTapsRequired:1];
    [btn addGestureRecognizer:gesture];
}

-(void)captionText:(NSNotification *)notify{
    [_captionLbl setText: notify.userInfo[@"caption"]];
    [_countLbl setText: [NSString stringWithFormat:@"%d/%d", [notify.userInfo[@"imageIndex"] intValue], [notify.userInfo[@"imagesCount"] intValue]]];
}

#pragma mark - Show
- (void)presentFromRootViewController
{
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    [self presentFromViewController:rootViewController];
}

- (void)presentFromViewController:(UIViewController *)controller
{
    _rootViewController = controller;
    [[[[UIApplication sharedApplication]windows]objectAtIndex:0]addSubview:self.view];
    [controller addChildViewController:self];
   // self.definesPresentationContext = YES;
    [self didMoveToParentViewController:controller];
}



- (void) dealloc {
    _rootViewController = nil;
    _imageURL = nil;
    _senderView = nil;
    _imageDatasource = nil;

}
@end


#pragma mark - Custom Gesture Recognizer that will Handle imageURL
@interface MHFacebookImageViewerTapGestureRecognizer()

@end

@implementation MHFacebookImageViewerTapGestureRecognizer
@synthesize imageURL;
@synthesize openingBlock;
@synthesize closingBlock;
@synthesize imageDatasource;
@end

