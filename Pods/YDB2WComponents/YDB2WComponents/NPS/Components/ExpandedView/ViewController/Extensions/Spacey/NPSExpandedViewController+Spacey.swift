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
      }
    }
    
    if (scrollView.contentOffset.y >= 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)) {
      UIView.animate(withDuration: 0.5) { [weak self] in
        guard let self = self else { return }
        //          self?.buttonViewWithoutShadow = false
        self.bottomShadowView.layer.applyShadow(x: 0, y: -1, blur: 4)
      }
    }
  }
  
  public func onPlayerComponentID(_ videoId: String?) {}
  public func onComponentsList(_ list: [YDSpaceyCommonStruct]) {
    guard let spacey = spaceyViewModel?.spacey.value else { return }
    
    var subTitleText: String? = "avalie a loja Americanas :)"
    
    spacey.allComponents().forEach {
      guard let npsComponent = $0.component as? YDSpaceyComponentNPS
      else {
        return
      }
      
      UIDelegate?.updateNavBarTitle(npsComponent.navBarTitle)
      UIDelegate?.snackBarSuccessText(npsComponent.snackbarText)
      subTitleText = npsComponent.expandedCardSubtitle
    }
    
    var newList = list
    
    newList.insert(
      YDSpaceyCommonStruct(
        id: "subTitle",
        component: YDSpaceyCustomTitle(
          id: "subTitle",
          title: subTitleText
        )
      ),
      at: 0
    )
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      
      self.spaceyViewController?.set(list: newList)
      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
        self.spaceyViewController?.collectionView.collectionViewLayout.invalidateLayout()
      }
    }
  }
  public func onChange(size: CGSize) {}
  public func registerCustomCells(_ collectionView: UICollectionView) {
    collectionView.register(YDNPSCustomTitleCell.self)
  }
  public func dequeueCustomCell(
    _ collectionView: UICollectionView,
    forIndexPath indexPath: IndexPath,
    component: YDSpaceyCustomComponentDelegate
  ) -> UICollectionViewCell {
    guard let titleComponent = component as? YDSpaceyCustomTitle else {
      return UICollectionViewCell()
    }
    
    let cell: YDNPSCustomTitleCell = collectionView
      .dequeueReusableCell(forIndexPath: indexPath)

    cell.configure(title: titleComponent.title)
    return cell
  }
}
