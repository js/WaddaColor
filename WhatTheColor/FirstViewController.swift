//
//  FirstViewController.swift
//  WhatTheColor
//
//  Created by Johan Sørensen on 24/02/16.
//  Copyright © 2016 Johan Sørensen. All rights reserved.
//

import UIKit
import WaddaColor

class FirstViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let colors: [(name: String, rgba: RGBA)] = ColorThesaurusNames().map({ (name: $0, rgba: $1) })

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
    }
}

extension FirstViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ColorCell", forIndexPath: indexPath)
        let color = colors[indexPath.row]
        cell.textLabel?.text = color.name
        let hsl = HSL(rgb: color.rgba)
        if hsl.isLight() {
            cell.textLabel?.textColor = UIColor.blackColor()
        } else {
            cell.textLabel?.textColor = UIColor.whiteColor()
        }
        cell.textLabel?.backgroundColor = color.rgba.color
        cell.contentView.backgroundColor = color.rgba.color
        return cell
    }
}

