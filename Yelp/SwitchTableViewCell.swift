//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Kyle Wilson on 2/3/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

@objc protocol SwitchTableViewCellDelegate {
    optional func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool)
}

import UIKit

class SwitchTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var categorySwitch: UISwitch!
    
    weak var delegate: SwitchTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func onSwitchValueChanged(sender: AnyObject) {
        delegate?.switchCell?(self, didChangeValue: categorySwitch.on)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
