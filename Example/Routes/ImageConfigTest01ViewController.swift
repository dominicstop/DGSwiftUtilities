//
//  ImageConfigTest01ViewController.swift
//  
//
//  Created by Dominic Go on 8/7/24.
//

import UIKit
import DGSwiftUtilities


class ImageConfigTest01ViewController: UIViewController {

  var cardControllers: [CardViewController] = [];
  
  override func viewDidLoad() {
    super.viewDidLoad();
    self.view.backgroundColor = .white;
    
    let stackView: UIStackView = {
      let stack = UIStackView();
      
      stack.axis = .vertical;
      stack.distribution = .fill;
      stack.alignment = .fill;
      stack.spacing = 15;
                
      return stack;
    }();
    
    var cardControllers: [CardViewController] = [];
    
    /// Tests for `ImageConfigSolid`
    cardControllers.append({
      let imageConfig = ImageConfigSolid(
        size: .init(width: 100, height: 100),
        fillColor: .red,
        borderRadius: 10
      );
      
      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      cardVC.setInjectedValue(forKey: "didLoadImage", value: false);
      
      cardContentItems.append(
        .labelValueDisplay(items: imageConfig.metadataAsLabelValueDisplayItems)
      );
      
      cardContentItems.append(
        .labelValueDisplay(items: [])
      );
      
      cardContentItems.append(
        .filledButton(
          title: [
            .init(text: "Load Image"),
          ],
          subtitle: [],
          handler: { _,_ in
            
            if cardVC.getInjectedValue(
              forKey: "didLoadImage",
              fallbackValue: false
            ) {
              cardVC.updateLogValueDisplay { _ in
                return [];
              };
            };
            
            cardVC.appendToLogValueDisplay(
              withItems: [
                .singleRow(
                  label: [
                    Helpers.createTimestamp(),
                  ],
                  value: [
                    .init(text: "Load image start")
                  ]
                ),
              ]
            );
            
            cardVC.setInjectedValue(forKey: "didLoadImage", value: false);
            cardVC.applyCardConfig();
            
            let imageLoader: ImageConfigLoader = .init(
              imageConfig: imageConfig
            );
            
            imageLoader.loadImageIfNeeded { sender in
              cardVC.appendToLogValueDisplay(
                withItems: [
                  .singleRow(
                    label: [
                      Helpers.createTimestamp(),
                    ],
                    value: [
                      .init(text: "Image loaded")
                    ]
                  ),
                  .singeRowWithImageValue(
                    label: [
                      .init(text: "Image")
                    ],
                    image: sender.cachedImage!,
                    size: .init(width: 50, height: 50),
                    contentMode: .scaleAspectFit
                  ),
                ]
              );
              
              cardVC.applyCardConfig();
              cardVC.setInjectedValue(forKey: "didLoadImage", value: true);
            };
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "ImageConfigSolid test",
        desc: [],
        content: cardContentItems
      );
      
      return cardVC;
    }());
    
    /// Tests for `ImageConfigGradient` w/ multiple presets
    cardControllers.append({
      let presets: [ImageConfigGradient] = [
        .init(
          type: .axial,
          colors: [.red, .orange],
          startPointPreset: .top,
          endPointPreset: .bottom,
          cornerRadius: 10,
          size: .init(width: 100, height: 100)
        ),
        .init(
          type: .conic,
          colors: [.orange, .yellow],
          startPointPreset: .center,
          endPointPreset: .topLeft,
          cornerRadius: 15,
          size: .init(width: 100, height: 100)
        ),
        .init(
          type: .radial,
          colors: [.yellow, .green],
          startPointPreset: .center,
          endPointPreset: .bottomRight,
          cornerRadius: 20,
          size: .init(width: 100, height: 100)
        ),
        .init(
          type: .axial,
          colors: [.green, .blue, .purple],
          startPointPreset: .left,
          endPointPreset: .right,
          cornerRadius: 10,
          size: .init(width: 100, height: 100)
        ),
      ];
      
      let initialImageConfig = presets.first!;
      
      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      cardVC.setInjectedValue(
        forKey: "didLoadImage",
        value: false
      );
      
      cardVC.setInjectedValue(
        forKey: "presetIndex",
        value: 0
      );
      
      cardVC.setInjectedValue(
        forKey: "currentImageConfigPreset",
        value: initialImageConfig
      );
      
      cardContentItems.append(
        .labelValueDisplay(
          id: "configDisplay",
          items: initialImageConfig.metadataAsLabelValueDisplayItems
        )
      );
      
      cardContentItems.append(
        .labelValueDisplay(
          id: "logDisplay",
          items: []
        )
      );
      
      /// Next `ImageConfigGradient` preset button
      cardContentItems.append(
        .filledButton(
          title: [
            .init(text: "Next Preset"),
          ],
          subtitle: [],
          handler: { _,_ in
            var presetIndexCurrent = cardVC.getInjectedValue(
              forKey: "presetIndex",
              fallbackValue: 0
            );
            
            presetIndexCurrent += 1;
            cardVC.setInjectedValue(
              forKey: "presetIndex",
              value: presetIndexCurrent
            );
            
            let currentPreset = presets[cyclicIndex: presetIndexCurrent];
            cardVC.setInjectedValue(
              forKey: "currentImageConfigPreset",
              value: currentPreset
            );
            
            cardVC.updateLogValueDisplay(
              forItemID: "configDisplay"
            ) { _ in
              return currentPreset.metadataAsLabelValueDisplayItems;
            };
            
            cardVC.applyCardConfig();
          }
        )
      );
      
      /// Load image button
      cardContentItems.append(
        .filledButton(
          title: [
            .init(text: "Load Image"),
          ],
          subtitle: [],
          handler: { _,_ in
          
            let currentImageConfigPreset = cardVC.getInjectedValue(
              forKey: "currentImageConfigPreset",
              fallbackValue: initialImageConfig
            );
          
            let didLoadImage = cardVC.getInjectedValue(
              forKey: "didLoadImage",
              fallbackValue: false
            );
            
            if didLoadImage {
              cardVC.updateLogValueDisplay(
                forItemID: "logDisplay"
              ) { _ in
                return [];
              };
            };
            
            cardVC.appendToLogValueDisplay(
              forItemID: "logDisplay",
              withItems: [
                .singleRow(
                  label: [
                    Helpers.createTimestamp(),
                  ],
                  value: [
                    .init(text: "Load image start")
                  ]
                ),
              ]
            );
            
            cardVC.setInjectedValue(forKey: "didLoadImage", value: false);
            cardVC.applyCardConfig();
            
            let imageLoader: ImageConfigLoader = .init(
              imageConfig: currentImageConfigPreset
            );
            
            imageLoader.loadImageIfNeeded { sender in
              cardVC.appendToLogValueDisplay(
                forItemID: "logDisplay",
                withItems: [
                  .singleRow(
                    label: [
                      Helpers.createTimestamp(),
                    ],
                    value: [
                      .init(text: "Image loaded")
                    ]
                  ),
                  .singeRowWithImageValue(
                    label: [
                      .init(text: "Image")
                    ],
                    image: sender.cachedImage!,
                    size: .init(width: 50, height: 50),
                    contentMode: .scaleAspectFit
                  ),
                ]
              );
              
              cardVC.applyCardConfig();
              cardVC.setInjectedValue(forKey: "didLoadImage", value: true);
            };
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "ImageConfigGradient Test",
        desc: [],
        content: cardContentItems
      );
      
      return cardVC;
    }());
    
    /// Tests for `TBA` w/ multiple presets
    cardControllers.append({
      let presets: [ImageConfigSystem] = [
        .init(
          systemName: "star"
        ),
        .init(
          systemName: "star",
          color: .tintColor(.yellow)
        ),
        .init(
          systemName: "star",
          weight: .bold,
          color: .tintColor(.yellow)
        ),
        .init(
          systemName: "star",
          pointSize: 32,
          weight: .bold,
          scale: .large,
          color: .tintColor(.yellow)
        ),
      ];
      
      let initialImageConfig = presets.first!;
      
      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      cardVC.setInjectedValue(
        forKey: "didLoadImage",
        value: false
      );
      
      cardVC.setInjectedValue(
        forKey: "presetIndex",
        value: 0
      );
      
      cardVC.setInjectedValue(
        forKey: "currentImageConfigPreset",
        value: initialImageConfig
      );
      
      cardContentItems.append(
        .labelValueDisplay(
          id: "configDisplay",
          items: initialImageConfig.metadataAsLabelValueDisplayItems
        )
      );
      
      cardContentItems.append(
        .labelValueDisplay(
          id: "logDisplay",
          items: []
        )
      );
      
      /// Next `ImageConfigGradient` preset button
      cardContentItems.append(
        .filledButton(
          title: [
            .init(text: "Next Preset"),
          ],
          subtitle: [],
          handler: { _,_ in
            var presetIndexCurrent = cardVC.getInjectedValue(
              forKey: "presetIndex",
              fallbackValue: 0
            );
            
            presetIndexCurrent += 1;
            cardVC.setInjectedValue(
              forKey: "presetIndex",
              value: presetIndexCurrent
            );
            
            let currentPreset = presets[cyclicIndex: presetIndexCurrent];
            cardVC.setInjectedValue(
              forKey: "currentImageConfigPreset",
              value: currentPreset
            );
            
            cardVC.updateLogValueDisplay(
              forItemID: "configDisplay"
            ) { _ in
              return currentPreset.metadataAsLabelValueDisplayItems;
            };
            
            cardVC.applyCardConfig();
          }
        )
      );
      
      /// Load image button
      cardContentItems.append(
        .filledButton(
          title: [
            .init(text: "Load Image"),
          ],
          subtitle: [],
          handler: { _,_ in
          
            let currentImageConfigPreset = cardVC.getInjectedValue(
              forKey: "currentImageConfigPreset",
              fallbackValue: initialImageConfig
            );
          
            let didLoadImage = cardVC.getInjectedValue(
              forKey: "didLoadImage",
              fallbackValue: false
            );
            
            if didLoadImage {
              cardVC.updateLogValueDisplay(
                forItemID: "logDisplay"
              ) { _ in
                return [];
              };
            };
            
            cardVC.appendToLogValueDisplay(
              forItemID: "logDisplay",
              withItems: [
                .singleRow(
                  label: [
                    Helpers.createTimestamp(),
                  ],
                  value: [
                    .init(text: "Load image start")
                  ]
                ),
              ]
            );
            
            cardVC.setInjectedValue(forKey: "didLoadImage", value: false);
            cardVC.applyCardConfig();
            
            let imageLoader: ImageConfigLoader = .init(
              imageConfig: currentImageConfigPreset
            );
            
            imageLoader.loadImageIfNeeded { sender in
              cardVC.appendToLogValueDisplay(
                forItemID: "logDisplay",
                withItems: [
                  .singleRow(
                    label: [
                      Helpers.createTimestamp(),
                    ],
                    value: [
                      .init(text: "Image loaded")
                    ]
                  ),
                  .singeRowWithImageValue(
                    label: [
                      .init(text: "Image")
                    ],
                    image: sender.cachedImage!,
                    size: .init(width: 50, height: 50),
                    contentMode: .scaleAspectFit
                  ),
                ]
              );
              
              cardVC.applyCardConfig();
              cardVC.setInjectedValue(forKey: "didLoadImage", value: true);
            };
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "ImageConfigGradient Test",
        desc: [],
        content: cardContentItems
      );
      
      return cardVC;
    }());
    
    self.cardControllers = cardControllers;
    
    cardControllers.forEach {
      self.addChild($0);
      stackView.addArrangedSubview($0.view);
      $0.didMove(toParent: self);
      
      stackView.setCustomSpacing(15, after: $0.view);
    };
    
    let scrollView: UIScrollView = {
      let scrollView = UIScrollView();
      
      scrollView.showsHorizontalScrollIndicator = false;
      scrollView.showsVerticalScrollIndicator = true;
      scrollView.alwaysBounceVertical = true;
      return scrollView
    }();
    
    stackView.translatesAutoresizingMaskIntoConstraints = false;
    scrollView.addSubview(stackView);
    
    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(
        equalTo: scrollView.topAnchor,
        constant: 40
      ),
      
      stackView.bottomAnchor.constraint(
        equalTo: scrollView.bottomAnchor,
        constant: -100
      ),
      
      stackView.centerXAnchor.constraint(
        equalTo: scrollView.centerXAnchor
      ),
      
      stackView.widthAnchor.constraint(
        equalTo: scrollView.widthAnchor,
        constant: -24
      ),
    ]);
    
    scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.view.addSubview(scrollView);
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.topAnchor
      ),
      scrollView.bottomAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.bottomAnchor
      ),
      scrollView.leadingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.leadingAnchor
      ),
      scrollView.trailingAnchor.constraint(
        equalTo: self.view.safeAreaLayoutGuide.trailingAnchor
      ),
    ]);
  };
  
  func refreshCardController(cardController cardVC: CardViewController){
    let match = self.cardControllers.first {
      $0 === cardVC;
    };
    
    guard let match = match else { return };
    match.applyCardConfig();
  };
};


