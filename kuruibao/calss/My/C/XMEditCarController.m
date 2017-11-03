//
//  XMEditCarController.m
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMEditCarController.h"
#import "XMInputView.h"
#import "XMCarModel.h"
#import "XMChooseCarViewController.h"

#import "XMContentView.h"

@interface XMEditCarController ()<XMInputViewDelegate,XMChooseCarViewControllerDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

/**
 提示用户点此设置默认车辆
 */
@property (weak, nonatomic) IBOutlet UILabel *label3;

@property (weak, nonatomic) XMContentView *contentView;//!< 容器，inputView载体
@property (weak, nonatomic) XMInputView *inputView;

//!< 保存的时候进行判定
@property (strong, nonatomic) XMCarModel *carBrandModel;//!< 车辆模型
@property (copy, nonatomic) NSString *number;//!< save时进行判断
@property (copy, nonatomic) NSString *imei;//!< save时进行判断

//@property (weak, nonatomic) IBOutlet UISwitch *isDefault;  废弃

/**
 显示车辆对应的汽车图标
 */
@property (weak, nonatomic) IBOutlet UIImageView *carIV;

@end

@implementation XMEditCarController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupInit];
}

- (void)setupInit {
    
    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"编辑车辆", nil);
    
    self.label1.text = _carModel.brandname;
    
    self.label2.text = _carModel.chepaino;
    
    /*
    //!< 根据车辆是否是默认车辆来设置默认车辆的状态
    self.isDefault.on = _carModel.isfirst;
    
    //!< 如果是默认车辆的话，就设置开关不可点击，并且设置为灰色
    if(_carModel.isfirst)
    {
        self.isDefault.userInteractionEnabled = NO;
        
        self.isDefault.onTintColor = XMGrayColor;
    }
    
    */
    
    //!< 如果根据车辆品牌可以找到对应的图片就设置图片，否则加载默认图片
    NSString *imageName = [NSString stringWithFormat:@"%lu.jpg",_carModel.carbrandid];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (image)
    {
        self.carIV.image = image;
    }
    
    
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
    
    XMContentView *contentView = [XMContentView new];
    
    contentView.frame = CGRectMake(0, mainSize.height, mainSize.width, mainSize.height);
    
    [self.view addSubview:contentView];
    
    self.contentView = contentView;
    
    //!< 添加inputVIew
    XMInputView *inputView = [[NSBundle mainBundle] loadNibNamed:@"XMInputView" owner:nil options:nil].firstObject;
    
    inputView.delegate = self;
    
    inputView.content = self.label2.text;
    
    inputView.frame = CGRectMake(0, mainSize.height - 100, mainSize.width, 100);
    
    inputView.showLeftLabel = NO;
    
    [self.contentView addSubview:inputView];
    
    self.inputView = inputView;
    
    
    //!< 对设置默认车辆的显示内容进行国际化
    _label3.text = JJLocalizedString(@"设置为默认车辆", nil);
    
}

#pragma mark ------- XMChooseViewControllerDelegate

- (void)chooseVCDidsSelectCar:(XMCarModel *)car
{
    
    self.label1.text = car.brand;
    
    self.carBrandModel = car;
    
    //!< 设置汽车对应的图标
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",car.brandNumber];
    
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (image)
    {
        //!< 汽车对应的图标存在，显示
        self.carIV.image = image;
        
    }else
    {
        //!< 汽车对应的图标不存在，显示默认图标
        self.carIV.image = [UIImage imageNamed:@"no"];
    
    }
    
}

#pragma mark ------- XMInputViewDelegate

/**
 inputView点击ok按钮
 
 @param view trigger
 */
- (void)inputViewOKClick:(XMInputView*)view
{
    self.label2.text = view.result;
    
    self.number = view.result;
}

#pragma mark ------- 点击按钮

