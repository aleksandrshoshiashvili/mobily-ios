// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "FBAdDefines.h"
#import "FBNativeAd.h"
#import "FBNativeAdsManager.h"

/*!
 @class FBNativeAdTableViewAdProvider

 @abstract Additional functionality on top of FBNativeAdsManager to assist in using native ads within a UITableView. This class contains a mechanism to map indexPaths to native ads in a stable manner as well as helpers which assist in doing the math to include ads at a regular interval within a table view.
 */
FB_CLASS_EXPORT
@interface FBNativeAdTableViewAdProvider : NSObject

/*!
 @property
 @abstract Passes delegate methods from FBNativeAd. Separate delegate calls will be made for each native ad contained.
 */
@property (nonatomic, weak) id<FBNativeAdDelegate> delegate;

/*!
 @method

 @abstract Create a FBNativeAdTableViewAdProvider.

 @param manager The FBNativeAdsManager which is consumed by this class.
 */
- (instancetype)initWithManager:(FBNativeAdsManager *)manager;

/*!
 @method

 @abstract Retrieve a native ad for an indexPath, will return the same ad for a given indexPath until the native ads manager is refreshed. This method is intended for usage with a table view and specifically the caller is recommended to wait until  tableView:cellForRowAtIndexPath: to ensure getting the best native ad for the given table cell.

 @param tableView The tableView where native ad will be used
 @param indexPath The indexPath to use as a key for this native ad
 @return A FBNativeAd which is loaded and ready to be used.
 */
- (FBNativeAd *)tableView:(UITableView *)tableView nativeAdForRowAtIndexPath:(NSIndexPath *)indexPath;

/*!
 @method

 @abstract Support for evenly distributed native ads within a table view. Computes whether this cell is an ad or not.

 @param indexPath The indexPath of the cell within the table view
 @param stride The frequency that native ads are to appear within the table view
 @return Boolean indicating whether the cell at the path is an ad
 */
- (BOOL)isAdCellAtIndexPath:(NSIndexPath *)indexPath forStride:(NSUInteger)stride;

/*!
 @method

 @abstract Support for evenly distributed native ads within a table view. Adjusts a non-ad cell indexPath to the indexPath it would be in a collection with no ads.

 @param indexPath The indexPath to of the non-ad cell
 @param stride The frequency that native ads are to appear within the table view
 @return An indexPath adjusted to what it would be in a table view with no ads
 */
- (NSIndexPath *)adjustNonAdCellIndexPath:(NSIndexPath *)indexPath forStride:(NSUInteger)stride;

/*!
 @method

 @abstract Support for evenly distributed native ads within a table view. Adjusts the total count of cells within the table view to account for the ad cells.

 @param count The count of cells in the table view not including ads
 @param stride The frequency that native ads are to appear within the table view
 @return The total count of cells within the table view including both ad and non-ad cells
 */
- (NSUInteger)adjustCount:(NSUInteger)count forStride:(NSUInteger)stride;

@end
