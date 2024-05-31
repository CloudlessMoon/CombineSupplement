//
//  ExampleView.swift
//  CombineSupplementExample
//
//  Created by jiasong on 2023/6/1.
//

import UIKit
import CombineSupplement

class ExampleView: UIView {
    
    @CurrentValueRelayWrapper
    fileprivate(set) var text: String = "1"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension ExampleView {
    
    func setText(_ text: String) {
        self.text = text
    }
    
}
