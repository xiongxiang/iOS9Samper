//
//  RootViewController.swift
//  iOS-9-Sampler
//
//  Created by xiongxiang on 16/1/11.
//  Copyright © 2016年 bearsoft. All rights reserved.
//

import UIKit

private let kItemKeyTitle       = "title"
private let kItemKeyDetail      = "detail"
private let kItemKeyClassPrefix = "prefix"

class RootViewController: UITableViewController {

    private var items: [Dictionary<String, String>]!


    override func viewDidLoad() {
        super.viewDidLoad()

        items = [
            [
                kItemKeyTitle: "Map Customizations",
                kItemKeyDetail: "Flyover can be selected with new map types, and Traffic, Scale and Compass can be shown.",
                kItemKeyClassPrefix: "MapCustomizations"
            ],
            [
                kItemKeyTitle: "HomePwner",
                kItemKeyDetail: "A list of the home owend items \"Properties\".",
                kItemKeyClassPrefix: "Homepwner"
            ],
            [
                kItemKeyTitle: "Coolection Usage",
                kItemKeyDetail: "Big Nerd CollectionViewController usage.",
                kItemKeyClassPrefix: "Photos"
            ]
        ]
    }

    override func viewDidAppear(animated: Bool) {
        // Needed after custome transition
        navigationController?.delegate = nil;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: -UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RootViewCell

        let item = items[indexPath.row]
        cell.titleLabel.text = item[kItemKeyTitle]
        cell.detailLabel.text = item[kItemKeyDetail]

        return cell
    }

    // MARK: -UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let item = items[indexPath.row]
        let prefix = item[kItemKeyClassPrefix]

        let storyboard = UIStoryboard(name: prefix!, bundle: nil)
        let controller = storyboard.instantiateInitialViewController()
        self.navigationController?.pushViewController(controller!, animated: true)

        controller!.title = item[kItemKeyTitle]

        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