fileprivate struct Helpers {
  
  static func createTimestamp() -> String {
    let dateFormatter = DateFormatter();
    dateFormatter.dateFormat = "HH:mm:ss.SSS";
    return dateFormatter.string(from: Date());
  };
  
  static func createTimestamp() -> AttributedStringConfig {
    .init(
      text: Self.createTimestamp(),
      fontConfig: .init(
        size: nil,
        weight: nil,
        symbolicTraits: [
          .traitMonoSpace,
          .traitBold,
        ]
      )
    );
  };
  
};

extension ImageConfigSolid {
  
  var metadataAsLabelValueDisplayItems: [CardLabelValueDisplayItemConfig] {
    return [
      .singleRowPlain(
        label: "imageType",
        value: Self.imageType
      ),
      .singleRowPlain(
        label: "size",
        value: self.size.debugDescription
      ),
      .singleRowPlain(
        label: "borderRadius",
        value: self.borderRadius
      ),
      .singleRowPlain(
        label: "fillColor",
        value: String(describing: self.fillColor.rgba)
      ),
    ];
  };
};

extension ImageConfigGradient {

  var metadataAsLabelValueDisplayItems: [CardLabelValueDisplayItemConfig] {
    return [
      .singleRowPlain(
        label: "imageType",
        value: Self.imageType
      ),
      .singleRowPlain(
        label: "type",
        value: self.type.caseString
      ),
      .singleRowPlain(
        label: "size",
        value: self.size.debugDescription
      ),
      .singleRowPlain(
        label: "cornerRadius",
        value: self.cornerRadius
      ),
      .multiLineRow(
        spacing: 0,
        label: [
          .init(text: "colors"),
        ],
        value: self.colors.enumerated().map {
          let isLast = $0.offset == (self.colors.count - 1);
          
          var text = $0.element.components!.debugDescription;
          if !isLast {
            text += "\n"
          };
          
          return .init(text: text);
        }
      ),
      .singleRowPlain(
        label: "locations",
        value: self.locations.debugDescription
      ),
      .singleRowPlain(
        label: "startPoint",
        value: self.startPoint.debugDescription
      ),
      .singleRowPlain(
        label: "endPoint",
        value: self.endPoint.debugDescription
      ),
    ];
  };
};

