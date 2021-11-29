//
//  SpaceyViewModel+Products.swift
//  YDSpacey
//
//  Created by Douglas Hennrich on 30/09/21.
//

import Foundation
import YDB2WModels
import YDB2WServices

// MARK: Product Delegate
public protocol YDSpaceyViewModelProductDelegate: AnyObject {
  func selectProductOnCarrousel(_ product: YDSpaceyProduct)
  func addProductToCart(_ product: YDSpaceyProduct, with parameters: [String : Any])
  func onTapProductCoupon(_ product: YDSpaceyProduct)
}

extension YDSpaceyViewModel {
  public func getProductsIds(
    at: Int,
    onCompletion: @escaping ([(id: String, sellerId: String)]) -> Void
  ) {
    guard let componentChildrens = componentsList.value.at(at)?.component?.children else {
      return
    }

    var ids: [ (id: String, sellerId: String) ] = []

    componentChildrens.forEach { curr in
      if case .product(let product) = curr {
        ids.append((id: product.productId, sellerId: product.sellerId ?? ""))
      }
    }

    onCompletion(ids)
  }
  
  public func getProducts(
    ofIds ids: [(id: String, sellerId: String)],
    at: Int,
    onCompletion completion: @escaping (Result<[YDSpaceyProduct], YDServiceError>) -> Void
  ) {
    var products: [YDSpaceyProduct] = []

    let group = DispatchGroup()

    for curr in ids {
      group.enter()
      
      service.getProduct(ofIds: curr) { response in
        group.leave()
        switch response {
          case .success(let product):
            let avaliation = YDSpaceyProductRating(
              average: product.rating ?? 0,
              recommendations: 0,
              reviews: product.numReviews ?? 0
            )

            let liveProduct = YDSpaceyProduct(
              description: product.description,
              id: product.productId,
              images: product.images,
              name: product.name,
              price: product.price,
              priceConditions: product.priceConditions,
              ean: product.ean,
              rating: avaliation,
              partnerId: product.partnerId,
              stock: product.stock,
              couponName: product.couponName,
              couponDeeplink: product.couponDeeplink,
              priceFrom: product.priceFrom,
              discountBadgeText: product.discountBadgeText
            )

            products.append(liveProduct)

          case .failure(let error):
            print("@@@@@", error.message)
        }
      }
    }

    group.wait()
    
    let allProductsComponents = getAllProductsComponentsType(at: at)
    
    if allProductsComponents.isEmpty {
      completion(.success([]))
      return
    }
    
    let order: [String] = allProductsComponents.map { $0.productId }
    
    products = products.reordered(order: order)
    
    for curr in products {
      guard let component = allProductsComponents.first(where: { $0.productId == curr.id }) else {
        continue
      }
      
      curr.couponName = component.couponName
      curr.couponDeeplink = component.couponDeeplink
    }
    
    completion(.success(products))
  }
  
  public func selectProductOnCarrousel(_ product: YDSpaceyProduct) {
    productDelegate?.selectProductOnCarrousel(product)
  }
  
  public func onAddProductToCart(_ product: YDSpaceyProduct, with parameters: [String : Any]) {
    productDelegate?.addProductToCart(product, with: parameters)
  }
  
  public func onTapProductCoupon(_ product: YDSpaceyProduct) {
    productDelegate?.onTapProductCoupon(product)
  }
}

// MARK: Actions
extension YDSpaceyViewModel {
  private func getAllProductsComponentsType(at index: Int) -> [YDSpaceyComponentProduct] {
    guard let componentChildrens = componentsList.value.at(index)?.component?.children else {
      return []
    }
    
    var products: [YDSpaceyComponentProduct] = []
    
    componentChildrens.forEach {
      if case .product(let product) = $0 {
        products.append(product)
      }
    }
    
    return products
  }
}

// MARK: Extension
fileprivate extension Array where Element == YDSpaceyProduct {
  func reordered(order: [String]) -> [YDSpaceyProduct] {

    return self.sorted { (a, b) -> Bool in
      if let first = order.firstIndex(of: a.id ?? ""),
         let second = order.firstIndex(of: b.id ?? "") {
          return first < second
      }
      return false
    }
  }
}
