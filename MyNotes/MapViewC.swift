//
//  MapViewC.swift
//  MyNotes
//
//  Created by Ramneet Singh on 08/04/18.
//  Copyright © 2018 Ramneet Singh. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewC: UIViewController {
    
    var mapView = GMSMapView()

    @IBOutlet weak var simpleView: UIView!

    var lattitude : Double?
    var longitude : Double?


    override func viewDidLoad() {
        super.viewDidLoad()





}
    override func loadView() {
        navigationItem.title = "Hello Map"

        let camera = GMSCameraPosition.camera(withLatitude: lattitude!,
                                              longitude: longitude!,
                                              zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)

        let marker = GMSMarker()
        marker.position = camera.target
        marker.snippet = "Hello World"
        marker.map = mapView

        view = mapView
    }
}
