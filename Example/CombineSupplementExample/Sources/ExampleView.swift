//
//  ExampleView.swift
//  CombineSupplementExample
//
//  Created by jiasong on 2023/6/1.
//

import UIKit
import CombineSupplement

class ExampleView: UIView {

    @CurrentValueSubjected fileprivate(set) var text: String = "1"

}

extension ExampleView {
    
    func setText(_ text: String) {
        self.text = text
    }
    
}
