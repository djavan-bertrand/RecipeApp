//
//  RecipeObject.m
//  RecipeApp
//
//  Created by Djavan Bertrand on 14/03/2015.
//
//

#import "RecipeObject.h"
#import "RequestManager.h"

// example of C style enum
typedef enum
{
    THUMBNAIL,
    IMAGE,
} eMEDIA_TYPE;

@interface RecipeObject()

@property (nonatomic, assign) BOOL isFetchingThumbnail;
@property (nonatomic, assign) BOOL isFetchingImage;
@property (nonatomic, assign) BOOL isFetchingDetail;
@end

@implementation RecipeObject

- (id)initWithId:(NSString*)recipeId title:(NSString*)title thumbnailUrl:(NSString*)thumbnailUrl imageUrl:(NSString*)imageUrl
{
    self = [super init];
    if (self) {
        
        _isFetchingThumbnail = NO;
        _isFetchingImage = NO;
        _isFetchingDetail = NO;
        
        _recipeId = recipeId;
        _title = title;
        _thumbUrl = thumbnailUrl;
        _imageUrl = imageUrl;
    }
    
    return self;
}

- (void)downloadThumbnail {
    if (!_isFetchingThumbnail)
    {
        _isFetchingThumbnail = YES;
        // here we need to transfor enum (which is not a NSObject) into a NSNumber
        [self performSelectorInBackground:@selector(downloadMediaInBackgroundOfType:) withObject:[NSNumber numberWithInt:THUMBNAIL]];
    }
}

- (void)downloadImage {
    if (!_isFetchingImage) {
        _isFetchingImage = NO;
        [self performSelectorInBackground:@selector(downloadMediaInBackgroundOfType:) withObject:[NSNumber numberWithInt:IMAGE]];
    }
}

- (void)downloadMediaInBackgroundOfType:(NSNumber *)mediaTypeNumber {
    eMEDIA_TYPE mediaType = [mediaTypeNumber intValue];
    
    NSString *url = nil;
    switch (mediaType) {
        case IMAGE:
            url = _imageUrl;
            break;
        case THUMBNAIL:
            url = _thumbUrl;
            break;
    }
    
    UIImage *image = nil;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    if (data)
    {
        image = [[UIImage alloc] initWithData:data];
    }
    
    switch (mediaType) {
        case IMAGE:
            _image = image;
            // call the delegate in the UI thread
            [self performSelectorOnMainThread:@selector(informDelegateOfImageReception) withObject:nil waitUntilDone:NO];
            break;
        case THUMBNAIL:
            _thumbnail = image;
            [self performSelectorOnMainThread:@selector(informDelegateOfThumbnailReception) withObject:nil waitUntilDone:NO];
            _isFetchingThumbnail = NO;
        break;
    }
}

- (void)informDelegateOfImageReception {
    if (_imageDelegate) {
        [_imageDelegate recipeObject:self didReceiveImage:_image];
    }
}

- (void)informDelegateOfThumbnailReception {
    if (_thumbDelegate) {
        [_thumbDelegate recipeObject:self didReceiveThumbnail:_thumbnail];
    }
}

- (void)downloadRecipeDetail {
    if (!_isFetchingDetail) {
        _isFetchingDetail = YES;
        [[RequestManager manager] downloadRecipeDetail:_recipeId block:^(BOOL succeed, NSString *recipeDetail) {
            _isFetchingDetail = NO;
            if (succeed) {
                _recipeText = recipeDetail;
                if (_detailDelegate) {
                    [_detailDelegate recipeObject:self didReceiveDetail:recipeDetail];
                }
            } else {
                // TODO: this should be shown in the UI
                NSLog(@"Error during recipe detail fetching. Maybe check your connectivity");
            }
        }];
    }
}

@end
