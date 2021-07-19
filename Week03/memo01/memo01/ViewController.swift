//
//  ViewController.swift
//  Memo
//
//  Created by 김가은 on 2021/06/29.
//

import UIKit
import FirebaseDatabase

class ViewController: UIViewController {
    
    var ref: DatabaseReference!
    var refHandle: DatabaseHandle!
    
    
    var memoNumbers = 0
    var numbers = 0
    var memoContent = String()
    var memoContentArray = Array<String>()
    var allMemoArray = Array<Array<String>>()
    
    @IBOutlet weak var memoField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func doSave(_ sender: Any) {
        ref = Database.database().reference()
        memoContent = memoField.text!
        ref.child("users/memo/memoContents").setValue(memoContent){
            (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
            } else {
                let alertVC = UIAlertController(title: "Complete", message: "Data Saving Complete", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                print("Data saved successfully!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 나타나기 직전에 관찰자 설정
        print("관찰자 등록")
        ref = Database.database().reference()
        refHandle = ref.observe(DataEventType.value, with: { snapshot in
            let postDict = snapshot.value as? String ?? ""
            print(postDict)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("관찰자 삭제")
        ref = Database.database().reference()
        // 화면이 사라지고 나면 관찰자 삭제
        // 업데이트 항목을 계속 끊김 없이 감시하고 싶을 때 사용
        ref.removeObserver(withHandle: refHandle)
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NSLog("1: \(numbers)")
        return numbers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath) as! MemoCell
        let memos = self.allMemoArray[indexPath.row]
        cell.memoView.text = memos[0]
        
        return cell
    }
}

