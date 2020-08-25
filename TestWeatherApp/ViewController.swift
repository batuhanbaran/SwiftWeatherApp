//
//  ViewController.swift
//  TestWeatherApp
//
//  Created by Batuhan Baran on 27.07.2020.
//  Copyright © 2020 Batuhan Baran. All rights reserved.
//

import UIKit
import Foundation



struct HavaDurumu : Codable {
    
    var derece : Double
    var aciklama : String
    
    init(json : [String : Any]) {
        
        derece = json["temperature"] as? Double ?? 0.0
        aciklama = json["query"] as? String ?? ""
        
    }
}



class ViewController: UIViewController {
    
    

    @IBOutlet weak var sonucGoster: UIButton!
    
    @IBOutlet weak var ulke: UITextField!
    
    
    @IBOutlet weak var sehir: UITextField!
    
    @IBOutlet weak var sonuc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        sonucGoster.addTarget(self, action: #selector(havaDurumuSonucu), for: .touchUpInside)
        
        sonuc.text = ""
        sonuc.textAlignment = .center
        
       
    }
    
    

    func havaDurumu(){
        
        
        let myUrl = "http://api.weatherstack.com/current?access_key=0453c163aa870c17479a5e55f40bcc5e&query=" + "\(self.sehir.text!)"
        
        if let jsonUrl = URL(string: myUrl){
            
            URLSession.shared.dataTask(with: jsonUrl) { (data, response, error) in
                
                if let data = data{
                    
                    let jsonResponse = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! Dictionary<String,Any> 
                    
                    var havaDurumu = HavaDurumu(json: jsonResponse)
                    
                    
                    
                    DispatchQueue.main.async {
                        
                            if let current = jsonResponse["current"] as? [String : Any]{
                                
                                if let temp = current["temperature"] as? Double{
                                    
                                    havaDurumu.derece = temp
                                    
                                   
                                }
                            }
                            if let current = jsonResponse["request"] as? [String : Any]{
                                
                                if let temp = current["query"] as? String{
                                    
                                    havaDurumu.aciklama = temp
                                    
                                   
                                }
                            }
                            if self.sehir.text != ""{
                                
                                self.sonuc.text = "\(havaDurumu.derece)" + "°C" + "   " + "\(havaDurumu.aciklama)"
                                
                            }

                            
                        }
                    }

                    
                }.resume()
                
            }
        }
        
        //print(myUrl)
        

    
    @objc func havaDurumuSonucu(){
        
        havaDurumu()
    
    }

}


