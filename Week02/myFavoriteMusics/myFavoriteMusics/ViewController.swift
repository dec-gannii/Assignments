//
//  ViewController.swift
//  myFavoriteMusics
//
//  Created by 김가은 on 2021/07/05.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var musicText: UITextField!
    var musics = [String]()
    // var musics:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        // 뷰 인스턴스가 메모리에 올라왓고 아직 화면은 뜨지 않은 상황
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .cyan
        refreshControl.addTarget(self, action: #selector(fetchData(_sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let userDefault = UserDefaults.standard
        if let value = userDefault.array(forKey: "memoData") as? [String]{
            self.musics = value
        }
    }
    
    @objc func fetchData (_sender: Any){
        tableView.refreshControl?.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func addMusicName(_ sender: Any) {
        guard let musicName = musicText.text, musicName != ""  else {
            return
        }
        // 변수에 저장하기
        self.musics.append(musicName)
        musicText.text = ""
        
        self.saveData()
        self.tableView.reloadData()
    }
    
    func saveData() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(musics, forKey: "memoData")
        userDefault.synchronize()
    }
}

extension ViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count // cell의 수
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "musicCell", for: indexPath) as! musicCell
        let row = indexPath.row
        cell.memoLabel.text = musics[row]
        cell.numLabel.text = "\(row + 1)"
        return cell
    }
    
    // 조건에 따라서 지우기 가능 불가능을 설정하려면 사용하는 메소드
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 빼서 집어 넣어줘야 함
        let fromRow = sourceIndexPath.row
        let toRow = destinationIndexPath.row
        let music = musics[fromRow]
        musics.remove(at: fromRow)
        musics.insert(music, at: toRow)
        
        tableView.reloadData()
    }
}

extension ViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // indent 주지 않기 (왼쪽에 바짝 붙어서 나옴)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none // 왼쪽에 delete 버튼 없이 이동 가능
    }
    
    // cell 오른쪽 끝에 나타날 부분 구현 (delete)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnEdit = UIContextualAction(style: .normal, title: "Edit") {
            (action, view, completion) in
            
            let editAlert = UIAlertController(title: "Edit Text", message: "Edit Your Text", preferredStyle: .alert)
            
            editAlert.addTextField {
                (textField) in textField.text = self.musics[indexPath.row]
            }
            editAlert.addAction(UIAlertAction(title: "Modify", style: .default, handler: {
                (action) in
                if let fields = editAlert.textFields, let textField = fields.first, let text = textField.text{
                    self.musics[indexPath.row] = text
                    // self.tableView.reloadData() // 한 줄 한 줄에 대하여 리로드
                    self.saveData()
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                
            }))
            
            editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(editAlert, animated: true, completion: nil)
            
            completion (true)
        }
        let btnDelete = UIContextualAction(style: .destructive, title: "Del") {
            (action, view, completion) in
            
            let row = indexPath.row
            self.musics.remove(at: row)
            // tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            self.saveData()
            completion(true)
        }
        btnEdit.backgroundColor = .blue
        btnDelete.backgroundColor = .black // 버튼 색상 지정
        return UISwipeActionsConfiguration(actions: [btnDelete, btnEdit])
    }
    
    // cell 오른쪽 끝에 나타날 부분 구현 (share)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnShare = UIContextualAction(style: .normal, title: "Share") {
            (action, view, completion) in completion(true)
        }
        return UISwipeActionsConfiguration(actions: [btnShare])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 12
    }
    
    @IBAction func changeEditing(_ sender: Any) {
        self.tableView.isEditing = !self.tableView.isEditing
        // 아래 코드와 동일
        //        if self.tableView.isEditing {
        //            self.tableView.isEditing = false
        //        } else {
        //            self.tableView.isEditing = true
        //        }
        //        또는
        //        self.tableView.isEditing.toggle()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        performSegue(withIdentifier: "goDetail", sender: self)
    }
}
