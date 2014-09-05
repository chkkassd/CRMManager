//
//  ZDScanBarCodeViewController.m
//  CRMManager
//
//  Created by peter on 14-9-5.
//  Copyright (c) 2014年 peter. All rights reserved.
//

#import "ZDScanBarCodeViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ZDScanBarCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView * viewPreview;
@property (strong, nonatomic) AVCaptureSession * captureSession;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer * videoPreviewLayer;

@end

@implementation ZDScanBarCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startCaptureBarCode];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self stopCaptureBarCode];
}

#pragma mark - methods

- (void)startCaptureBarCode
{
    //捕捉设备
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //输入
    NSError * error;
    AVCaptureDeviceInput * videoInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (!videoInput) {
        NSLog(@"%@",[error localizedDescription]);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"此设备没有摄像头" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    //输出
    AVCaptureMetadataOutput * videoOutput = [[AVCaptureMetadataOutput alloc] init];
    
    //添加输入和输出
    [self.captureSession addInput:videoInput];
    [self.captureSession addOutput:videoOutput];
    
    //捕捉视频信息并输出为异步操作，开线程
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [videoOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [videoOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    //设置视频信息输出
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.videoPreviewLayer.frame = self.viewPreview.layer.bounds;
    [self.viewPreview.layer addSublayer:self.videoPreviewLayer];
    
    //开始扫瞄输出
    [self.captureSession startRunning];
}

- (void)stopCaptureBarCode
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.videoPreviewLayer removeFromSuperlayer];
}

#pragma mark - properties

- (AVCaptureSession *)captureSession
{
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
    }
    return _captureSession;
}

#pragma mark - AVCaptureMeatadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects != nil && metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject * metaobj = metadataObjects[0];
        if ([metaobj.type isEqualToString:AVMetadataObjectTypeQRCode]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                //回到主线程做主线程操作
                [self stopCaptureBarCode];
                NSLog(@"%@",[metaobj stringValue]);
            });
        }
    }
}

@end
