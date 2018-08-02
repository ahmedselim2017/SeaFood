//
//  ViewController.swift
//  SeaFood
//
//  Created by Ahmed Selim Üzüm on 2.08.2018.
//  Copyright © 2018 Ahmed Selim Üzüm. All rights reserved.
//

import UIKit;
import CoreML;
import Vision;

class ViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var lblSonuc: UILabel!
    @IBOutlet weak var imgResim: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func btnGaleriBasildi(_ sender: Any) {
        let resim = UIImagePickerController();
        resim.delegate = self;
        resim.sourceType = .photoLibrary;
        resim.allowsEditing = false;
        self.present(resim,animated: true);
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let resim = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else{return;}
        imgResim.image=resim;
    
        guard let ciResim=CIImage(image: resim) else {fatalError("resim CIIMAGE'e çevrilemedi");}
        
        algila(resim: ciResim);
        
        self.dismiss(animated: true, completion: nil);
    
    }
    
    func algila(resim:CIImage){
        guard let model=try? VNCoreMLModel(for: Inceptionv3().model) else {fatalError("Model Yüklenemedi");}
        
        let istek=VNCoreMLRequest(model: model) { (sonuc, hata) in
            guard let sonuclar=sonuc.results as? [VNClassificationObservation] else{fatalError("sonuclar yuklenemedi");}
            
            print(sonuclar);
        }
        let tutucu=VNImageRequestHandler(ciImage: resim);
        
        do{
            try tutucu.perform([istek]);
        }
        catch{
            debugPrint("HATA 54 \(error.localizedDescription)");
        }
        
    }
    
}

