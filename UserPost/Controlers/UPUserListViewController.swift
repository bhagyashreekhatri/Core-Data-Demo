//
//  UPUserListViewController.swift
//  UserPost
//
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import Alamofire
import CoreData
import MBProgressHUD

class UPUserListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userListObj = [UserList]()
    var lists = [list]()
    struct list {
        public let username: String?
        public let name: String?
        public let city: String?
        public let email: String?
        public let company: String?
        public let zipcode: String?
        public let id: Int32?
        
        init(username: String?, name: String?, city: String?, email: String?, company: String?, zipcode: String?, id: Int32?) {
            self.username = username
            self.name = name
            self.city = city
            self.email = email
            self.company = company
            self.zipcode = zipcode
            self.id = id
            
        }
       
    }
    @IBOutlet weak var userListTableView: UITableView!
    
    //MARK: UIApplication LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = UserDefaults.standard.value(forKey: "email") as? String
    }
    //MARK: UICONFIG
    
    func config(){
        self.userListTableView.delegate = self
        self.userListTableView.dataSource = self
        getUserListAPI()
    }
    
    // MARK: - Get user storeCardList API Call Methods
    
    func getUserListAPI() {
        let getUsersListURLString = Constants.AUTH_API.baseURL + Constants.AUTH_API.getUsersListURL
        print(getUsersListURLString)
        let getUsersListURL = URL(string: getUsersListURLString)
        self.showHUD(progressLabel: "Loading...")
        Alamofire.request(getUsersListURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            DispatchQueue.main.async {
                self.dismissHUD(isAnimated: true)
            }
            guard response.result.isSuccess else {
                UserDefaults.standard.set("Yes", forKey: "Offline")
                self.fetch()
                return
            }
            if let result = response.result.value {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([UserList].self, from: response.data!)
                    print(response[0])
                    for i in response.indices{
                        let list = response[i]
                        self.userListObj.append(list)
                    }
                    self.delete ()
                    self.save()
                    UserDefaults.standard.set("No", forKey: "Offline")
                    self.userListTableView.reloadData()
                    
                } catch {
                    print("error:\(error)")
                    let alert = UIAlertController(title: nil, message: "\(error)", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
}
    
    //MARK: UITableView Delegates
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(UserDefaults.standard.string(forKey: "Offline") == "Yes"){
             return self.lists.count
        }
        else{
            return self.userListObj.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UPUserListTableViewCell", for: indexPath) as! UPUserListTableViewCell
        if(UserDefaults.standard.string(forKey: "Offline") == "Yes"){
            cell.nameLbl?.text = self.lists[indexPath.row].name
            cell.userNameLbl?.text = self.lists[indexPath.row].username
            cell.emailLbl?.text = self.lists[indexPath.row].email
            cell.cityLbl?.text = (self.lists[indexPath.row].city)! + " " + (self.lists[indexPath.row].zipcode)!
            cell.companyNameLbl?.text = self.lists[indexPath.row].company
        }
        else{
            cell.nameLbl?.text = self.userListObj[indexPath.row].name
            cell.userNameLbl?.text = self.userListObj[indexPath.row].username
            cell.emailLbl?.text = self.userListObj[indexPath.row].email
            cell.cityLbl?.text = (self.userListObj[indexPath.row].address?.city)! + " " + (self.userListObj[indexPath.row].address?.zipcode)!
            cell.companyNameLbl?.text = self.userListObj[indexPath.row].company?.name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
            {
                return 130;
            }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let controller: UPUserPostViewController = storyboard.instantiateViewController(withIdentifier: "UPUserPostViewController") as! UPUserPostViewController
        if(UserDefaults.standard.string(forKey: "Offline") == "Yes"){
             controller.id = String(self.lists[indexPath.row].id!)
            UserDefaults.standard.set(self.lists[indexPath.row].email, forKey: "email")
        }
        else{
            controller.id = String(self.userListObj[indexPath.row].id!)
            UserDefaults.standard.set(self.userListObj[indexPath.row].email, forKey: "email")
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Save in core data
    
    func save(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "UserLists", in: managedContext)!
        for i in self.userListObj.indices{
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(self.userListObj[i].username, forKeyPath: "username")
            user.setValue(self.userListObj[i].email, forKey: "email")
            user.setValue(self.userListObj[i].name, forKey: "name")
            user.setValue(self.userListObj[i].address?.city, forKey: "city")
            user.setValue(self.userListObj[i].company?.name, forKey: "company")
            user.setValue(self.userListObj[i].address?.zipcode, forKey: "zipcode")
            user.setValue(self.userListObj[i].id, forKey: "id")
        }
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
   
    //MARK: Delete from core data
    
    func delete (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLists")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    //MARK: Fetch from core data
    
    func fetch (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLists")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let username = data.value(forKey: "username") as? String
                let name = data.value(forKey: "name") as? String
                let city = data.value(forKey: "city") as? String
                let zipcode = data.value(forKey: "zipcode") as? String
                let company = data.value(forKey: "company") as? String
                let email = data.value(forKey: "email") as? String
                let id = data.value(forKey: "id") as? Int32
                let country = list(username: username, name: name,city: city, email: email, company: company, zipcode: zipcode,id: id)
                lists.append(country)
            }
            self.userListTableView.reloadData()
        } catch {
            print("Failed")
        }
    }
}

extension UIViewController {
    
    func showHUD(progressLabel:String){
        let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
        progressHUD.label.text = progressLabel
    }
    
    func dismissHUD(isAnimated:Bool) {
        MBProgressHUD.hide(for: self.view, animated: isAnimated)
    }
}
