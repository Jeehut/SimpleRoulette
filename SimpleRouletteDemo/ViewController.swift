//
//  ViewController.swift
//  SimpleRouletteDemo
//
//  Created by Fumiya Tanaka on 2020/05/29.
//  Copyright © 2020 Fumiya Tanaka. All rights reserved.
//

import UIKit
import SimpleRoulette

class ViewController: UIViewController {
    
    let rouletteView: RouletteView = RouletteView(frame: .zero)
    let startButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rouletteView)
        
        rouletteView.translatesAutoresizingMaskIntoConstraints = false
        rouletteView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        rouletteView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        rouletteView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        rouletteView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        
        view.addSubview(startButton)
        startButton.layer.cornerRadius = 16
        startButton.layer.borderColor = UIColor.systemGray3.cgColor
        startButton.layer.borderWidth = 2
        startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 96).isActive = true
        startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rouletteView.update(parts: [
            RoulettePart.HugeType(name: "Title A", huge: .large, delegate: rouletteView, index: 0),
            RoulettePart.HugeType(name: "Title B", huge: .normal, delegate: rouletteView, index: 1),
            RoulettePart.HugeType(name: "Title C", huge: .normal, delegate: rouletteView, index: 2),
        ])
    }
    
    @objc func didTapStartButton() {
        if rouletteView.isAnimating {
            rouletteView.stop()
        } else {
            rouletteView.start()
        }
        startButton.setTitle(rouletteView.isAnimating ? "Stop" : "Start", for: .normal)
    }
}
