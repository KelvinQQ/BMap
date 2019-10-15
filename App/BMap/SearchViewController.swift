//
//  SearchViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/6.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, MAMapViewDelegate, AMapSearchDelegate {

    lazy var searchAPI = AMapSearchAPI.init()
    lazy var keywordTextField = UITextField.init()
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
    lazy var resultArray = [AMapPOI]()
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.view.backgroundColor = .white

        let navigationView = UIView.init()
        self.view.addSubview(navigationView)
        navigationView.backgroundColor = .green
        navigationView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.height.equalTo(70)
        }

        let containerView = UIView.init()
        containerView.backgroundColor = .yellow
        navigationView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(navigationView)
            make.height.equalTo(50)
        }

        let backButton = UIButton.init(type: .custom)
        backButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        backButton.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        containerView.addSubview(backButton)
        backButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.left.equalTo(containerView).offset(20)
        }
        backButton.setTitle("Back", for: .normal)
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        backButton.backgroundColor = .red

        containerView.addSubview(self.keywordTextField)
        self.keywordTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        self.keywordTextField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        self.keywordTextField.snp.makeConstraints { (make) in
            make.centerY.equalTo(containerView)
            make.left.equalTo(backButton.snp.right).offset(10)
            make.right.equalTo(containerView).offset(-20)
        }
        self.keywordTextField.keyboardType = .default
        self.keywordTextField.returnKeyType = .search
        self.keywordTextField.delegate = self
        self.keywordTextField.backgroundColor = .white
        self.keywordTextField.text = "安徽大学"

        self.searchAPI?.delegate = self

        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(navigationView.snp.bottom)
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.cellIdf)
    }

    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }

    //MARK: - AMapSearchDelegate
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {

    }

    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {

        if response.count == 0 {
            return
        }

        let poiMapVc = POIMapViewController.init(pois: response.pois)
        self.navigationController?.pushViewController(poiMapVc, animated: true)
//        if self.currentPage == 0 {
//            self.resultArray = response.pois
//        }
//        else {
//            self.resultArray += response.pois
//        }
//
//        self.tableView.reloadData()
    }
}

//class SearchResultCell: UITableViewCell {
//    static let cellIdf = "cellIdfSearchResultCell"
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    public func updateCell(model: AMapPOI) {
//        self.textLabel?.text = model.name
//        self.detailTextLabel?.text = model.address
//    }
//}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        guard let keyword = textField.text  else {
            return true
        }

        guard keyword.count > 0 else {
            return true
        }

        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true

        self.searchAPI?.aMapPOIKeywordsSearch(request)
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.cellIdf, for: indexPath) as! SearchResultCell
        cell.updateCell(model: self.resultArray[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
}
