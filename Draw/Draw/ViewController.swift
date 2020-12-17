//
//  ViewController.swift
//  Draw
//
//  Created by Samyak Pawar on 17/12/20.
//

import UIKit

var line = [CGPoint]()

class canvas : UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return  }
        
        context.setStrokeColor(UIColor.systemPink.cgColor)
        context.setLineWidth(10)
        
        for (i,p) in line.enumerated() {
            if i == 0 {
                context.move(to: p)
            } else {
                context.addLine(to: p)
                
            }
        }
        
        context.strokePath()
        
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: nil) else { return   }
        
        line.append(point)
        setNeedsDisplay()
        
    }
}


class ViewController: UIViewController {
    
    let canva = canvas()
    let bike = UIImageView()
    let playbutton = UIButton()
    let clearbutton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(canva)
        canva.frame = view.frame
        canva.backgroundColor = .white
        
        
        playbutton.setTitle("PLAY", for: .normal)
        view.addSubview(playbutton)
        
         playbutton.translatesAutoresizingMaskIntoConstraints = false
        playbutton.backgroundColor = .systemPink
        playbutton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        playbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        playbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        playbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        playbutton.layer.cornerRadius = 20
        playbutton.addTarget(self, action: #selector(playbuttonTapped), for: .touchUpInside)
        
        
        clearbutton.setTitle("CLEAR", for: .normal)
        view.addSubview(clearbutton)
        
        clearbutton.translatesAutoresizingMaskIntoConstraints = false
        clearbutton.backgroundColor = .systemPink
        clearbutton.bottomAnchor.constraint(equalTo: playbutton.topAnchor, constant: -8).isActive = true
        clearbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        clearbutton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        clearbutton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        clearbutton.layer.cornerRadius = 20
        
        clearbutton.addTarget(self, action: #selector(clearbuttonTapped), for: .touchUpInside)
        
        
        bike.translatesAutoresizingMaskIntoConstraints = false
        bike.heightAnchor.constraint(equalToConstant: 70).isActive = true
        bike.widthAnchor.constraint(equalToConstant: 70).isActive = true
        bike.image = #imageLiteral(resourceName: "bike")
        bike.contentMode = .scaleAspectFill
        
        
    }
    
    
    @objc func playbuttonTapped() {
        var angle : CGFloat = CGFloat(0)
        if line.count != 0 {
            bike.alpha = 1
        }
        
        view.addSubview(bike)
        var count = 0
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { (t) in
            
            if (count + 2) > line.count {
                t.invalidate()
                
            }else {
                let xf = line[count+1].x - 35
                let yf = line[count+1].y - 35
                
                let xi = line[count].x - 35
                let yi = line[count].y - 35
                
                
                let xd = xf - xi
                let yd = yf - yi
                let cangle = atan2(xd, yd)
                
                
                self.bike.transform = CGAffineTransform.init(rotationAngle: (.pi - cangle))
                self.bike.frame = CGRect(x: xi, y: yi, width: 70, height: 70)
                count += 1
                
                if cangle > angle && count%2 == 0 {
                    print("LEFT")
                    
                } else if cangle < angle && count%2 == 0{
                    print("RIGHT")
                    
                }
                angle = cangle
            }
        }

    }
    
    
    @objc func clearbuttonTapped() {
        bike.alpha = 0
        line.removeAll()
        canva.setNeedsDisplay()
    }
        


}

