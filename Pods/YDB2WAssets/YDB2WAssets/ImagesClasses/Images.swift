//
//  UIImageExtension.swift
//  YDB2WAssets
//
//  Created by Douglas Hennrich on 30/10/20.
//

import UIKit
import YDB2WBrandManager
import YDB2WModels

private let podsBundle = Bundle(for: YDAssets.self)

private func getBrandFileName(_ name: String) -> String {
  guard let brand = YDBrandManager.shared.brand else { return "" }
  
  return "\(brand.codeName.lowercased())_\(name)"
}

public class YDAssets {
  // MARK: Icons
  public enum Icons {
    public static let arrowDown: UIImage? = {
      UIImage(named: "iconArrowDown", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static var arrowReply: UIImage? = {
      UIImage(
        named: getBrandFileName("iconArrowReply"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let bars: UIImage? = {
      UIImage(named: "iconBars", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let basket: UIImage? = {
      UIImage(named: "iconBasket", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let chatBalloon: UIImage? = {
      UIImage(
        named: getBrandFileName("iconChatBalloon"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let chatWired: UIImage? = {
      UIImage(
        named: getBrandFileName("iconChatWired"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let check: UIImage? = {
      UIImage(named: "iconCheck", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let chevronDown: UIImage? = {
      UIImage(named: "chevron-down", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let chevronLeft: UIImage? = {
      UIImage(named: "iconChevronLeft", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let chevronRight: UIImage? = {
      UIImage(named: "iconChevronRight", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let circleDefault: UIImage? = {
      UIImage(named: "iconCircleDefault", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let circleDefaultOff: UIImage? = {
      UIImage(
        named: "iconCircleDefaultOff",
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let circleDone: UIImage? = {
      UIImage(named: "iconCircleDone", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let circleDoneFull: UIImage? = {
      UIImage(named: "iconCircleDoneFull", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let circleUser: UIImage? = {
      UIImage(named: "iconCircleUser", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let curvedRightArrow: UIImage? = {
      UIImage(
        named: getBrandFileName("iconCurvedRightArrow"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let exclamation: UIImage? = {
      UIImage(
        named: getBrandFileName("iconExclamation"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let eye: UIImage? = {
      UIImage(named: "iconEye", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let gps: UIImage? = {
      UIImage(named: "gps-icon", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let happyFace: UIImage? = {
      UIImage(named: "iconHappyFace", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let heart: UIImage? = {
      UIImage(
        named: getBrandFileName("iconHeart"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let imagePlaceHolder: UIImage? = {
      UIImage(named: "iconImagePlaceHolder", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let info: UIImage? = {
      UIImage(named: "iconInfo", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let leftArrow: UIImage? = {
      UIImage(
        named: getBrandFileName("iconLeftArrow"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let locationPin: UIImage? = {
      UIImage(
        named: getBrandFileName("iconLocationPin"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let logo: UIImage? = {
      UIImage(named: "logoAcom", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let logoSmall: UIImage? = {
      UIImage(named: "logoSmallAcom", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let rightArrow: UIImage? = {
      UIImage(
        named: getBrandFileName("iconRightArrow"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let pin: UIImage? = {
      UIImage(
        named: getBrandFileName("iconPin"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let map: UIImage? = {
      UIImage(named: "iconMap", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let reload: UIImage? = {
      UIImage(named: "iconReload", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let sadFace: UIImage? = {
      UIImage(named: "iconSadFace", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let scheduleAction: UIImage? = {
      UIImage(named: "iconActionCalendar", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let scheduleLive: UIImage? = {
      UIImage(named: "iconScheduleLive", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let store: UIImage? = {
      UIImage(named: "iconStore", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let play: UIImage? = {
      UIImage(
        named: getBrandFileName("iconPlay"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let point: UIImage? = {
      UIImage(named: "point", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let questionBalloon: UIImage? = {
      UIImage(
        named: getBrandFileName("iconQuestionBalloon"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let share: UIImage? = {
      UIImage(named: "iconShare", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let thumbUpFilled: UIImage? = {
      UIImage(named: "thumbUpFilled", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let thumbDownWired: UIImage? = {
      UIImage(
        named: getBrandFileName("iconThumbDownWired"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let thumbUpWired: UIImage? = {
      UIImage(
        named: getBrandFileName("iconThumbUpWired"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let times: UIImage? = {
      UIImage(named: "iconTimes", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let trash: UIImage? = {
      UIImage(
        named: getBrandFileName("iconTrash"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let userWired: UIImage? = {
      UIImage(named: "iconUserWired", in: podsBundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let unpin: UIImage? = {
      UIImage(
        named: getBrandFileName("iconUnpin"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
    
    public static let whatsapp: UIImage? = {
      UIImage(
        named: getBrandFileName("iconWhatsapp"),
        in: podsBundle,
        compatibleWith: nil
      )?.withRenderingMode(.alwaysTemplate)
    }()
  }
  
  // MARK: Images
  public enum Images {
    public static let basket: UIImage? = {
      UIImage(named: "basket", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let booklet: UIImage? = {
      UIImage(named: "booklet", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let clipboard: UIImage? = {
      UIImage(named: "clipboard", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let logoWithLive: UIImage? = {
      UIImage(named: "logoWithLive", in: podsBundle, compatibleWith: nil)
    }()
    
    public static var logoSmall: UIImage? = {
      UIImage(
        named: getBrandFileName("logoSmall"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let map: UIImage? = {
      UIImage(named: "map", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let qrCode: UIImage? = {
      UIImage(named: "qrCode", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let qrCodeCard: UIImage? = {
      UIImage(named: "qrCodeCard", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let store: UIImage? = {
      UIImage(named: "store", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let storePin: UIImage? = {
      UIImage(named: "storePin", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let storePinFaded: UIImage? = {
      UIImage(named: "storePinFaded", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let storeWithPin: UIImage? = {
      UIImage(named: "storeWithPin", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let starYellow: UIImage? = {
      UIImage(named: "starYellow", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let starGrey: UIImage? = {
      UIImage(named: "starGrey", in: podsBundle, compatibleWith: nil)
    }()
    
    public static let thumbUpFilled: UIImage? = {
      UIImage(
        named: getBrandFileName("thumbUpFilled"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let thumbUpFilledRotate20: UIImage? = {
      UIImage(
        named: getBrandFileName("thumbUpFilled20"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let thumbUpFilledRotateMinus13: UIImage? = {
      UIImage(
        named: getBrandFileName("thumbUpFilledMinus13"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let thumbUpFilledOpacity15: UIImage? = {
      UIImage(named: getBrandFileName("thumbUpFilledOpacity15"), in: podsBundle, compatibleWith: nil)
    }()
    
    public static let thumbUpFilledRotate24Opacity15: UIImage? = {
      UIImage(
        named: getBrandFileName("thumbUpFilled24Opacity15"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
    
    public static let thumbUpFilledRotateMinus18Opacity15: UIImage? = {
      UIImage(
        named: getBrandFileName("thumbUpFilledMinus18Opacity15"),
        in: podsBundle,
        compatibleWith: nil
      )
    }()
  }
}

