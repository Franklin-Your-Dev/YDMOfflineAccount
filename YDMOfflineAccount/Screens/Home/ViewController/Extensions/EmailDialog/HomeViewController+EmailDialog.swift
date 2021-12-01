//
//  HomeViewController+EmailDialog.swift
//  YDMOfflineAccount
//
//  Created by Douglas Hennrich on 01/12/21.
//

import UIKit
import MessageUI

extension HomeViewController {
  func openEmailDialog() {
    let email = "atendimento.acom@americanas.com"
    let subject = "Não consigo verificar meus dados no Modo Loja"
    let body = """
    Olá, Eu tentei acessar o Modo Loja para verificar meus dados informados nas lojas físicas e não estou conseguindo. Poderia me ajudar? Meu CPF é xxx-xxx-xxx-xx (preencher com seu CPF)
    """
    
    if MFMailComposeViewController.canSendMail() {
      let mailComposerVC = MFMailComposeViewController()
      mailComposerVC.setToRecipients([email])
      mailComposerVC.setSubject(subject)
      mailComposerVC.setMessageBody(body, isHTML: true)
      present(mailComposerVC, animated: true, completion: nil)
    } else {
      guard let coded = "mailto:\(email)?subject=\(subject)&body=\(body)"
              .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
        let emailURL = URL(string: coded) else { return }
      
        UIApplication.shared.open(emailURL, options: [:])
    }
  }
}
