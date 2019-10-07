//
//  LeftViewController.swift
//  BMap
//
//  Created by Tsing on 2019/10/6.
//  Copyright © 2019年 Tsing. All rights reserved.
//

import UIKit

class LeftViewCell : UITableViewCell {
    static public let cellIdf = "cellIdfLeftViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateRow(title: String) {
        
    }
}

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LeftViewCell.cellIdf, for: indexPath)
        let rowText = ["切换地图", "关于"]
        cell.textLabel?.text = rowText[indexPath.row]
        return cell
    }
    
    
    lazy var tableView = UITableView.init(frame: CGRect.zero, style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.rowHeight = 50
        
        self.tableView.register(LeftViewCell.self, forCellReuseIdentifier: LeftViewCell.cellIdf)
        
    }
}
