//
//  SearchPoiView.swift
//  BMap
//
//  Created by Tsing on 2019/10/7.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import SnapKit

class SearchResultCell: UITableViewCell {
    static let cellIdf = "cellIdfSearchResultCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateCell(model: AMapPOI) {
        self.textLabel?.text = model.name
        self.detailTextLabel?.text = model.address
    }
}

protocol POIsTableViewDelegate {
    func didSelected(poi: AMapPOI)
}

protocol SpeedTableViewDelegate {
    func didSelected(history: String)
    func didSelectedHome()
    func didSelectedCompany()
}

class SpeedHistoryCell: UITableViewCell {
    static var cellIdf = "cellIdfSpeedHistoryCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpeedNaviCell: UITableViewCell {
    static var cellIdf = "cellIdfSpeedNaviCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        let homeButton = UIButton.init(type: .custom)
        homeButton.backgroundColor = .red
        homeButton.setTitle("回家", for: .normal)
        let companyButton = UIButton.init(type: .custom)
        companyButton.backgroundColor = .yellow
        companyButton.setTitle("去公司", for: .normal)
        self.contentView.addSubview(homeButton)
        self.contentView.addSubview(companyButton)
        homeButton.snp.makeConstraints { (make) in
            make.left.top.equalTo(self)
            make.height.equalTo(50)
        }
        companyButton.snp.makeConstraints { (make) in
            make.right.top.equalTo(self)
            make.left.equalTo(homeButton.snp.right)
            make.width.equalTo(homeButton)
            make.height.equalTo(50)
        }
        let lineView = UIView.init()
        self.contentView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(homeButton.snp.bottom)
            make.height.equalTo(1)
        }
        lineView.backgroundColor = UIColor.lightGray
        
//        let stackView = UIStackView.init()
//        let titles = ["餐饮"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SpeedTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
    public lazy var hisotoryArray = [String]()
    var delegate: SpeedTableViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SpeedHistoryCell.self, forCellReuseIdentifier: SpeedHistoryCell.cellIdf)
        self.tableView.register(SpeedNaviCell.self, forCellReuseIdentifier: SpeedNaviCell.cellIdf)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return self.hisotoryArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeedNaviCell.cellIdf, for: indexPath) as! SpeedNaviCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: SpeedHistoryCell.cellIdf, for: indexPath) as! SpeedHistoryCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let delegate = self.delegate else {
            return
        }
        //        delegate.didSelected(poi: self.poisArray[indexPath.row])
    }
}

class POIsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    public lazy var poisArray = [AMapPOI]()
    var delegate: POIsTableViewDelegate?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellIdf)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func clearView() {
        self.poisArray = []
        self.tableView.reloadData()
    }
    
    func appendView(pois: [AMapPOI]) {
        self.poisArray += pois
        self.tableView.reloadData()
    }
    
    func refreshView(pois: [AMapPOI]) {
        self.poisArray = pois
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.poisArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellIdf, for: indexPath) as! SearchResultCell
        cell.updateCell(model: self.poisArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let delegate = self.delegate else {
            return
        }
        delegate.didSelected(poi: self.poisArray[indexPath.row])
    }
}
