//
//  RewardsTableViewController.swift
//  Habit Monitor
//
//  Created by Whip Master on 3/16/18.
//  Copyright © 2018 NiLabs. All rights reserved.
//

import UIKit

//rewards
var rewards:[String]?
var rewardsDict:[String:Int]?

func saveRewardsData(rewards:[String]?) {
    UserDefaults.standard.set(rewards, forKey: "myRewards")
}

func saveRewardsDictData(rewardsDict:[String:Int]?) {
    UserDefaults.standard.set(rewardsDict, forKey:"myRewardsDict")
}

func fetchRewardsData() -> [String]? {
    if let reward = UserDefaults.standard.array(forKey: "myRewards") as? [String] {
        return reward
    } else {
        return nil
    }
}

func fetchRewardsDictData() -> [String:Int]? {
    if let dict = UserDefaults.standard.dictionary(forKey: "myRewardsDict") as? [String:Int] {
        return dict
    } else {
        return nil
    }
}

func addReward(reward: String, value: Int) {
    if reward != "" {
        rewards!.append(reward)
        UserDefaults.standard.set(rewards!, forKey: "myRewards")
        rewardsDict![reward] = value
        UserDefaults.standard.set(rewardsDict!, forKey: "myRewardsDict")
    }
}

//premium rewards
var premiumRewards:[String]?
var premiumRewardsDict:[String:Int]?

func savePremiumRewardsData(premiumRewards:[String]?) {
    UserDefaults.standard.set(premiumRewards, forKey: "myPremiumRewards")
}

func savePremiumRewardsDictData(premiumRewardsDict:[String:Int]?) {
    UserDefaults.standard.set(premiumRewardsDict, forKey:"myPremiumRewardsDict")
}

func fetchPremiumRewardsData() -> [String]? {
    if let premiumReward = UserDefaults.standard.array(forKey: "myPremiumRewards") as? [String] {
        return premiumReward
    } else {
        return nil
    }
}

func fetchPremiumRewardsDictData() -> [String:Int]? {
    if let dict = UserDefaults.standard.dictionary(forKey: "myPremiumRewardsDict") as? [String:Int] {
        return dict
    } else {
        return nil
    }
}

func addPremiumReward(premiumReward: String, value: Int) {
    if premiumReward != "" {
        premiumRewards!.append(premiumReward)
        UserDefaults.standard.set(premiumRewards!, forKey: "myPremiumRewards")
        premiumRewardsDict![premiumReward] = value
        UserDefaults.standard.set(premiumRewardsDict!, forKey: "myPremiumRewardsDict")
    }
}

//rewards cell
class RewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myRewards: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//premium rewards cell
class PremiumRewardsTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var myPremiumReward: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

//rewards controller
class RewardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var myRewards: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myRewards.delegate = self
        myRewards.dataSource = self
        
        myRewards.tableFooterView = UIView(frame: .zero)
        myRewards.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: myRewards.frame.size.width, height: 1))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func numberOfSections(in myRewards: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ myRewards: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Rewards"
        } else {
            return "Premium Rewards"
        }
    }
    
    func tableView(_ myRewards: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return rewards!.count
        } else {
            return premiumRewards!.count
        }
    }
    //sjdfjsdfjdfj
    func tableView(_ myRewards: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = myRewards.dequeueReusableCell(withIdentifier: "RewardsTableViewCell", for: indexPath) as? RewardsTableViewCell else {
                fatalError("cell isnt a reward cell")
            }
            cell.myRewards.text = rewards![indexPath.row]
            return cell
        } else if indexPath.section == 1 {
            guard let cell = myRewards.dequeueReusableCell(withIdentifier: "PremiumRewardsTableViewCell", for: indexPath) as? PremiumRewardsTableViewCell else {
                fatalError("cell isnt a premium reward cell")
            }
            cell.myPremiumReward.text = premiumRewards![indexPath.row]
            return cell
        }
        return myRewards.dequeueReusableCell(withIdentifier: "ReuseIdentifier", for: indexPath)
    }
    
    func tableView(_ myRewards: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let val = findValue(text: rewards![indexPath.row], section: 0)
            if points! < val {
                print("reward " + rewards![indexPath.row] + " could not be used, not enough points")
            } else {
                let reward = rewards![indexPath.row]
                addHistory(hist: reward)
                points! = points! - val
                UserDefaults.standard.set(points!, forKey: "myPoints")
                print("reward used: " + rewards![indexPath.row] + " with value " + String(val))
            }
            self.performSegue(withIdentifier: "RewardsToPoints", sender: self)
            //later, add performsegue if the text is a custom choice, and do stuff in another view controller
            //like the add view controller
        } else if indexPath.section == 1 {
            if (premiumRewards![indexPath.row] == "Buy reward") {
                self.performSegue(withIdentifier:"PremiumRewardsToAdd", sender: self)
            }
            let val = findValue(text: premiumRewards![indexPath.row], section: 1)
            if savings! < val {
                print("reward " + premiumRewards![indexPath.row] + " could not be used, not enough points")
            } else {
                let premiumReward = premiumRewards![indexPath.row]
                addHistory(hist: premiumReward)
                savings! = savings! - val
                UserDefaults.standard.set(savings!, forKey: "mySavings")
                print("reward used: " + premiumRewards![indexPath.row] + " with value " + String(val))
            }
            self.performSegue(withIdentifier: "PremiumRewardsToSavings", sender: self)
            //later, add performsegue if the text is a custom choice, and do stuff in another view controller
            //like the add view controller
        }
    }
    
    func findValue(text: String, section: Int) -> Int {
        if section == 0 {
            let val = rewardsDict![text]
            return val!
        } else {
            let val = premiumRewardsDict![text]
            return val!
        }
    }
    
}