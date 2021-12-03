//
//  ViewController.swift
//  Example
//
//  Created by magna on 26/11/21.
//

import UIKit
import YDB2WModels
import YDMOfflineAccount

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let user = YDCurrentCustomer(
      id: "1",
      email: "franklingaspar@yourdev.com.br",
      firstName: "Franklin",
      fullName: "Franklin Ramos Gaspar",
      accessToken: "accessToken",
      clientLasaToken: "clientLasaToken",
      clientLasaStoreId: "clientLasaStoreId"
    )
    
    let teste = YDMOfflineAccount()
    Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: {_ in
      teste.start(navCon: self.navigationController, user: user, openCustomerIdentifier: true)
    })
  }


}

