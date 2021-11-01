//
//  NPSExpandedViewController+Spacey.swift
//  YDB2WComponents
//
//  Created by Douglas Hennrich on 18/10/21.
//

import UIKit
import YDB2WModels

extension YDNPSExpandedViewController: YDSpaceyControllerDelegate {
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    UIDelegate?.scrollViewDidScroll(scrollView)
    
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
      // reach bottom
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self = self else { return }
        self.bottomShadowView.layer.applyShadow(x: 0, y: -1, blur: 4)
      }
    }
    
    if (scrollView.contentOffset.y < 0){
      // reach top
      UIView.animate(withDuration: 0.5) { [weak self] in
        self?.bottomShadowView.layer.shadowOpacity = 0

//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
//          self?.buttonViewWithoutShadow = true
//        }
      }
    }

    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)) {
      // not top and not bottom
//      if buttonViewWithoutShadow {
        UIView.animate(withDuration: 0.5) { [weak self] in
          guard let self = self else { return }
//          self?.buttonViewWithoutShadow = false
          self.bottomShadowView.layer.applyShadow(x: 0, y: -1, blur: 4)
        }
//      }
    }
  }
  
  public func onPlayerComponentID(_ videoId: String?) {}
  public func onComponentsList(_ list: [YDSpaceyCommonStruct]) {
    guard let spacey = spaceyViewModel?.spacey.value else { return }
    
    spacey.allComponents().forEach {
      guard let npsComponent = $0.component as? YDSpaceyComponentNPS
      else {
        return
      }
      
      UIDelegate?.updateNavBarTitle(npsComponent.navBarTitle)
      UIDelegate?.snackBarSuccessText(npsComponent.snackbarText)
    }
  }
  public func onChange(size: CGSize) {}
  public func registerCustomCells(_ collectionView: UICollectionView) {}
  public func dequeueCustomCell(
    _ collectionView: UICollectionView,
    forIndexPath indexPath: IndexPath,
    component: YDSpaceyCustomComponentDelegate
  ) -> UICollectionViewCell {
    UICollectionViewCell()
  }
}
