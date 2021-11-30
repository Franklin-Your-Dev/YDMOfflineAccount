//
//  YDSpaceyComponentNPSQuestion.swift
//  YDB2WModels
//
//  Created by Douglas Hennrich on 18/05/21.
//

import Foundation

public class YDSpaceyComponentNPSQuestion: YDSpaceyComponentDelegate {
  // MARK: Enum
  public enum AnswerTypeEnum: String, CaseIterable, Decodable {
    case star = "estrela"
    case option = "opção"
    case grade = "nota"
    case multiple = "múltipla escolha"
    case textView
    
    public var transformedToMetric: String {
      switch self {
        case .star:
          return "ESTRELA"
          
        case .option:
          return "OPÇÃO"
          
        case .grade:
          return "NOTA"
          
        case .multiple:
          return "MULTIPLA ESCOLHA"
          
        case .textView:
          return "OPEN"
      }
    }
  }
  
  // NPS isOptional Enum
  public enum IsOptionalEnum: String {
    case yes = "sim"
    case no = "não"
  }

  // MARK: Properties
  public var id: String?
  public var type: YDSpaceyComponentsTypes.Types
  public var children: [YDSpaceyComponentsTypes] = []
  public var childrenAnswers: [YDSpaceyComponentNPSQuestionAnswer]
  public var answerType: AnswerTypeEnum
  
  public var maxScore: Int?
  public var maxStars: Int?
  public var lowerGradeText: String?
  public var higherGradeText: String?
  
  public var question: String?
  public var title: String?
  
  public var hint: String?
  public var maxCharacter: Int?
  
  public var isOptional: IsOptionalEnum

  public var storedValue: Any?
  
  public var itsFromPreview = false

  // MARK: CodingKeys
  enum CodingKeys: String, CodingKey {
    case id = "_id"
    case type
    case children
    case childrenAnswers
    case answerType
    
    case maxScore
    case maxStars
    case lowerGradeText = "textForLowerGrade"
    case higherGradeText = "textForHigherGrade"
    
    case question
    case title
    
    case hint
    case maxCharacter
    
    case isOptional
  }

  // MARK: Init
  public required init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    id = try? container.decode(String.self, forKey: .id)
    type = try container.decode(YDSpaceyComponentsTypes.Types.self, forKey: .type)
    
    if let isOptionalString = try? container.decode(
        String.self,
        forKey: .isOptional
    ) {
      isOptional = IsOptionalEnum(rawValue: isOptionalString) ?? .yes
      
    } else {
      isOptional = .yes
    }

    answerType = try container
      .decodeIfPresent(
        YDSpaceyComponentNPSQuestion.AnswerTypeEnum.self,
        forKey: .answerType
      ) ?? .textView

    let throwables = try? container.decode(
      [Throwable<YDSpaceyComponentNPSQuestionAnswer>].self,
      forKey: .children
    )
    childrenAnswers = throwables?.compactMap { try? $0.result.get() } ?? []

    maxScore = try? container.decode(Int.self, forKey: .maxScore)
    maxStars = try? container.decode(Int.self, forKey: .maxStars)
    question = try? container.decode(String.self, forKey: .question)
    title = try? container.decode(String.self, forKey: .title)
    hint = try? container.decode(String.self, forKey: .hint)
    maxCharacter = try? container.decode(Int.self, forKey: .maxCharacter)

    if answerType == .grade {
      for index in 1...(maxScore ?? 0) {
        childrenAnswers.append(
          YDSpaceyComponentNPSQuestionAnswer(id: "\(index)", answerText: "\(index)")
        )
      }
    }
  }
}

