//
//  AnimatedCardViewModel.swift
//  loafwallet
//
//  Created by Kerry Washington on 12/23/20.
//  Copyright © 2020 Litecoin Foundation. All rights reserved.
//

import Foundation
import UIKit

class AnimatedCardViewModel: ObservableObject {
     
    @Published
    var rotateIn3D = false
     
    @Published
    var isLoggedIn = false
    
    @Published
<<<<<<< HEAD
    var imageFront = "litecoin-front-card-border"
=======
    var imageFront = "litecoin-card-front"
>>>>>>> main
    
    var dropOffset: CGFloat = -200.0
     
    init() { }
}
