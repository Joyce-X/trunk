//
//  XMAddCarController.m
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMAddCarController.h"
#import "XMChooseCarViewController.h"
#import "XMInputView.h"
#import "XMQRCodeViewController.h"
#import "XMQRCodeWriteInfoViewController.h"
#import "XMCarModel.h"
#import "XMContentView.h"

@interface XMAddCarController ()<XMInputViewDelegate,XMChooseCarViewControllerDelegate,XMQRCodeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *IMEILabel;

@property (weak, nonatomic) XMInputView *inputView;

@property (strong, nonatomic) XMCarModel *carModel;//!< 车辆模型
@property (copy, nonatomic) NSString *number;//!< save时进行判断
@property (copy, nonatomic) NSString *imei;//!< save时进行判断

@property (weak, nonatomic) XMContentView *contentView;//!< 容器，inputView载体

/**
 显示汽车对应的汽车图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

@end

@implementation XMAddCarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupInit];
}

- (void)setupInit{

    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"关联车辆", nil);
    
    XMContentView *contentView = [XMContentView new];
    
    contentView.frame = CGRectMake(0, mainSize.height, mainSize.width, mainSize.height);
    
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
    
    //!< 添加inputVIew
    XMInputView *inputView = [[NSBundle mainBundle] loadNibNamed:@"XMInputView" owner:nil options:nil].firstObject;
    
    inputView.delegate = self;
    
    inputView.frame = CGRectMake(0, mainSize.height - 100, mainSize.width, 100);
    
    inputView.showLeftLabel = NO;
    
    [self.contentView addSubview:inputView];
    
    self.inputView = inputView;

    
    UIView *view = [self.view viewWithTag:7778];
    
    //!< 添加保存按钮
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [saveBtn setImage:[UIImage imageNamed:@"save_icon"] forState:UIControlStateNormal];
    
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    
    [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:saveBtn];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(44, 44));
        
        make.right.equalTo(self.view).offset(-20);
        
        make.centerY.equalTo(view);
        
    }];
    
    //!< 监听手动填写imei的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manulWriteFinished:) name:kCHEXIAOMISETTINGQRCODIDIDFINISHSCANNOTIFICATION object:nil];
}

/**
 *  点击设置车型
 */
