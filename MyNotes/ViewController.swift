//
//  ViewController.swift
//  MyNotes
//
//  Created by Ramneet Singh on 08/04/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    var data = [List]()
    var data2 = [Detail]()
    
    var filteredData = [List]()
    
    var lastContentOffset: CGFloat = 0
    var scrollUpDefault : Bool = true
    var scrollDownDefault : Bool = true


    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var tableVIew: UITableView!

    @IBOutlet weak var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchList()

//        let btn = UIButton()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.fetchList()
    }

    func fetchList(){
        do {
            data = try context.fetch(List.fetchRequest())
            data2 = try context.fetch(Detail.fetchRequest())
            print(data)
            self.filteredData = data
            tableVIew.reloadData()
            
        }catch{
            //
        }


    }


    @IBAction func deleteAction(_ sender: Any) {
            self.fetchList()
    }

    @IBAction func addNoteAction(_ sender: Any) {

        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboar.instantiateViewController(withIdentifier: "AddNoteVc") as! AddNoteVc
        

        self.navigationController?.pushViewController(secondViewController, animated: false)

    }






    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true;
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text != ""{
        print(textField.text!)
            let filter = data.filter{($0.name?.lowercased().contains( textField.text!.lowercased()))!}
            print(filter)
            
        filteredData = filter
        tableVIew.reloadData()
        }else{
        filteredData = data
        }
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true;
    }


    @objc func pressButton(_ button: UIButton) {
        print("Button with tag: \(button.tag) clicked!")
        let deleteValue = filteredData[button.tag]
        context.delete(deleteValue)
        self.fetchList()
    }

}


//struct AssociatedKeys {
//    static var toggleState: UInt8 = 0
//}
//
//protocol ToggleProtocol {
//    func toggle()
//}
//
//enum ToggleState {
//    case on
//    case off
//}
//
//extension UIButton: ToggleProtocol {
//
//    private(set) var toggleState: ToggleState {
//        get {
//            guard let value = objc_getAssociatedObject(self, &AssociatedKeys.toggleState) as? ToggleState else {
//                return .off
//            }
//            return value
//        }
//        set(newValue) {
//            objc_setAssociatedObject(self, &AssociatedKeys.toggleState, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//
//    func toggle() {
//        toggleState = toggleState == .on ? .off : .on
//
//        if toggleState == .on {
//            // Shows background for status on
//        } else {
//            // Shows background for status off
//        }
//    }
//}




extension ViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboar.instantiateViewController(withIdentifier: "DetailNoteVc") as! DetailNoteVc
        secondViewController.selectedName = [filteredData[indexPath.row]]
        self.navigationController?.pushViewController(secondViewController, animated: false)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {


        return 80
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return filteredData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesListCell", for: indexPath) as? NotesListCell
        cell?.nameLbl.text = filteredData[indexPath.row].name
        cell?.dateLbl.text = filteredData[indexPath.row].dateTime
        cell?.deleteButton.tag = indexPath.row
        cell?.deleteButton.addTarget(self, action: #selector(pressButton(_:)), for: .touchUpInside)

        cell?.selectionStyle = .none

        return cell!
    }



    // this delegate is called when the scrollView (i.e your UITableView) will start scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffset = scrollView.contentOffset.y
    }

    // while scrolling this delegate is being called so you may now check which direction your scrollView is being scrolled to
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (self.lastContentOffset < scrollView.contentOffset.y) {
            self.upDownScrollTest(scrollUp: true, scrollDown: false)
        } else if (self.lastContentOffset > scrollView.contentOffset.y) {
            self.upDownScrollTest(scrollUp: false, scrollDown: true)
        } else {
            // didn't move
        }
    }

    func upDownScrollTest(scrollUp:Bool, scrollDown:Bool){

        if scrollUp == true && scrollUpDefault == true{
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.transform = CGAffineTransform(translationX: 0, y: +100)

            }, completion: nil)
            scrollUpDefault = false
            scrollDownDefault = true
        }

        if scrollDown == true && scrollDownDefault == true{
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomView.transform = CGAffineTransform.identity
            }, completion: nil)
            scrollDownDefault = false
            scrollUpDefault = true

        }


    }

}


