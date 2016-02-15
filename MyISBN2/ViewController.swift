//
//  ViewController.swift
//  MyISBN2
//
//  Created by León Felipe Guevara Chávez on 2016-02-01.
//  Copyright © 2016 León Felipe Guevara Chávez. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var isbn: UITextField!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var autores: UILabel!
    @IBOutlet weak var portada: UIImageView!
    
    let urlBase : String = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbn.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buscarISBN() {
        let myISBN : String? = isbn.text!
        let mISBN : String = myISBN!
        let url = NSURL(string: urlBase + mISBN)
        let datos = NSData(contentsOfURL: url!)
        
        do {
            var autoresLibro : String = ""
            let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
            let dict1 = json as! NSDictionary
            let dict1Array = dict1.allKeys
            if dict1Array.count > 0 {
                let dict1 = json as! NSDictionary
                let dict2 = dict1["ISBN:" + mISBN] as! NSDictionary
                self.titulo.text = dict2["title"] as! NSString as String
                let autoresArray = dict2["authors"] as! NSArray
                for autorLibro in autoresArray {
                    let autorTemp = (autorLibro as! NSDictionary)["name"] as! String
                    autoresLibro += autorTemp
                    autoresLibro += "; "
                }
                if (autoresLibro != "") {
                    self.autores.text = "Escrito por: " + autoresLibro
                } else {
                    self.autores.text = "Sin autor registrado"
                }
                let dict3 = dict2["cover"] as! NSDictionary
                let imgURL = dict3["medium"] as!NSString as String
                let urlImage = NSURL(string: imgURL)
                let datos2 = NSData(contentsOfURL: urlImage!)
                if datos2 != nil {
                    portada.image = UIImage(data: datos2!)
                } else {
                    portada.image = nil
                }
            } else {
                let alert = UIAlertController(title: "Oops", message: "El ISBN proporcionado no existe", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(defaultAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }
        catch _ {
            let alert = UIAlertController(title: "Oops", message: "Verifica que tengas conexión", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    @IBAction func buscar(sender: AnyObject) {
        isbn.resignFirstResponder()
        buscarISBN()
    }

    // Esta función me permite ocultar el teclado una vez que toco mi pantalla fuera del campo de texto.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Esta función también me ayuda a ocultar el teclado
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        isbn.resignFirstResponder()
        buscarISBN()
        return true
    }

}