extension ImageConfigSystem {
  
  var metadataAsLabelValueDisplayItems: [CardLabelValueDisplayItemConfig] {
    return [
      .singleRowPlain(
        label: "imageType",
        value: Self.imageType
      ),
      .multiLineRow(
        spacing: 0,
        label: [
          .init(text: "colors"),
        ],
        value: {
          guard let color = self.color else {
            return [
              .init(text: "N/A")
            ];
          };
          
          switch color {
            case let .hierarchicalColor(color):
              return [
                .init(text: String(describing: color.rgba)),
              ];
              
            case let .paletteColors(colors):
              return colors.enumerated().map {
                let isLast = $0.offset == (colors.count - 1);
                
                var text = String(describing: $0.element.rgba);
                if !isLast {
                  text += "\n"
                };
                
                return .init(text: text);
              }
              
            case let .tintColor(color):
              return [
                .init(text: String(describing: color.rgba)),
              ];
          };
        }()
      ),
      .singleRowPlain(
        label: "systemName",
        value: self.systemName
      ),
      .singleRowPlain(
        label: "pointSize",
        value: self.pointSize?.description ?? "N/A"
      ),
      .singleRowPlain(
        label: "weight",
        value: self.weight?.caseString ?? "N/A"
      ),
      .singleRowPlain(
        label: "scale",
        value: self.scale?.caseString ?? "N/A"
      ),
    ];
  };
};
