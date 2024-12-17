//
//  ExampleViewController.swift
//  CombineSupplementExample
//
//  Created by jiasong on 2023/6/1.
//

import UIKit
import Combine
import CombineSupplement

class ExampleViewController: UIViewController {
    
    lazy var exampleView: ExampleView = {
        return ExampleView()
    }()
    
    @CurrentValueRelayMainThreadWrapper
    var name: String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.exampleView.$text.publisher
            .receive(on: MainScheduler.instance)
            .sink { [weak self] text in
                guard let self = self else { return }
                print("\(self.exampleView.text)")
                print("\(text)")
            }
            .cancelled(by: self.combine.cancellableBag)
        
        self.exampleView.$text.publisher
            .sink { [weak self] text in
                guard let self = self else { return }
                print("\(self.exampleView.text)")
                print("\(text)")
            }
            .cancelled(by: self.combine.cancellableBag)
        
        self.exampleView.setText("123")
        
        self.$name.publisher
            .receive(on: MainScheduler.instance)
            .sink {
                print("name \($0)")
            }
            .cancelled(by: self.combine.cancellableBag)
        
        for item in 0...1000 {
            self.name = "\(item)"
        }
        for item in 1001...2000 {
            DispatchQueue.global().async {
                self.name = "\(item)"
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.name = "0"
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.exampleView = ExampleView()
    }
    
}
