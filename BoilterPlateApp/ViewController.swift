//
//  ViewController.swift
//  BoilterPlateApp
//
//  Created by MithranN on 19/06/20.
//  Copyright © 2020 MithranN. All rights reserved.
//

import UIKit
import MithranSwiftKit

class ViewController: BaseViewController {
    
    var isActionTutorailShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setConstraints() {
        super.setConstraints()
        tableView.set(.fillSuperView(view))
        tableView.register(SlidingTopViewTVCell.self, forCellReuseIdentifier: SlidingTopViewTVCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
    }
    
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tvCell = tableView.dequeueReusableCell(withIdentifier: SlidingTopViewTVCell.reuseIdentifier, for: indexPath) as? SlidingTopViewTVCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 && !isActionTutorailShown {
            isActionTutorailShown = tvCell.slidingTopView.showActionTutorial()
        }
        tvCell.selectionStyle = .none
        return tvCell
    }
    
}


