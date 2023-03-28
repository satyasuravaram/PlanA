//
//  AnimationViewController.swift
//  PlanA
//
//  Created by Aiden Petratos on 3/27/23.
//

import UIKit

class AnimationViewController: UIViewController {

    @IBOutlet var backgroundImage: UIImageView!
    
    let pinOne = UIImageView(image: UIImage(named: "pin"))
    let pinTwo = UIImageView(image: UIImage(named: "pin"))
    let pinThree = UIImageView(image: UIImage(named: "pin"))
    let pinFour = UIImageView(image: UIImage(named: "pin"))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        backgroundImage.image = UIImage(named: "launch_screen")
        backgroundImage.contentMode = .scaleAspectFill
        
        let width = view.frame.width
        let height = view.frame.height
        pinOne.frame = CGRect(x:width/3.93, y:height/8.69, width:50, height:58.5)
        pinTwo.frame = CGRect(x:width/1.23, y:height/4.61 , width:50, height:58.5)
        pinThree.frame = CGRect(x:width/1.56, y:height/1.41, width:50, height:58.5)
        pinFour.frame = CGRect(x:width/7.15, y:height/1.21, width:50, height:58.5)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    func animate() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            self.view.addSubview(self.pinOne)
        })
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinOne.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinOne.transform = CGAffineTransformMakeScale(1, 1)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.view.addSubview(self.pinTwo)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinTwo.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+0.75, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinTwo.transform = CGAffineTransformMakeScale(1, 1)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            self.view.addSubview(self.pinThree)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinThree.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1.25, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinThree.transform = CGAffineTransformMakeScale(1, 1)
            })
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
            self.view.addSubview(self.pinFour)
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinFour.transform = CGAffineTransformMakeScale(1.5, 1.5)
            })
        })
        DispatchQueue.main.asyncAfter(deadline: .now()+1.75, execute: {
            UIView.animate(withDuration: 0.5, delay: 0, animations: {
                self.pinFour.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: { done in
                if done {
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let navc = storyboard.instantiateViewController(withIdentifier: "nav_c") as! UINavigationController
                    navc.modalTransitionStyle = .crossDissolve
                    navc.modalPresentationStyle = .fullScreen
                    self.present(navc, animated: true)

                }
            })
        })

    }
}
