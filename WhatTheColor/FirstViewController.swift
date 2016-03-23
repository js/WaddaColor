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
    let colors: [(name: String, rgba: RGBA)] = ColorThesaurusNames().map({ (name: $0, rgba: $1) }).sort({ $0.name < $1.name })

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .None
    }
}

extension FirstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ColorTableViewCell.identifier, forIndexPath: indexPath) as! ColorTableViewCell
        let colorTuple = colors[indexPath.row]
        let color = WaddaColor(values: colorTuple.rgba)
        cell.colorView.backgroundColor = color.color
        cell.colorLabel.text = colorTuple.name

        cell.contrastingColorView.backgroundColor = color.contrastingColor().color
        cell.complementaryColorView.backgroundColor = color.complementaryColor().color


        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }

    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
}

class ColorTableViewCell: UITableViewCell {
    static let identifier = "ColorTableViewCell"

    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var complementaryColorView: UIView!
    @IBOutlet weak var contrastingColorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        [colorView, complementaryColorView, contrastingColorView].forEach { view in
            view.layer.cornerRadius = view.bounds.width / 2
        }
    }
}
