//
//  CardContentItem.swift
//  ConfigBasedModalExample
//
//  Created by Dominic Go on 6/9/24.
//

import UIKit


public enum CardContentItem {

  case filledButton(
    id: String? = nil,
    title: [AttributedStringConfig],
    subtitle: [AttributedStringConfig]? = nil,
    controlEvent: UIControl.Event = .primaryActionTriggered,
    handler: ((_ context: CardConfig, _ button: UIButton) -> Void)?
  );
  
  case slider(
    id: String? = nil,
    minValue: Float,
    maxValue: Float,
    initialValue: Float,
    valueLabelStyle: AttributedStringConfig? = nil,
    valueLabelMinWidth: CGFloat? = nil,
    setup: ((
      _ context: CardConfig,
      _ button: UISlider
    ) -> Void)? = nil,
    onValueTrackingStarted: ((
      _ context: CardConfig,
      _ button: UISlider
    ) -> Void)? = nil,
    onValueTrackingEnded: ((
      _ context: CardConfig,
      _ button: UISlider
    ) -> Void)? = nil,
    onValueChanged: ((
      _ context: CardConfig,
      _ button: UISlider
    ) -> Void)? = nil
  );
  
  case label(
    id: String?,
    items: [AttributedStringConfig]
  );
  
  case multiLineLabel(
    id: String?,
    items: [AttributedStringConfig]
  );
  
  case labelValueDisplay(
    id: String? = nil,
    items: [CardLabelValueDisplayItemConfig]
  );
  
  case spacer(
    id: String? = nil,
    space: CGFloat
  );
  
  case view(
    id: String? = nil,
    _ view: UIView
  );
  
  // MARK: Computed Properties
  // -------------------------
  
  public var id: String? {
    switch self {
      case let .filledButton(id, _, _, _, _):
        return id;
        
      case let .slider(id, _, _, _, _, _, _, _, _, _):
        return id;
        
      case let .label(id, _):
        return id;
        
      case let .multiLineLabel(id, _):
        return id;
        
      case let .labelValueDisplay(id, _):
        return id;
        
      case let .spacer(id, _):
        return id;
        
      case let .view(id, _):
        return id;
    };
  };
  
  // MARK: Functions
  // ---------------
  
