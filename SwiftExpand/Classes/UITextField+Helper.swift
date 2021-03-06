

//
//  UITextField+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2018/9/10.
//  Copyright © 2018年 BN. All rights reserved.
//

import UIKit

@objc public extension UITextField{
    /// [源]UITextField创建
    static func create(_ rect: CGRect = .zero) -> Self {
        let view = self.init(frame: rect);
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.borderStyle = .none;
        view.contentVerticalAlignment = .center;
        view.clearButtonMode = .whileEditing;
        view.autocapitalizationType = .none;
        view.autocorrectionType = .no;
        view.backgroundColor = .white;
        view.returnKeyType = .done
        view.textAlignment = .left;
        view.font = UIFont.systemFont(ofSize: 15)
        return view
    }
    
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    //设置 attributedPlaceholder
    func setPlaceHolder(_ color: UIColor? = nil, font: UIFont = UIFont.systemFont(ofSize: 15), baseline: CGFloat = 0) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        var dic = [NSAttributedString.Key.font: self.font ?? font,
                   NSAttributedString.Key.baselineOffset: baseline,
        ] as [NSAttributedString.Key : Any]
        if let color = color {
            dic[NSAttributedString.Key.foregroundColor] = color
        }
        attributedPlaceholder = NSAttributedString(string: holder, attributes: dic)
    }
        
    func addImageView(_ isRight: Bool, image: UIImage, padding: CGFloat, block:((UIView)->Void)?) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        imageView.isUserInteractionEnabled = true
        iconView.addSubview(imageView)
        
        block?(iconView)
        if isRight {
            rightView = iconView
            rightViewMode = .always

        } else {
            leftView = iconView
            leftViewMode = .always
        }
    }
    
    /// 设置 leftView 图标
    func setupLeftView(image: UIImage?, viewMode: UITextField.ViewMode = .always) {
        if image == nil {
            return
        }
        if leftView != nil {
            leftViewMode = viewMode
            return
        }
     
        leftViewMode = viewMode; //此处用来设置leftview显示时机
        leftView = {
            let view: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            
            let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: 15, height: 15));
            imgView.image = image
            imgView.contentMode = UIView.ContentMode.scaleAspectFit;
            imgView.center = view.center;
            view.addSubview(imgView);
          
            return view;
        }()
    }
    
    ///leftView/rightView
    @discardableResult
    func asoryView(_ isRight: Bool, type: UIResponder.Type, unit: String, viewSize: CGSize = CGSize(width: 25, height: 25), viewMode: UITextField.ViewMode = .always) -> UIView {
        switch type {
        case is UILabel.Type:
            return asoryView(isRight, text: unit, viewSize: viewSize, viewMode: viewMode)

        case is UIImageView.Type:
            if let image = UIImage(named: unit) {
               return asoryView(isRight, image: image, viewSize: viewSize, viewMode: viewMode)
            }
            
        default:
            break;
        }
        return asoryView(isRight, obj: unit, viewSize: viewSize, viewMode: viewMode)
    }
    ///leftView/rightView -> UILabel
    @discardableResult
    func asoryView(_ isRight: Bool, text: String, viewSize: CGSize = CGSize(width: 25, height: 25), viewMode: UITextField.ViewMode = .always) -> UILabel {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)
        
        let size = sizeWithText(text, font: 15, width: kScreenWidth);
        let frame = CGRect(x: 0, y: 0, width: size.width + 10, height: viewSize.height)
        
        if let sender = (isRight ? self.rightView : self.leftView) as? UILabel {
            sender.frame = frame
            sender.text = text;
            return sender;
        }
        
        let label: UILabel = {
            let label = UILabel(frame: .zero)
            label.tag = kTAG_LABEL;
            label.textColor = .gray;
            label.font = UIFont.systemFont(ofSize: 15);
            label.textAlignment = .center;
            label.lineBreakMode = .byCharWrapping;
            label.numberOfLines = 0;
            label.backgroundColor = .clear;
            return label
        }()
        label.frame = frame
        label.text = text
        
        isRight ? (self.rightView = label) : (self.leftView = label)
        return label
    }

    ///leftView/rightView -> UIImageView
    @discardableResult
    func asoryView(_ isRight: Bool, image: UIImage, viewSize: CGSize = CGSize(width: 25, height: 35), viewMode: UITextField.ViewMode = .always) -> UIImageView {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)
        
        let frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        if let sender = (isRight ? self.rightView : self.leftView) as? UIImageView {
            sender.frame = frame
            sender.image = image
            return sender;
        }
        
        let imageView: UIImageView = {
            let imageView = UIImageView(frame: .zero)
            imageView.contentMode = .center;
            imageView.tag = kTAG_IMGVIEW;
            return imageView
        }()
        imageView.frame = frame
        imageView.image = image

        isRight ? (self.rightView = imageView) : (self.leftView = imageView)
        return imageView
    }
    
    ///leftView/rightView -> UIButton
    @discardableResult
    func asoryView(_ isRight: Bool, obj: String, viewSize: CGSize = CGSize(width: 30, height: 35), viewMode: UITextField.ViewMode = .always) -> UIButton {
        isRight ? (self.rightViewMode = viewMode) : (self.leftViewMode = viewMode)

        let frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
                
        if let sender = (isRight ? self.rightView : self.leftView) as? UIButton {
            if let image = UIImage(named: obj) {
                sender.setImage(image, for: .normal)
                sender.frame = frame
            } else {
                sender.setTitle(obj, for: .normal)
                let size = sender.sizeThatFits(.zero)
                sender.frame = CGRect(x: 0, y: 0, width: size.width+5, height: size.height)
            }
            return sender;
        }
        
        let sender: UIButton = {
            let sender = UIButton(type: .custom)
            sender.setTitleColor(.gray, for: .normal)
            sender.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            sender.contentMode = .center;
            sender.tag = kTAG_BTN;
            return sender
        }()
        
        if let image = UIImage(named: obj) {
            sender.setImage(image, for: .normal)
            sender.frame = frame

        } else {
            sender.setTitle(obj, for: .normal)
            let size = sender.sizeThatFits(.zero)
            sender.frame = CGRect(x: 0, y: 0, width: size.width+5, height: size.height)
        }
        isRight ? (self.rightView = sender) : (self.leftView = sender)
        return sender
    }
    
    /// 返回当前文本框字符串(func textField(_ textField: shouldChangeCharactersIn:, replacementString:) -> Bool 中调用)
    func currentString(replacementString string: String) -> String {
        if self.text?.count == 1 {
            return "";
        }
        return string != "" ? self.text! + string : (self.text! as NSString).substring(to: self.text!.count - 2)
    }
    
    func addLeftView(_ block: @escaping ((UITextField)->UIView), viewMode: UITextField.ViewMode = .always) -> UIView {
        if let leftView = self.leftView{
            return leftView
        }
        let assory = block(self);
        self.leftView = assory
        self.leftViewMode = viewMode;
        return assory
    }
    
    func addRightView(_ block: @escaping ((UITextField)->UIView), viewMode: UITextField.ViewMode = .always) -> UIView {
        if let leftView = self.leftView{
            return leftView
        }
        let assory = block(self);
        self.rightView = assory
        self.rightViewMode = viewMode;
        return assory
    }

}

public extension UITextField{

    ///设置rightView 为 UIView
    final func rightView<T: UIView>(_ type: T.Type, viewMode: UITextField.ViewMode = .always, size: CGSize = CGSize(width: 30, height: 35), block:((T)->Void)? = nil) -> T {
        if let accessoryView = rightView as? T {
            return accessoryView
        }
        let view = type.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        block?(view)
        rightView = view
        rightViewMode = viewMode
        return view
    }
    
    ///设置leftView 为 UIView
    final func leftView<T: UIView>(_ type: T.Type, viewMode: UITextField.ViewMode = .always, size: CGSize = CGSize(width: 30, height: 35), block:((T)->Void)? = nil) -> T {
        if let accessoryView = leftView as? T {
            return accessoryView
        }
        let view = type.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        block?(view)
        rightView = view
        rightViewMode = viewMode
        return view
    }
}
