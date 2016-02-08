//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Kyle Wilson on 2/3/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController (filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchTableViewCellDelegate {
    
    @IBOutlet var switchCellTableView: UITableView!
    var delegate: FiltersViewControllerDelegate?
    
    var categories: [[String:String]]!
    var switchStates = [Int:Bool]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchCellTableView.dataSource = self
        switchCellTableView.delegate = self
        
        categories = yelpCategories()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String:AnyObject]()
        var selectedCategories = [String]()
        
        for (row, isOn) in switchStates {
            if isOn {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchTableViewCell") as! SwitchTableViewCell
        cell.categoryLabel.text = categories[indexPath.row]["name"]
        cell.delegate = self
        cell.categorySwitch.on = switchStates[indexPath.row] ?? false
        return cell
    }
    
    func switchCell(switchCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = switchCellTableView.indexPathForCell(switchCell)
        switchStates[indexPath!.row] = value
    }
    
    func yelpCategories() -> [[String:String]] {
        return [["code": "afghani", "name": "Afghan"],
            ["code": "african", "name": "African"],
            ["code": "andalusian", "name": "Andalusian"],
            ["code": "arabian", "name": "Arabian"],
            ["code": "argentine", "name": "Argentine"],
            ["code": "armenian", "name": "Armenian"],
            ["code": "asianfusion", "name": "Asian Fusion"],
            ["code": "asturian", "name": "Asturian"],
            ["code": "australian", "name": "Australian"],
            ["code": "austrian", "name": "Austrian"],
            ["code": "baguettes", "name": "Baguettes"],
            ["code": "bangladeshi", "name": "Bangladeshi"],
            ["code": "basque", "name": "Basque"],
            ["code": "bavarian", "name": "Bavarian"],
            ["code": "bbq", "name": "Barbeque"],
            ["code": "beergarden", "name": "Beer Garden"],
            ["code": "beerhall", "name": "Beer Hall"],
            ["code": "beisl", "name": "Beisl"],
            ["code": "belgian", "name": "Belgian"],
            ["code": "blacksea", "name": "Black Sea"],
            ["code": "brasseries", "name": "Brasseries"],
            ["code": "brazilian", "name": "Brazilian"],
            ["code": "breakfast_brunch", "name": "Breakfast & Brunch"],
            ["code": "british", "name": "British"],
            ["code": "buffets", "name": "Buffets"],
            ["code": "burgers", "name": "Burgers"],
            ["code": "burmese", "name": "Burmese"],
            ["code": "cafes", "name": "Cafes"],
            ["code": "cafeteria", "name": "Cafeteria"],
            ["code": "cajun", "name": "Cajun/Creole"],
            ["code": "cambodian", "name": "Cambodian"],
            ["code": "canteen", "name": "Canteen"],
            ["code": "caribbean", "name": "Caribbean"],
            ["code": "catalan", "name": "Catalan"],
            ["code": "cheesesteaks", "name": "Cheesesteaks"],
            ["code": "chicken_wings", "name": "Chicken Wings"],
            ["code": "chickenshop", "name": "Chicken Shop"],
            ["code": "chilean", "name": "Chilean"],
            ["code": "chinese", "name": "Chinese"],
            ["code": "comfortfood", "name": "Comfort Food"],
            ["code": "corsican", "name": "Corsican"],
            ["code": "creperies", "name": "Creperies"],
            ["code": "cuban", "name": "Cuban"],
            ["code": "currysausage", "name": "Curry Sausage"],
            ["code": "cypriot", "name": "Cypriot"],
            ["code": "czech", "name": "Czech"],
            ["code": "czechslovakian", "name": "Czech/Slovakian"],
            ["code": "danish", "name": "Danish"],
            ["code": "delis", "name": "Delis"],
            ["code": "diners", "name": "Diners"],
            ["code": "dumplings", "name": "Dumplings"],
            ["code": "eastern_european", "name": "Eastern European"],
            ["code": "eltern_cafes", "name": "Parent Cafes"],
            ["code": "ethiopian", "name": "Ethiopian"],
            ["code": "filipino", "name": "Filipino"],
            ["code": "fischbroetchen", "name": "Fischbroetchen"],
            ["code": "fishnchips", "name": "Fish & Chips"],
            ["code": "flatbread", "name": "Flatbread"],
            ["code": "fondue", "name": "Fondue"],
            ["code": "food_court", "name": "Food Court"],
            ["code": "foodstands", "name": "Food Stands"],
            ["code": "french", "name": "French"],
            ["code": "galician", "name": "Galician"],
            ["code": "gastropubs", "name": "Gastropubs"],
            ["code": "georgian", "name": "Georgian"],
            ["code": "german", "name": "German"],
            ["code": "giblets", "name": "Giblets"],
            ["code": "gluten_free", "name": "Gluten-Free"],
            ["code": "greek", "name": "Greek"],
            ["code": "halal", "name": "Halal"],
            ["code": "hawaiian", "name": "Hawaiian"],
            ["code": "heuriger", "name": "Heuriger"],
            ["code": "himalayan", "name": "Himalayan/Nepalese"],
            ["code": "hkcafe", "name": "Hong Kong Style Cafe"],
            ["code": "hotdog", "name": "Hot Dogs"],
            ["code": "hotdogs", "name": "Fast Food"],
            ["code": "hotpot", "name": "Hot Pot"],
            ["code": "hungarian", "name": "Hungarian"],
            ["code": "iberian", "name": "Iberian"],
            ["code": "indonesian", "name": "Indonesian"],
            ["code": "indpak", "name": "Indian"],
            ["code": "international", "name": "International"],
            ["code": "irish", "name": "Irish"],
            ["code": "island_pub", "name": "Island Pub"],
            ["code": "israeli", "name": "Israeli"],
            ["code": "italian", "name": "Italian"],
            ["code": "japanese", "name": "Japanese"],
            ["code": "jewish", "name": "Jewish"],
            ["code": "kopitiam", "name": "Kopitiam"],
            ["code": "korean", "name": "Korean"],
            ["code": "kosher", "name": "Kosher"],
            ["code": "kurdish", "name": "Kurdish"],
            ["code": "laos", "name": "Laos"],
            ["code": "laotian", "name": "Laotian"],
            ["code": "latin", "name": "Latin American"],
            ["code": "lyonnais", "name": "Lyonnais"],
            ["code": "malaysian", "name": "Malaysian"],
            ["code": "meatballs", "name": "Meatballs"],
            ["code": "mediterranean", "name": "Mediterranean"],
            ["code": "mexican", "name": "Mexican"],
            ["code": "mideastern", "name": "Middle Eastern"],
            ["code": "milkbars", "name": "Milk Bars"],
            ["code": "modern_australian", "name": "Modern Australian"],
            ["code": "modern_european", "name": "Modern European"],
            ["code": "mongolian", "name": "Mongolian"],
            ["code": "moroccan", "name": "Moroccan"],
            ["code": "newamerican", "name": "American (New)"],
            ["code": "newcanadian", "name": "Canadian (New)"],
            ["code": "newzealand", "name": "New Zealand"],
            ["code": "nightfood", "name": "Night Food"],
            ["code": "norcinerie", "name": "Norcinerie"],
            ["code": "norwegian", "name": "Traditional Norwegian"],
            ["code": "opensandwiches", "name": "Open Sandwiches"],
            ["code": "oriental", "name": "Oriental"],
            ["code": "pakistani", "name": "Pakistani"],
            ["code": "parma", "name": "Parma"],
            ["code": "persian", "name": "Persian/Iranian"],
            ["code": "peruvian", "name": "Peruvian"],
            ["code": "pfcomercial", "name": "PF/Comercial"],
            ["code": "pita", "name": "Pita"],
            ["code": "pizza", "name": "Pizza"],
            ["code": "polish", "name": "Polish"],
            ["code": "portuguese", "name": "Portuguese"],
            ["code": "potatoes", "name": "Potatoes"],
            ["code": "poutineries", "name": "Poutineries"],
            ["code": "pubfood", "name": "Pub Food"],
            ["code": "raw_food", "name": "Live/Raw Food"],
            ["code": "riceshop", "name": "Rice"],
            ["code": "romanian", "name": "Romanian"],
            ["code": "rotisserie_chicken", "name": "Rotisserie Chicken"],
            ["code": "rumanian", "name": "Rumanian"],
            ["code": "russian", "name": "Russian"],
            ["code": "salad", "name": "Salad"],
            ["code": "sandwiches", "name": "Sandwiches"],
            ["code": "scandinavian", "name": "Scandinavian"],
            ["code": "scottish", "name": "Scottish"],
            ["code": "seafood", "name": "Seafood"],
            ["code": "serbocroatian", "name": "Serbo Croatian"],
            ["code": "signature_cuisine", "name": "Signature Cuisine"],
            ["code": "singaporean", "name": "Singaporean"],
            ["code": "slovakian", "name": "Slovakian"],
            ["code": "soulfood", "name": "Soul Food"],
            ["code": "soup", "name": "Soup"],
            ["code": "southern", "name": "Southern"],
            ["code": "spanish", "name": "Spanish"],
            ["code": "srilankan", "name": "Sri Lankan"],
            ["code": "steak", "name": "Steakhouses"],
            ["code": "sud_ouest", "name": "French Southwest"],
            ["code": "supperclubs", "name": "Supper Clubs"],
            ["code": "sushi", "name": "Sushi Bars"],
            ["code": "swabian", "name": "Swabian"],
            ["code": "swedish", "name": "Swedish"],
            ["code": "swissfood", "name": "Swiss Food"],
            ["code": "syrian", "name": "Syrian"],
            ["code": "tabernas", "name": "Tabernas"],
            ["code": "taiwanese", "name": "Taiwanese"],
            ["code": "tapas", "name": "Tapas Bars"],
            ["code": "tapasmallplates", "name": "Tapas/Small Plates"],
            ["code": "tex-mex", "name": "Tex-Mex"],
            ["code": "thai", "name": "Thai"],
            ["code": "tradamerican", "name": "American (Traditional)"],
            ["code": "traditional_swedish", "name": "Traditional Swedish"],
            ["code": "trattorie", "name": "Trattorie"],
            ["code": "turkish", "name": "Turkish"],
            ["code": "ukrainian", "name": "Ukrainian"],
            ["code": "uzbek", "name": "Uzbek"],
            ["code": "vegan", "name": "Vegan"],
            ["code": "vegetarian", "name": "Vegetarian"],
            ["code": "venison", "name": "Venison"],
            ["code": "vietnamese", "name": "Vietnamese"],
            ["code": "wraps", "name": "Wraps"],
            ["code": "yugoslav", "name": "Yugoslav"]];
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
