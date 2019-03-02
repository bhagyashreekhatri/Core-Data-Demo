//
//  UPUserPostViewController.swift
//  UserPost
//
//  Created by Bhagyashree Haresh Khatri on 02/03/2019.
//  Copyright © 2019 Bhagyashree Haresh Khatri. All rights reserved.
//

import UIKit
import Alamofire
import CoreData

class UPUserPostViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var userPostObj = [UserPost]()
    var id = String()
    var postListArray = [postList]()
    struct postList {
        public let userId: Int32?
        public let title: String?
        public let body: String?
        public let id: Int32?
        
        init(userId: Int32?, title: String?, body: String?, id: Int32?) {
            self.userId = userId
            self.title = title
            self.body = body
            self.id = id
        }
    }
    @IBOutlet weak var userPostTableView: UITableView!

    //MARK: UIApplication LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    //MARK: UICONFIG
    func config(){
        self.userPostTableView.delegate = self
        self.userPostTableView.dataSource = self
        self.getUserPostAPI()
    }
    
    // MARK: - Get userPost API
    func getUserPostAPI() {
        let getUsersListURLString = Constants.AUTH_API.baseURL + Constants.AUTH_API.getUsersPostURL + id
        let getUsersListURL = URL(string: getUsersListURLString)
        showHUD(progressLabel: "Loading...")
        Alamofire.request(getUsersListURL!, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            DispatchQueue.main.async {
                self.dismissHUD(isAnimated: true)
            }
            guard response.result.isSuccess else {
                self.fetch()
                return
            }
            if let result = response.result.value {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode([UserPost].self, from: response.data!)
                    for i in response.indices{
                        let list = response[i]
                        self.userPostObj.append(list)
                    }
                    self.delete()
                    self.save()
                    self.userPostTableView.reloadData()
                    
                } catch {
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
            return self.postListArray.count
        }
        else{
            return self.userPostObj.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UPUserPostTableViewCell", for: indexPath) as! UPUserPostTableViewCell
        if(UserDefaults.standard.string(forKey: "Offline") == "Yes"){
            cell.idLbl?.text = String(describing:self.postListArray[indexPath.row].id ?? 0)
            cell.titleLbl.attributedText =  self.postListArray[indexPath.row].title?.html2AttributedString
            cell.bodyLbl.attributedText =  self.postListArray[indexPath.row].body?.html2AttributedString
           
        }
        else{
            cell.idLbl?.text = String(self.userPostObj[indexPath.row].id)
            cell.titleLbl.attributedText =  self.userPostObj[indexPath.row].title?.html2AttributedString
            cell.bodyLbl.attributedText =  self.userPostObj[indexPath.row].body?.html2AttributedString
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120;
    }
    
    //MARK: Save in core data
    func save(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "PostLists", in: managedContext)!
        for i in self.userPostObj.indices{
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(self.userPostObj[i].userId, forKeyPath: "userId")
            user.setValue(self.userPostObj[i].id, forKey: "id")
            user.setValue(self.userPostObj[i].title, forKey: "title")
            user.setValue(self.userPostObj[i].body, forKey: "body")
        }
        do {
            try managedContext.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //MARK: Delete from core data
    func delete (){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "PostLists")
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
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PostLists")
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let userId = data.value(forKey: "userId") as? Int32
                let id = data.value(forKey: "id") as? Int32
                let title = data.value(forKey: "title") as? String
                let body = data.value(forKey: "body") as? String
                let postListArr = postList(userId: userId, title: title, body: body, id: id)
                postListArray.append(postListArr)
            }
            self.userPostTableView.reloadData()
        }
        catch {
            print("Failed")
        }
    }
}
