
//
//  UIButton+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/8/17.
//  Copyright © 2018年 BN. All rights reserved.
//
 
import UIKit



@objc public extension UIButton{
    
    private struct AssociateKeys {
        static var closure   = "UIButton" + "closure"

    }
    /// UIControl 添加回调方式
    override func addActionHandler(_ action: @escaping ((UIButton) ->Void), for controlEvents: UIControl.Event = .touchUpInside) {
        addTarget(self, action:#selector(p_handleActionBtn(_:)), for:controlEvents);
        objc_setAssociatedObject(self, &AssociateKeys.closure, action, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    /// 点击回调
    private func p_handleActionBtn(_ sender: UIButton) {
        if let block = objc_getAssociatedObject(self, &AssociateKeys.closure) as? ((UIButton) ->Void) {
            block(sender);
        }
    }


    ///自定义按钮类型
    @objc enum CustomType: Int {
             ///白底黑色
        case titleBlack
             ///主题色字
        case titleTheme
             ///主题色底白字
        case titleWhiteAndBackgroudTheme
             ///红底白字
        case titleWhiteAndBackgroudRed
             ///白底主题色字(带边框)
        case titleThemeAndOutline
             ///白底红字(带边框)
        case titleRedAndOutline
        
    }
    
    func setCustomType(_ type: UIButton.CustomType, for state: UIControl.State = .normal) {
        switch type {
        case .titleBlack:
            setTitleColor(.black, for: state)
            setBackgroundColor(.white, for: state)

        case .titleTheme:
            setTitleColor(.theme, for: state)
            setBackgroundColor(.white, for: state)
            
        case .titleWhiteAndBackgroudTheme:
            setTitleColor(.white, for: state)
            setBackgroundColor(.theme, for: state)
            
        case .titleWhiteAndBackgroudRed:
            setTitleColor(.white, for: state)
            setBackgroundColor(.red, for: state)

        case .titleThemeAndOutline:
            setTitleColor(.theme, for: state)
            setBackgroundColor(.white, for: state)

            layer.borderColor = UIColor.theme.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 5
//            layer.masksToBounds = true
                
        case .titleRedAndOutline:
            setTitleColor(.red, for: state)
            setBackgroundColor(.white, for: state)

            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 1
            layer.cornerRadius = 5
//            layer.masksToBounds = true
        
        default:
            break
        }
    }

//    /// 快速创建
//    convenience init(action:@escaping ControlClosure){
//        self.init()
//        self.addTarget(self, action:#selector(tapped(btn:)), for:.touchUpInside)
//        self.actionBlock = action
//        self.sizeToFit()
//    }
//
//    /// 快速创建按钮 setImage: 图片名 frame:frame action:点击事件的回调
//    convenience init(setImage: String, frame:CGRect, action: @escaping ControlClosure){
////        self.init()
//        self.init(action: action);
//
//        self.frame = frame
//        self.setImage(UIImage(named:setImage), for: .normal)
//        self.addTarget(self, action:#selector(tapped(btn:)), for:.touchUpInside)
//        self.actionBlock = action
//        self.sizeToFit()
//
//        self.frame = frame
//    }
    
    /// 创建导航栏按钮(UIButton)
    static func createBtnBarItem(_ obj: String) -> Self {
        var size = CGSize(width: 32, height: 32)
        if let _ = UIImage(named: obj) {
            size = CGSize(width: 40, height: 40)
        }
        
        let view = self.init(type: .custom);
        view.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height);
        view.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        if let image = UIImage(named: obj) {
            view.setImage(image, for: .normal);
        } else {
            view.setTitle(obj, for: .normal);
            if obj.count == 4{
                view.titleLabel?.adjustsFontSizeToFitWidth = true;
                view.titleLabel?.minimumScaleFactor = 1;
            }
        }
        return view
    }
    
    /// [源]UIButton创建(标题)
    static func create(_ rect: CGRect = .zero, title: String, textColor: UIColor, backgroundColor: UIColor) -> Self {
        let view = self.init(type: .custom);
        view.titleLabel?.font = UIFont.systemFont(ofSize:16);
//        view.titleLabel?.adjustsFontSizeToFitWidth = true;
        view.titleLabel?.minimumScaleFactor = 1.0;
        view.imageView?.contentMode = .scaleAspectFit
        view.isExclusiveTouch = true;
        view.adjustsImageWhenHighlighted = false;

        view.setTitle(title, for: .normal)
        view.setTitleColor(textColor, for: .normal)
        view.setBackgroundImage(UIImage(color: backgroundColor), for: .normal)
        view.setBackgroundImage(UIImage(color: .lightGray), for: .disabled)
        
        CGRect.zero != rect ? view.frame = rect : view.sizeToFit()
        return view
    }
    /// [源]UIButton创建(图像)
    static func create(_ rect: CGRect = .zero, imgName: String, isBackgroudImage: Bool) -> Self {
        assert(UIImage(named: imgName) != nil, "图像不能为空")

        let view = self.init(type: .custom);
        view.titleLabel?.font = UIFont.systemFont(ofSize:16);
        view.titleLabel?.adjustsFontSizeToFitWidth = true;
        view.titleLabel?.minimumScaleFactor = 1.0;
        view.imageView?.contentMode = .scaleAspectFit
        view.isExclusiveTouch = true;
        view.adjustsImageWhenHighlighted = false;

        view.frame = rect;
        if let image = UIImage(named: imgName){
            if isBackgroudImage {
                view.setBackgroundImage(image, for: .disabled)
            } else {
                view.setImage(image, for: .normal)
            }
        }
        return view
    }
        
    /// 创建 UIButton 集群
    static func createGroupView(_ rect: CGRect = .zero, list: [String], numberOfRow: Int = 4, padding: CGFloat = kPadding, action: ((UIButton)->Void)? = nil) -> UIView {
        
        let rowCount: Int = list.count % numberOfRow == 0 ? list.count/numberOfRow : list.count/numberOfRow + 1;
        let itemWidth = (rect.width - CGFloat(numberOfRow - 1)*padding)/CGFloat(numberOfRow)
        let itemHeight = (rect.height - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
        
        let backView = UIView(frame: rect);
        for (i,value) in list.enumerated() {
            let x = CGFloat(i % numberOfRow) * (itemWidth + padding);
            let y = CGFloat(i / numberOfRow) * (itemHeight + padding);
            let rect = CGRect(x: x, y: y, width: itemWidth, height: itemHeight);
            
            let button: UIButton = {
                let button = UIButton(type: .custom);
                button.frame = rect;
                button.setTitle(value, for: .normal);
                button.titleLabel?.font = UIFont.systemFont(ofSize: 15);
                button.titleLabel?.adjustsFontSizeToFitWidth = true;
                button.titleLabel?.minimumScaleFactor = 1.0;
                button.isExclusiveTouch = true;
                
                button.setTitleColor(UIColor.black, for: .normal);
                button.backgroundColor = UIColor.white;
                button.tag = i;
                
                return button;
            }()
    
            if let action = action {
                button.addActionHandler(action)
            }
            backView.addSubview(button);
        }
        return backView;
    }
    
    /// 图片上左下右配置
    func layoutButton(direction: Int, imageTitleSpace: CGFloat = 5, space: CGFloat = 0) {
        if imageView?.image == nil {
            sizeToFit()
        }
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets: UIEdgeInsets = .zero
        var labelEdgeInsets: UIEdgeInsets = .zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch direction {
        case 0:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - imageTitleSpace/2,
                                           left: 0,
                                           bottom: 0,
                                           right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageWidth!,
                                           bottom: -imageHeight! - imageTitleSpace/2,
                                           right: 0)
            break;
        case 1:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageTitleSpace/2 + space,
                                           bottom: 0,
                                           right: imageTitleSpace/2 + space)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: imageTitleSpace/2 + space,
                                           bottom: 0,
                                           right: -imageTitleSpace/2 + space)
            break;
        case 2:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: 0,
                                           bottom: -labelHeight! - imageTitleSpace/2,
                                           right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight! - imageTitleSpace/2,
                                           left: -imageWidth!,
                                           bottom: 0,
                                           right: 0)

            break;
        case 3:
            imageEdgeInsets = UIEdgeInsets(top: 0,
                                           left: labelWidth - imageTitleSpace/2 - space,
                                           bottom: 0,
                                           right: imageTitleSpace/2 + space)
            labelEdgeInsets = UIEdgeInsets(top: 0,
                                           left: -imageWidth! - imageTitleSpace/2 + space,
                                           bottom: 0,
                                           right: imageWidth! + imageTitleSpace/2 + space)

            break;
        default:
            break
        }
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }
    
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State){
        guard let color = color else { return }
        setBackgroundImage(UIImage(color: color), for: state)
    }
        
    /// UIButton不同状态下设置富文本标题
    func setContent(_ content: String, attDic: [NSAttributedString.Key: Any], for state: UIControl.State) -> NSMutableAttributedString?{
        guard let titleLabel = titleLabel,
              let text = titleLabel.text,
              text.contains(content)
              else { return nil }
        let attString = titleLabel.setContent(content, attDic: attDic)
        setAttributedTitle(attString, for: state)
        return attString
    }
    
    /// 验证码倒计时显示
    func timerStart(_ interval: Int = 60) {
        var time = interval
        let codeTimer = DispatchSource.makeTimerSource(flags: .init(rawValue: 0), queue: DispatchQueue.global())
        codeTimer.schedule(deadline: .now(), repeating: .milliseconds(1000))  //此处方法与Swift 3.0 不同
        codeTimer.setEventHandler {

            time -= 1
            DispatchQueue.main.async {
                self.isEnabled = time <= 0;
                if time > 0 {
                    self.setTitle("剩余\(time)s", for: .normal)
                    return;
                }
                codeTimer.cancel()
                self.setTitle("发送验证码", for: .normal)
            }
        }
        codeTimer.resume()
    }
}