- (void)saveBtnClick
{
    
    
    //!< 判断数据是否有变化
    if ([self.carModel.brandname isEqualToString:self.label1.text] && [self.carModel.chepaino isEqualToString:self.label2.text]) {
        
        //!< 数据没有变化
        [MBProgressHUD showError:JJLocalizedString(@"您还未修改数据", nil)];
        
        return;
        
    }
    
    XMUser *user = [XMUser user];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.carBrandModel == nil)
    {
        //!< 没有更改车型的情况
        self.carBrandModel = [XMCarModel new];
        
        self.carBrandModel.brandNumber = [NSString stringWithFormat:@"%lu",self.carModel.carbrandid];
        self.carBrandModel.serialNumber = [NSString stringWithFormat:@"%lu",self.carModel.carseriesid];
        self.carBrandModel.styleNumber = [NSString stringWithFormat:@"%lu",self.carModel.carstyleid];
    }
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"updateqicheinfo&Userid=%lu&Qicheid=%lu&Chepaino=%@&Brandid=%@&Seriesid=%@&Styleid=%@",user.userid,(long)self.carModel.qicheid,self.label2.text,_carBrandModel.brandNumber,_carBrandModel.serialNumber,_carBrandModel.styleNumber];
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//!< 转码
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        switch (result.intValue) {
            case 0:
                
                [MBProgressHUD showError:JJLocalizedString(@"无效用户", nil)];//无效用户
                
                break;
            case -1:
                
                [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];//网络异常
                
                break;
            case -2:
                [MBProgressHUD showError:JJLocalizedString(@"更新失败，请检查网络", nil)];//更新失败
                break;
            case 1:
            {
                
                [MBProgressHUD showError:JJLocalizedString(@"更新成功", nil)];//更新成功
                
                 XMDashPalManager *manager = [XMDashPalManager shareManager];
                
                 manager.carNumber = self.label2.text;
                
                [self.delegate  shouldUpdateData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
                //!< 修改车辆成功，判断是否是默认车辆
                if (self.carModel.isfirst)
                {
                    //!< 是默认车辆，通知全局更新信息，不是默认车辆就忽略（通知主界面重新获取默认车辆）
                    [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
                    
                    XMLOG(@"---------默认车辆已经发生变化，通知主界面更新默认车辆数据---------");
                    
                    [XMMike addLogs:@"---------默认车辆已经发生变化，通知主界面更新默认车辆数据---------"];

                    
                }
            }
                 break;
            case -3:
                [MBProgressHUD showError:JJLocalizedString(@"车牌号已存在", nil)];//车牌号已被占用
                break;
                
            default:
                break;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
        
        XMLOG(@"更新车辆信息失败");
        
        [XMMike addLogs:@"更新车辆信息失败"];

        
    }];

    
}

/**
 *  点击设置默认车辆
 */
- (IBAction)setDefaultClick:(UITapGestureRecognizer *)sender {
    
    
    XMLOG(@"---------点击设置默认车辆---------");
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:JJLocalizedString(@"切换默认车辆", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"取消 ", nil) otherButtonTitles:JJLocalizedString(@"是", nil), nil];
    
    [alert show];
    
}


/**
 *  点击选择车辆
 */
- (IBAction)chooseCar:(id)sender {
    
    XMChooseCarViewController *vc = [XMChooseCarViewController new];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];

}

/**
 *  点击设置车牌号码
 */
- (IBAction)chooseNumber:(id)sender {
    
//      [self.inputView becomeFirstResponder]; 点击的时候，首先展示contentView
    
    self.inputView.limitLength = 0;//!< 不限制长度
    
    self.inputView.content = self.label2.text;
    
    
    [self.contentView showFirstLevel];
    
}

/**
 能进到这个方法，说明当前车辆不是默认车辆，准备进行设置默认车辆操作--------------------------------- 由于需求更新，此方法已经废弃

 @param sender 开关 trigger
 */
- (IBAction)valueChange:(UISwitch *)sender {
    
   
    
    
}

#pragma mark ------- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1)
    {
        //!< 点击确认设置默认车辆
        //!< 判断网络
        if (!connecting)
        {
            [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];return;
        }
        
        //!< 设置默认车辆
        [MBProgressHUD showMessage:nil];
        
        XMUser *user = [XMUser user];
        
        NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_setfirst&Userid=%lu&Qicheid=%ld",user.userid,_carModel.qicheid];
        
        //!< 转码
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUD];
            
            int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
            
            switch (result)
            {
                case 0:
                    
                    [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];//网络异常，请稍后再试
                     
                    break;
                    
                case 1:
                    
                    //!< 设置成功，通知上一界面更新数据
                    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldUpdateData)]) {
                        
                        [self.delegate shouldUpdateData];
                    }
                    
                    [MBProgressHUD showSuccess:JJLocalizedString(@"设置成功", nil)];
                    
                    //!< 发送通知，通知相关界面，默认车辆已经修改成功
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserSetDefaultCarSuccessNotification object:nil];
                    
                    //!< 监控主界面刷信息
                    [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
             
                    XMLOG(@"设置默认车辆成功");
                {
                    //!< 返回上一界面
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }
                    break;
                    
                case -1:
                   
                    [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
                    
                    break;
                    
                default:
                    
                    break;
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [MBProgressHUD hideHUD];
            
            [MBProgressHUD showError:JJLocalizedString(@"设置失败", nil)];
            
            XMLOG(@"设置默认车辆失败");
            
            [XMMike addLogs:@"设置默认车辆失败"];
            
        }
         ];
    }

}


@end