- (IBAction)setBrand:(id)sender {
    
    XMChooseCarViewController *vc = [XMChooseCarViewController new];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击设置车牌
 */
- (IBAction)setCarNumber:(id)sender {
    
 
    self.inputView.limitLength = 0;//!< 不限制长度
    
    [self.contentView showFirstLevel];
    
}

/**
 *  点击设置IMEI
 */
- (IBAction)setIMEI:(id)sender {
    
    XMQRCodeViewController *vc = [XMQRCodeViewController new];
    
    vc.writeImeiBlack = ^{
        //!< 手动填写imei的callback  跳转过程：扫描界面 - 当前界面 - XMQRCodeWriteInfoViewController（手动填写界面）
        XMQRCodeWriteInfoViewController *vc = [XMQRCodeWriteInfoViewController new];
        
        [self.navigationController pushViewController:vc animated:NO];
        
    };
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark ------- XMInputViewDelegate

/**
 inputView点击ok按钮
 
 @param view trigger
 */
- (void)inputViewOKClick:(XMInputView*)view
{
    self.carNumberLabel.text = view.result;

    self.number = view.result;
    
    
 }

#pragma mark ------- XMChooseViewControllerDelegate

- (void)chooseVCDidsSelectCar:(XMCarModel *)car
{
    
    self.brandLabel.text = car.brand;

    self.carModel = car;
    
    //!< 设置汽车对应的图标
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",car.brandNumber];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (image)
    {
        //!< 汽车对应的图标存在，显示
        self.carImageView.image = image;
        
    }else
    {
        //!< 汽车对应的图标不存在，显示默认图标
        self.carImageView.image = [UIImage imageNamed:@"no"];
        
    }

    
    
}

#pragma mark ------- XMQRCodeViewControllerDelegate
- (void)qrcodeFinishScan:(NSString *)result
{

    self.IMEILabel.text = result;
    self.imei = result;

}

#pragma mark ------- 点击按钮
- (void)saveBtnClick
{
    
    if (self.number.length == 0 || self.imei.length == 0 || self.carModel == nil)
    {
        [MBProgressHUD showError:JJLocalizedString(@"信息不够完整", nil)];//!< 不完善的信息
        
        return;
    }
    
    XMUser *user = [XMUser user];
    
    //!< 保存车辆
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Qiche_add&Userid=%lu&Imei=%@&Chepaino=%@&Brandid=%@&Seriesid=%@&Styleid=%@",user.userid,self.IMEILabel.text,self.carNumberLabel.text,_carModel.brandNumber,_carModel.serialNumber,_carModel.styleNumber];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //!< 转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        switch (result) {
            case 0:
                [MBProgressHUD showError:JJLocalizedString(@"无效用户", nil)];//无效用户
                break;
            case -1:
                [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];//网络错误
                break;
            case -2:
                [MBProgressHUD showError:JJLocalizedString(@"车牌号已存在", nil)];//车牌号已经存在
                break;
            case -3:
                [MBProgressHUD showError:JJLocalizedString(@"无效车牌号", nil)];//车牌号无效
                break;
                
            default:
            {
                
                [MBProgressHUD showSuccess:JJLocalizedString(@"保存成功", nil)];//保存成功
                
                //!< 监控主界面刷信息,通知主界面从新获取默认车辆信息
                [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
                
                //->>通知代理更新界面
                if ([self.delegate respondsToSelector:@selector(shouldRefresh)])
                {
                    [self.delegate shouldRefresh];
                }
 
                NSString *qicheId = [[NSString alloc]initWithFormat:@"%d",result];
 
                //!< 判断是否设置为默认车辆
                [self setThisCarDefaultAfterAddWithCarID:qicheId];

                //!< 默认进行激活
                [self performSelector:@selector(onLineActiveWithCarId:) withObject:qicheId afterDelay:1.5];
                
                //!< 返回上级界面
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
                
                break;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        [MBProgressHUD showError:JJLocalizedString(@"保存失败，请检查网络", nil)];
        
    }];

    
    
}

- (void)setThisCarDefaultAfterAddWithCarID:(NSString *)qicheId
{
    
    /**
     *  是否设置当前车辆为默认车辆，  如果用户模型的汽车id大于0 ，则说明用户有默认车辆，否则设置当前为默认车辆
     */
    XMUser *user = [XMUser user];
    
    if (user.chepaino.length > 0 && user.qicheid.integerValue > 0)
    {
        return;//!< 不需要设置默认车辆
    }
    
    //!< 如果用户还没有车辆数据，说明第一次添加车辆，默认设置这辆车为默认车辆
     NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_setfirst&Userid=%lu&Qicheid=%@",user.userid, qicheId];
    
    //!< 转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        switch (result)
        {
            case 0:
                XMLOG(@"设置默认车辆失败，网络错误");
                
                [XMMike addLogs:@"设置默认车辆失败，网络错误"];

                break;
            case 1:
                
                XMLOG(@"设置默认车辆成功");
                
                [XMMike addLogs:@"设置默认车辆成功"];

                
                //!< 发送通知，通知相关界面，默认车辆已经修改成功
                
                [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
                
//                self.userCarCount++;//!< 做++操作，防止在当前界面继续修改车牌添加设置默认
                
                
                break;
            case -1:
                
                XMLOG(@"设置默认车辆失败，网络错误");
                
                [XMMike addLogs:@"设置默认车辆失败，网络错误"];

                
                break;
                
            default:
                break;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view  animated:NO];
        
        XMLOG(@"设置默认车辆失败，网络错误");
        
        [XMMike addLogs:@"设置默认车辆失败，网络错误"];

    }
     ];
    

    
}

/**
 *  每次添加车辆成功后，都必须要静默对车辆进行激活，激活成功后，判断是否更新数据
 */
- (void)onLineActiveWithCarId:(NSString *)qicheId
{
    
    //!< 在线激活 发送101指令
    
   XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Active&Userid=%lu&Qicheid=%@",user.userid,qicheId];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        int statusCode = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        switch (statusCode)
        {
            case 0:
                
                XMLOG(@"激活失败，网络错误");
                
                [XMMike addLogs:@"激活失败，网络错误"];

                
                break;
                
            case -1:
                
                XMLOG(@"激活失败，终端不在线");
                
                [XMMike addLogs:@"激活失败，终端不在线"];

                break;
                
                
                
            default:
                
                //!< 激活成功，返回终端编号
                XMLOG(@"激活成功");
                
                [XMMike addLogs:@"激活成功"];

                
                //!< 设备激活成功之后，需要判定当前车辆是否为默认车辆，如果是默认车辆的话需要更新全局数据
                if (qicheId.integerValue == user.qicheid.integerValue)
                {
                    XMLOG(@"---------用户默认汽车id和当前激活的汽车id一致，激活成功，准备更新全局数据---------");
                    
                    
                    [XMMike addLogs:@"---------用户默认汽车id和当前激活的汽车id一致，激活成功，准备更新全局数据---------"];

                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
                }
                
                break;
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"激活失败，网络错误");
        
        [XMMike addLogs:@"激活失败，网络错误"];

    }];
    
    
}

#pragma mark ------- 响应通知的方法

/**
 *  手动填写完成imei号码
 */
- (void)manulWriteFinished:(NSNotification *)noti
{
    
    NSString *result = noti.userInfo[@"info"];
    
    self.imei = result;
    
    self.IMEILabel.text = result;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;

}


@end
