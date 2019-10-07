//
//  MapTopView.swift
//  BMap
//
//  Created by Tsing on 2019/10/7.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import SnapKit

protocol SearchNavigationViewDelegate {
    func backAction()
    func beginSearch(keyword: String)
}

protocol MapNavigationViewDelegate {
    func menuAction()
    func searchAction()
}

class SearchNavigationView: UIView, UITextFieldDelegate {
    lazy var backButton = UIButton.init(type: UIButton.ButtonType.custom)
    lazy var keywordTextField = UITextField.init()
    var delegate: SearchNavigationViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.height.equalTo(self)
            make.width.equalTo(self.backButton.snp.height)
        }
        self.backButton.setImage(UIImage.init(named: "icon_back"), for: .normal)
        self.backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.backButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        self.addSubview(self.keywordTextField)
        self.keywordTextField.borderStyle = .line
        self.keywordTextField.clearButtonMode = .whileEditing
        self.keywordTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.keywordTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.keywordTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(self).offset(-20)
            make.top.equalTo(self).offset(5)
        }
        self.keywordTextField.keyboardType = .default
        self.keywordTextField.returnKeyType = .search
        self.keywordTextField.delegate = self
        self.keywordTextField.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func backButtonAction() {
        guard let delegate = self.delegate else {
            return
        }
        self.keywordTextField.text = nil
        delegate.backAction()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let keyword = textField.text  else {
            return true
        }
        
        guard keyword.count > 0 else {
            return true
        }
        
        guard let delegate = self.delegate else {
            return true
        }
        textField.resignFirstResponder()
        delegate.beginSearch(keyword: keyword)
        
        return true
    }
}

class MapNavigationView: UIView {
    lazy var searchButton = UIButton.init(type: UIButton.ButtonType.custom)
    lazy var menuButton = UIButton.init(type: UIButton.ButtonType.custom)
    
    var delegate: MapNavigationViewDelegate?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        self.addSubview(self.menuButton)
        self.menuButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(20)
            make.height.equalTo(self)
            make.width.equalTo(self.menuButton.snp.height)
        }
        self.menuButton.backgroundColor = .red
        self.menuButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        self.menuButton.setImage(UIImage.init(named: "icon_menu"), for: .normal)
        
        self.menuButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        self.menuButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        self.addSubview(self.searchButton)
        self.searchButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.searchButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.searchButton.setTitle("搜索地点", for: .normal)
        self.searchButton.setTitleColor(UIColor.black, for: .normal)
        self.searchButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self.menuButton.snp.right).offset(20)
            make.right.equalTo(self).offset(-10)
        }
        self.searchButton.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func menuButtonAction() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.menuAction()
    }
    
    @objc func searchButtonAction() {
        guard let delegate = self.delegate else {
            return
        }
        delegate.searchAction()
    }
}
