//
//  YDTaxCouponViewController+Share.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 30/08/21.
//

import UIKit

extension YDTaxCouponViewController {
  func shareAction() {
    guard let image = snapshot() else { return }
    
    let activityViewController = UIActivityViewController(
      activityItems: [image],
      applicationActivities: nil
    )

//    YDIntegrationHelper.shared
//      .trackEvent(
//        withName: .offlineAccountHistoric,
//        ofType: .state,
//        withParameters: [
//          "&ea=": "clique-botao",
//          "&el=": "Botão exportar relatório ações lojas fisicas"
//        ]
//      )

    present(activityViewController, animated: true, completion: nil)
  }
  
  func snapshot() -> UIImage? {
    let holeCouponViewSize = CGSize(
      width: containerView.frame.size.width,
      height: (
        containerView.frame.size.height - collectionView.frame.size.height
      ) + collectionView.contentSize.height
    )
    
    let paddingContainerViewToShareButton: CGFloat = 12
    let shareButtonSize: CGFloat = 58
    
    let holeScreenSize = CGSize(
      width: view.frame.size.width,
      height: holeCouponViewSize.height +
        paddingContainerViewToShareButton +
        shareButtonSize
    )
    
    let savedViewFrame = view.frame
    let savedContainerViewFrame = containerView.frame
    let savedContentOffset = collectionView.contentOffset
    let savedCollectionViewFrame = collectionView.frame

    defer {
      UIGraphicsEndImageContext()
      
      viewHeight.constant = savedViewFrame.height
      containerViewHeightConstraint.constant = savedContainerViewFrame.height
      collectionView.contentOffset = savedContentOffset
      collectionView.showsVerticalScrollIndicator = true
      collectionViewHeightConstraint.constant = savedCollectionViewFrame.height
      
      backButton.isHidden = false
      view.layoutIfNeeded()
      containerView.layoutIfNeeded()
    }

    collectionView.contentOffset = .zero

    viewHeight.constant = holeScreenSize.height
    containerViewHeightConstraint.constant = holeCouponViewSize.height
    collectionViewHeightConstraint.constant = collectionView.contentSize.height
    
    containerView.layoutIfNeeded()
    view.layoutIfNeeded()
    
    collectionView.showsVerticalScrollIndicator = false
    backButton.isHidden = true

    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(holeCouponViewSize, false, scale)

    guard let context = UIGraphicsGetCurrentContext() else { return nil }

    containerView.layer.render(in: context)

    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image
  }
}
