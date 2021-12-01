//
//  UserDataViewController+EmailDialog.swift
//  YDMOfflineAccount
//
//  Created by Douglas Hennrich on 30/11/21.
//

import UIKit
import MessageUI

extension UserDataViewController {
  func openEmailDialog() {
    let email = "atendimento.acom@americanas.com"
    let subject = "Não consigo verificar meus dados no Modo Loja"
    let body = """
    Olá, Eu tentei acessar o Modo Loja para verificar meus dados informados nas lojas físicas e não estou conseguindo. Poderia me ajudar? Meu CPF é xxx-xxx-xxx-xx (preencher com seu CPF)
    """
    
    let mailComposerVC = MFMailComposeViewController()
    mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients([email])
    mailComposerVC.setSubject(subject)
    mailComposerVC.setMessageBody(body, isHTML: true)
    present(mailComposerVC, animated: true, completion: nil)
  }
}

// MARK: Mail Delegate
extension UserDataViewController: MFMailComposeViewControllerDelegate {
  func mailComposeController(
    _ controller: MFMailComposeViewController,
    didFinishWith result: MFMailComposeResult,
    error: Error?
  ) {
    viewModel?.onBack()
  }
}
