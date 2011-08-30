//
//  ImagePreview.m
//  ImageCroppingExample
//
//  Created by Arjun on 30/08/11.
//  Copyright 2011 Arjun Nair. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "ImagePreview.h"
#import "FinalOutputView.h"

@implementation ImagePreview
@synthesize previewImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [previewImage release];
    [scrollView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"Preview";
    
    //Show the done editing button on right side of the navigation bar
    UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    self.navigationItem.rightBarButtonItem = doneButton;
       
    [doneButton release];
    
    //The following piece of code makes images fit inside the scrollview
    //by either their width or height, depending on which is smaller.
    //I.e, portrait images will fit horizontally in the scrollview,
    //allowing user to scroll vertically, while landscape images will fit vertically,
    //allowing user to scroll horizontally. 
    CGFloat imageWidth = CGImageGetWidth(previewImage.CGImage);
    CGFloat imageHeight = CGImageGetHeight(previewImage.CGImage);
    
    int scrollWidth = scrollView.frame.size.width;
    int scrollHeight = scrollView.frame.size.height;
    
    //Limit by width or height, depending on which is smaller in relation to
    //the scrollview dimension.
    float scaleX = scrollWidth / imageWidth;
    float scaleY = scrollHeight / imageHeight;
    float scaleScroll =  (scaleX < scaleY ? scaleY : scaleX);

    scrollView.bounds = CGRectMake(0, 0,imageWidth , imageHeight );
    scrollView.frame = CGRectMake(10, 10, scrollWidth, scrollHeight);
    
    imageView = [[UIImageView alloc] initWithImage: previewImage ];
    scrollView.delegate = self;
    
    scrollView.contentSize = previewImage.size;
    scrollView.pagingEnabled = NO;
    scrollView.maximumZoomScale = scaleScroll*3;
    scrollView.minimumZoomScale = scaleScroll;
    scrollView.zoomScale = scaleScroll;
    
    [scrollView addSubview:imageView];
    [imageView release];
}

- (void)viewDidUnload
{
    [scrollView release];
    scrollView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//This function performs the actual cropping, given a rectangle to serve as the bounds.
UIImage* imageFromView(UIImage* srcImage, CGRect* rect)
{
    CGImageRef cr = CGImageCreateWithImageInRect(srcImage.CGImage, *rect);
    UIImage* cropped = [UIImage imageWithCGImage:cr];
    
    CGImageRelease(cr);
    return cropped;
}

/****** UIScrollView delegate for zooming **********/
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}
/**************************************************/

-(void) doneEditing
{
    //Calculate the required area from the scrollview
    CGRect visibleRect;
    float scale = 1.0f/scrollView.zoomScale;
    visibleRect.origin.x = scrollView.contentOffset.x * scale;
    visibleRect.origin.y = scrollView.contentOffset.y * scale;
    visibleRect.size.width = scrollView.bounds.size.width * scale;
    visibleRect.size.height = scrollView.bounds.size.height * scale;

        
    FinalOutputView* outputView = [[FinalOutputView alloc] initWithNibName:@"FinalOutputView" bundle:[NSBundle mainBundle]];
    outputView.image = imageFromView(imageView.image, &visibleRect);

    [self.navigationController pushViewController:outputView animated:YES];
    [outputView release];
}


@end
