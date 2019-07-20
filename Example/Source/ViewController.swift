//  Copyright © 2019 Marco Santarossa. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addAccessibility()
        // Do any additional setup after loading the view.
    }

    private func addAccessibility() {
        view.addAccessibility(aip: MainAIP.self, element: .mainView)
        label.addAccessibility(aip: MainAIP.self, element: .label)
    }

}

