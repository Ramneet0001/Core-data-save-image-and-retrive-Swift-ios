//
//  DetailNoteVc.swift
//  MyNotes
//
//  Created by Ramneet Singh on 08/04/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit

class DetailNoteVc: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var data = [List]()
    var selectedName = [List]()
    var image = ""
    var name = ""
    var latitude : Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedName)

        self.navigationItem.title = selectedName[0].name
        self.textView.text = selectedName[0].noteDoc

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func locationAction(_ sender: Any) {

        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboar.instantiateViewController(withIdentifier: "MapViewC") as! MapViewC

        secondViewController.lattitude = selectedName[0].lattitude
        secondViewController.longitude = selectedName[0].longitude

        self.navigationController?.pushViewController(secondViewController, animated: false)
    }

    @IBAction func editAction(_ sender: Any) {

        do {
            data = try context.fetch(List.fetchRequest())
        }catch{
            //
        }

        for each in data{
            if "\(String(describing: each.name))" == "\(String(describing: selectedName[0].name))" {
                self.image = selectedName[0].photo!
                self.latitude = selectedName[0].lattitude
                self.longitude = selectedName[0].longitude
                context.delete(each)

                let note = List(context:context)
                note.name = selectedName[0].name
                note.noteDoc = textView.text
                let date = NSDate()
                note.dateTime = "\(date)"
                note.photo = image
                note.lattitude = latitude!
                note.longitude = longitude!
            }
            }
            self.navigationController?.popViewController(animated: true)
        }



    @IBAction func imageAction(_ sender: Any) {
        if selectedName[0].photo != ""{

        let storyboar = UIStoryboard(name: "Main", bundle: nil)
        let secondViewController = storyboar.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController

        secondViewController.noteImage = selectedName[0].photo!

        self.navigationController?.pushViewController(secondViewController, animated: false)

        }
    }



}
