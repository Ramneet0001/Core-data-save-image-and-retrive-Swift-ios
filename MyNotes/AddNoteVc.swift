//
//  AddNoteVc.swift
//  MyNotes
//
//  Created by Ramneet Singh on 08/04/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit
import GoogleMaps


class AddNoteVc: UIViewController,UITextFieldDelegate {

    let imagePicker = UIImagePickerController()
    private let locationManager = CLLocationManager()
    var imageString = ""
    var lattitude: Double?
    var longitude: Double?

    // outlets
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var textViewOutLet: UITextView!

    @IBOutlet weak var imageButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Save Data
    func saveData(){
        let note = List(context:context)
        note.name = nameTextField.text
        note.noteDoc = textViewOutLet.text
        let date = NSDate()
        note.dateTime = "\(date)"
        note.photo = imageString
        note.lattitude = lattitude!
        note.longitude = longitude!
    }


    @IBAction func cameraAction(_ sender: Any) {
        self.showPicker()
    }

    @IBAction func saveAction(_ sender: Any) {
        self.saveData()
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
        self.navigationController?.popViewController(animated: true)
       // })

    }


    // MARK: - Custom Image Pick Methods
    func showPicker(){
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: .default){ UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){ UIAlertAction in

        }
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func openGallary(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }



    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    func textFieldDidEndEditing(_ textField: UITextField) {

    }

}

//MARK:- ImagePickerController
extension AddNoteVc: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        defer {
            picker.dismiss(animated: true)
        }

        let image1 = info[UIImagePickerControllerOriginalImage] as! UIImage

        let imageData = UIImageJPEGRepresentation(image1, 0.4)!
        let imageStr = imageData.base64EncodedString()
        self.imageString = imageStr
        if imageString != ""{
            self.imageButtonOutlet.setImage(UIImage(named: "check"), for: .normal)
        }

    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
}



// MARK: - CLLocationManagerDelegate
//1
extension AddNoteVc: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()


    }

    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        locationManager.startUpdatingLocation()
        self.lattitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude

       // DataManager.currentLati = location.coordinate.latitude
       // DataManager.currentLong = location.coordinate.longitude

        let locati = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)


        fetchCountryAndCity(location: locati) { country, city, area, name, postalCode,subAdministrativeArea in
            print("country:", country)

            print("city:", city)
            print("area:", area)
            print("name:", name)

            print("postalCode:", postalCode)
            print("subLocality:", subAdministrativeArea)
        }

        // 7
        //googleMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)

        // 8
        //locationManager.stopUpdatingLocation()
    }


    func fetchCountryAndCity(location: CLLocation, completion: @escaping (String, String, String, String,String, String) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            print(placemarks as Any)
            if let error = error {
                print(error)
            } else if let country = placemarks?.first?.country,
                let city = placemarks?.first?.locality,
                let area = placemarks?.first?.isoCountryCode,
                let name = placemarks?.first?.name,
                let postalCode = placemarks?.first?.postalCode,
                let subAdministrativeArea = placemarks?.first?.subLocality{
                completion(country, city, area, name, postalCode,subAdministrativeArea)
            }
        }
    }


}