  public func makeContent(
    cardConfig: CardConfig,
    themeColorConfig: ColorThemeConfig
  ) -> UIView {
  
    switch self {
      case let .filledButton(_, title, subtitle, controlEvent, handler):
        let button = UIButton(type: .system);
        
        var attributedStringConfigs: [AttributedStringConfig] = [];
        attributedStringConfigs += title.map {
          var config = $0;
          if config.fontConfig.weight == nil {
            config.fontConfig.weight = .bold;
          };
          
          return config;
        };
        
        if var subtitle = subtitle,
           subtitle.count > 0 {
          
          subtitle.insert(.newLine, at: 0);
          attributedStringConfigs += subtitle.map {
            var config = $0;
            if config.fontConfig.weight == nil {
              config.fontConfig.size = 14;
            };
            
            return config;
          };
          
          button.titleLabel?.lineBreakMode = .byWordWrapping;
          button.contentHorizontalAlignment = .left;
          
          button.contentEdgeInsets =
            .init(top: 6, left: 12, bottom: 6, right: 12);
          
        } else {
          button.contentEdgeInsets =
            .init(top: 8, left: 8, bottom: 8, right: 8);
        };
        
        for index in 0..<attributedStringConfigs.count {
          if attributedStringConfigs[index].foregroundColor == nil {
            attributedStringConfigs[index].foregroundColor = themeColorConfig.colorTextLight;
          };
        };
        
        let attributedString =
          attributedStringConfigs.makeAttributedString();
        
        button.setAttributedTitle(attributedString, for: .normal);
        
        button.tintColor = .white
        button.layer.cornerRadius = 8;
        button.layer.masksToBounds = true;
        
        let imageConfig = ImageConfigSolid(
          fillColor: themeColorConfig.colorBgAccent
        );
        
        button.setBackgroundImage(
          imageConfig.makeImage(),
          for: .normal
        );
        
        if let handler = handler {
          button.addAction(for: controlEvent){
            handler(cardConfig, button);
          };
        };
        
        return button;
        
      case let .slider(
        _, minValue, maxValue, initialValue,
        valueLabelStyle, valueLabelMinWidth,
        setup, onValueTrackingStarted, onValueTrackingEnded, onValueChanged
      ):
        let valueLabelStyle = valueLabelStyle ?? .init(
          fontConfig: .init(
            size: 14,
            weight: .bold,
            symbolicTraits: [.traitMonoSpace]
          ),
          paragraphStyle: {
            let paragraphStyle = NSMutableParagraphStyle();
            paragraphStyle.alignment = .center;
            
            return paragraphStyle;
          }(),
          color: themeColorConfig.colorTextDark
        );
      
        let rowStack: UIStackView = {
          let stack = UIStackView();
          stack.axis = .horizontal;
          stack.spacing = 12;
          stack.distribution = .fill;
          stack.alignment = .fill;
          
          return stack;
        }();
        
        let labelSliderValue: UILabel = {
          let label = UILabel();
          label.alpha = 0.8;
          label.textAlignment = .center;
          label.numberOfLines = 1;
          
          label.attributedText = valueLabelStyle.makeAttributedString(
            withNewText: "\(initialValue.cutOffDecimalsAfter(2))"
          );
          
          let valueLabelMinWidth = valueLabelMinWidth ?? 40;
          label.translatesAutoresizingMaskIntoConstraints = false;
          
          NSLayoutConstraint.activate([
            label.widthAnchor.constraint(
              greaterThanOrEqualToConstant: valueLabelMinWidth
            ),
          ]);
          
          return label;
        }();
      
        let slider = UISlider();
        slider.minimumValue = minValue;
        slider.maximumValue = maxValue;
        slider.value = initialValue;
        slider.minimumTrackTintColor = themeColorConfig.colorBgAccent;
        
        setup?(cardConfig, slider);
        
        if let onValueTrackingStarted = onValueTrackingStarted {
          slider.addAction(for: [.touchDown]){
            onValueTrackingStarted(cardConfig, slider);
          };
        };
        
        if let onValueTrackingEnded = onValueTrackingEnded {
          slider.addAction(for: [.touchUpOutside, .touchUpInside]){
            onValueTrackingEnded(cardConfig, slider);
          };  
        };
        
        slider.addAction(for: [.valueChanged]){
          onValueChanged?(cardConfig, slider);
          
          let labelText = "\(slider.value.cutOffDecimalsAfter(2))";
          labelSliderValue.attributedText = valueLabelStyle.makeAttributedString(
            withNewText: labelText
          );
        };
        
        rowStack.addArrangedSubview(slider);
        rowStack.addArrangedSubview(labelSliderValue);
        return rowStack;
        
      case let .label(_, configs):
        let label = UILabel();
        
        label.font = nil;
        label.textColor = nil;
        label.attributedText = configs.makeAttributedString();
        
        return label;
        
      case let .multiLineLabel(_, configs):
        let label = UILabel();
        
        label.font = nil;
        label.textColor = nil;
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping;
        
        label.attributedText = configs.makeAttributedString();
        return label;
        
      case let .labelValueDisplay(_, items):
        let config = CardLabelValueDisplayConfig(
          items: items,
          deriveColorThemeConfigFrom: cardConfig.colorThemeConfig
        );
        
        return config.createView();
        
      case let .spacer(_, space):
        return UIView(frame: .init(
          origin: .zero,
          size: .init(width: 0, height: space)
        ));
        
      case let .view(_, customView):
        return customView;
    };
  };
};

// MARK: - CardContentItem+StaticAlias
// -----------------------------------

public extension CardContentItem {
  
  static func label(_ items: [AttributedStringConfig]) -> Self {
    .label(id: nil, items: items);
  };
  
  static func multiLineLabel(_ items: [AttributedStringConfig]) -> Self {
    .multiLineLabel(id: nil, items: items);
  };
};
