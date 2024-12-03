//
//  ShapeViewTest01ViewController.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 11/29/24.
//

import UIKit
import DGSwiftUtilities


class ShapeViewTest01ViewController: UIViewController {


  var colorThemeConfig: ColorThemeConfig = .presetPurple;

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
    
    self.setupCardItems();
    
    self.cardControllers.forEach {
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
  
  func setupCardItems(){
    var cardControllers: [CardViewController] = [];
    
    // MARK: regular polygon (`roundedCornersUniform`)
    cardControllers.append({
      let shapeSize: CGFloat = 100;
      
      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      let shapeContainer = UIView();
      let shapeView = ShapeView();
      
      shapeView.maskShapeConfig = .regularPolygon(
        polygonPreset: .regularPolygon(numberOfSides: 3),
        pointAdjustments: .init(
          shouldScaleToFitTargetRect: true,
          shouldPreserveAspectRatioWhenScaling: true,
          pathTransform: .init(rotateZ: .degrees(0))
        ),
        pointConnectionStrategy: .roundedCornersUniform(cornerRadius: 0)
      );
      
      shapeView.borderStyle = .init(
        lineWidth: 8,
        strokeColor: self.colorThemeConfig.colorBgAccent
      );
      
      let checkerBoardImage = UIImage(named: "checker_board_pattern_5x5");
      let shapeBgImage = UIImageView(image: checkerBoardImage);
      shapeBgImage.contentMode = .scaleAspectFit;
      shapeBgImage.transform = .init(scaleX: 1.25, y: 1.25);
      
      shapeView.addSubview(shapeBgImage);
      shapeBgImage.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeBgImage.topAnchor.constraint(
          equalTo: shapeView.topAnchor
        ),
        shapeBgImage.bottomAnchor.constraint(
          equalTo: shapeView.bottomAnchor
        ),
        shapeBgImage.leadingAnchor.constraint(
          equalTo: shapeView.leadingAnchor
        ),
        shapeBgImage.trailingAnchor.constraint(
          equalTo: shapeView.trailingAnchor
        ),
      ]);
      
      shapeContainer.addSubview(shapeView);
      shapeView.translatesAutoresizingMaskIntoConstraints = false;
      shapeContainer.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeContainer.widthAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeContainer.heightAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeView.widthAnchor.constraint(
          equalTo: shapeContainer.widthAnchor
        ),
        shapeView.heightAnchor.constraint(
          equalTo: shapeContainer.heightAnchor
        ),
        shapeView.centerXAnchor.constraint(
          equalTo: shapeContainer.centerXAnchor
        ),
        shapeView.centerYAnchor.constraint(
          equalTo: shapeContainer.centerYAnchor
        ),
      ]);
      
      /// shape
      cardContentItems.append(
        .view(shapeContainer)
      );
      
      /// rotate
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: 360,
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let nextValue = CGFloat(control.value);
            
            cardVC.setInjectedValue(
              forKey: "shapeTransformRotate",
              value: nextValue
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let cornerRadiusAmount: CGFloat = cardVC.getInjectedValue(
              forKey: "cornerRadiusAmount",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              polygonPreset: .regularPolygon(numberOfSides: numberOfSidesCount),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(
                  rotateZ: .degrees(nextValue)
                )
              ),
              pointConnectionStrategy: .roundedCornersUniform(
                cornerRadius: cornerRadiusAmount
              )
            );
          }
        )
      );
      
      /// corner radius
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: 30,
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let nextValue = CGFloat(control.value);
            
            cardVC.setInjectedValue(
              forKey: "cornerRadiusAmount",
              value: nextValue
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              polygonPreset: .regularPolygon(numberOfSides: numberOfSidesCount),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(
                  rotateZ: .degrees(shapeTransformRotate)
                )
              ),
              pointConnectionStrategy: .roundedCornersUniform(
                cornerRadius: nextValue
              )
            );
          }
        )
      );
      
      // number of sides
      cardContentItems.append(
        .stepper(
          minValue: 3,
          maxValue: 10,
          initialValue: 3,
          title: [
            .init(text: "# of sides:")
          ],
          onValueChanged: { _, control in
            cardVC.setInjectedValue(
              forKey: "numberOfSidesCount",
              value: Int(control.value)
            );
            
            let cornerRadiusAmount: CGFloat = cardVC.getInjectedValue(
              forKey: "cornerRadiusAmount",
              fallbackValue: 0.0
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              polygonPreset: .regularPolygon(numberOfSides: Int(control.value)),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(
                  rotateZ: .degrees(shapeTransformRotate)
                )
              ),
              pointConnectionStrategy: .roundedCornersUniform(
                cornerRadius: cornerRadiusAmount
              )
            );
          }
        )
      );
      
      cardContentItems.append(
        .filledButton(
          title: [.init(text: "Animation Test")],
          handler: { _, _ in
            let cornerRadiusAmount: CGFloat = cardVC.getInjectedValue(
              forKey: "cornerRadiusAmount",
              fallbackValue: 0.0
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let shapeAnimationController = ShapeAnimationTestController();
            
            shapeAnimationController.maskShapeConfigStart = .regularPolygon(
              numberOfSides: numberOfSidesCount,
              pointConnectionStrategy: .roundedCornersUniform(
                cornerRadius: 0.01
              ),
              pointAdjustments: .scaleToFit
            );
            
            shapeAnimationController.maskShapeConfigEnd = .regularPolygon(
              numberOfSides: numberOfSidesCount,
              pointConnectionStrategy: .roundedCornersUniform(
                cornerRadius: cornerRadiusAmount
              ),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(
                  rotateZ: .degrees(shapeTransformRotate)
                )
              )
            );
            
            shapeAnimationController.endTransform = .init(
              rotateZ: .degrees(shapeTransformRotate)
            );
            
            self.present(shapeAnimationController, animated: true);
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "Regular Polygon",
        subtitle: "roundedCornersUniform",
        desc: [],
        colorThemeConfig: self.colorThemeConfig,
        content: cardContentItems
      );
      
      return cardVC;
    }());
    
    // MARK: regular star polygon (`roundedCornersUniform`)
    cardControllers.append({
      let shapeSize: CGFloat = 100;
      let spaceBetweenControls: CGFloat = 6;
      
      let starOuterRadius = shapeSize / 2;
      let starInnerRadiusDefault = starOuterRadius / 4;

      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      let shapeContainer = UIView();
      let shapeView = ShapeView();
      
      shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
        numberOfSpikes: 3,
        innerRadius: starInnerRadiusDefault,
        spikeRadius: starOuterRadius,
        innerCornerRadius: 0,
        spikeCornerRadius: 0,
        pointAdjustments: .init(
          shouldScaleToFitTargetRect: true,
          shouldPreserveAspectRatioWhenScaling: true,
          pathTransform: .init(rotateZ: .degrees(0))
        )
      );
      
      shapeView.borderStyle = .init(
        lineWidth: 8,
        strokeColor: self.colorThemeConfig.colorBgAccent
      );
      
      let checkerBoardImage = UIImage(named: "checker_board_pattern_5x5");
      let shapeBgImage = UIImageView(image: checkerBoardImage);
      shapeBgImage.contentMode = .scaleAspectFit;
      shapeBgImage.transform = .init(scaleX: 1.25, y: 1.25);
      
      shapeView.addSubview(shapeBgImage);
      shapeBgImage.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeBgImage.topAnchor.constraint(
          equalTo: shapeView.topAnchor
        ),
        shapeBgImage.bottomAnchor.constraint(
          equalTo: shapeView.bottomAnchor
        ),
        shapeBgImage.leadingAnchor.constraint(
          equalTo: shapeView.leadingAnchor
        ),
        shapeBgImage.trailingAnchor.constraint(
          equalTo: shapeView.trailingAnchor
        ),
      ]);
      
      shapeContainer.addSubview(shapeView);
      shapeView.translatesAutoresizingMaskIntoConstraints = false;
      shapeContainer.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeContainer.widthAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeContainer.heightAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeView.widthAnchor.constraint(
          equalTo: shapeContainer.widthAnchor
        ),
        shapeView.heightAnchor.constraint(
          equalTo: shapeContainer.heightAnchor
        ),
        shapeView.centerXAnchor.constraint(
          equalTo: shapeContainer.centerXAnchor
        ),
        shapeView.centerYAnchor.constraint(
          equalTo: shapeContainer.centerYAnchor
        ),
      ]);
      
      /// shape
      cardContentItems.append(
        .view(shapeContainer)
      );
      
      cardContentItems.append(
        .labelSubHeading(items: [
          .init(text: "Rotate:")
        ])
      );
      
      /// rotate
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: 360,
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let shapeTransformRotate = CGFloat(control.value);
            cardVC.setInjectedValue(
              forKey: "shapeTransformRotate",
              value: shapeTransformRotate
            );
            
            let starInnerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "starInnerRadius",
              fallbackValue: starInnerRadiusDefault
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let innerCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "innerCornerRadius",
              fallbackValue: 0.0
            );
            
            let spikeCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "spikeCornerRadius",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius,
              spikeRadius: starOuterRadius,
              innerCornerRadius: innerCornerRadius,
              spikeCornerRadius: spikeCornerRadius,
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      cardContentItems += [
        .spacer(space: spaceBetweenControls),
        .labelSubHeading(items: [
          .init(text: "Star Inner Radius:")
        ])
      ];
      
      /// inner radius
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: .init(starOuterRadius),
          initialValue: .init(starInnerRadiusDefault),
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let starInnerRadius = CGFloat(control.value);
            cardVC.setInjectedValue(
              forKey: "starInnerRadius",
              value: starInnerRadius
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let innerCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "innerCornerRadius",
              fallbackValue: 0.0
            );
            
            let spikeCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "spikeCornerRadius",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius,
              spikeRadius: starOuterRadius,
              innerCornerRadius: innerCornerRadius,
              spikeCornerRadius: spikeCornerRadius,
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      cardContentItems += [
        .spacer(space: spaceBetweenControls),
        .labelSubHeading(items: [
          .init(text: "Spike Corner Radius:")
        ]),
      ];
      
      /// `spikeCornerRadius`
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: .init(starOuterRadius),
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let spikeCornerRadius = CGFloat(control.value);
            cardVC.setInjectedValue(
              forKey: "spikeCornerRadius",
              value: spikeCornerRadius
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let starInnerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "starInnerRadius",
              fallbackValue: starInnerRadiusDefault
            );
            
            let innerCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "innerCornerRadius",
              fallbackValue: 0.0
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius,
              spikeRadius: starOuterRadius,
              innerCornerRadius: innerCornerRadius,
              spikeCornerRadius: spikeCornerRadius,
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      cardContentItems += [
        .spacer(space: spaceBetweenControls),
        .labelSubHeading(items: [
          .init(text: "Inner Corner Radius:")
        ]),
      ];
      
      /// `innerCornerRadius`
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: .init(starOuterRadius),
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let innerCornerRadius = CGFloat(control.value);
            cardVC.setInjectedValue(
              forKey: "innerCornerRadius",
              value: innerCornerRadius
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let starInnerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "starInnerRadius",
              fallbackValue: starInnerRadiusDefault
            );
            
            let spikeCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "spikeCornerRadius",
              fallbackValue: 0.0
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius,
              spikeRadius: starOuterRadius,
              innerCornerRadius: innerCornerRadius,
              spikeCornerRadius: spikeCornerRadius,
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      // number of sides
      cardContentItems.append(
        .stepper(
          minValue: 3,
          maxValue: 10,
          initialValue: 3,
          title: [
            .init(text: "# of spikes:")
          ],
          onValueChanged: { _, control in
          
            let numberOfSidesCount = Int(control.value);
            cardVC.setInjectedValue(
              forKey: "numberOfSidesCount",
              value: numberOfSidesCount
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let starInnerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "starInnerRadius",
              fallbackValue: starInnerRadiusDefault
            );
            
            let spikeCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "spikeCornerRadius",
              fallbackValue: 0.0
            );
            
            let innerCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "innerCornerRadius",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius,
              spikeRadius: starOuterRadius,
              innerCornerRadius: innerCornerRadius,
              spikeCornerRadius: spikeCornerRadius,
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      cardContentItems.append(
        .filledButton(
          title: [.init(text: "Animation Test")],
          handler: { _, _ in
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            let starInnerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "starInnerRadius",
              fallbackValue: starInnerRadiusDefault
            );
            
            let innerCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "innerCornerRadius",
              fallbackValue: 0.0
            );
            
            let spikeCornerRadius: CGFloat = cardVC.getInjectedValue(
              forKey: "spikeCornerRadius",
              fallbackValue: 0.0
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
          
            let shapeAnimationController = ShapeAnimationTestController();
            
            let startSize =
              shapeAnimationController.startSize.smallestDimension;
              
            let startRadius: CGFloat = startSize / 2;
            let minCornerRadius: CGFloat = 0.01;
            
            shapeAnimationController.maskShapeConfigStart = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: startRadius / 2.5,
              spikeRadius: startRadius,
              innerCornerRadius: minCornerRadius,
              spikeCornerRadius: minCornerRadius,
              pointAdjustments: .scaleToFit
            );
            
            let endSize = shapeAnimationController.endSize.smallestDimension;
            let endRadius = endSize / 2;
            let scaleMultiplier = endSize / startSize;
            
            shapeAnimationController.maskShapeConfigEnd = .regularStarPolygonWithRoundedCorners(
              numberOfSpikes: numberOfSidesCount,
              innerRadius: starInnerRadius * scaleMultiplier,
              spikeRadius: endRadius,
              innerCornerRadius: innerCornerRadius * scaleMultiplier,
              spikeCornerRadius: spikeCornerRadius * scaleMultiplier,
              pointAdjustments: .scaleToFit
            );
            
            shapeAnimationController.endTransform = .init(
              rotateZ: .degrees(shapeTransformRotate)
            );
            
            self.present(shapeAnimationController, animated: true);
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "Regular Star Polygon",
        subtitle: "roundedCornersUniform",
        desc: [],
        colorThemeConfig: self.colorThemeConfig,
        content: cardContentItems
      );
      
      return cardVC;
    }());
    
    // MARK: regular polygon (`continuousCurvedCorners`)
    cardControllers.append({
      let shapeSize: CGFloat = 100;
      let spaceBetweenControls: CGFloat = 6;
      
      let cardVC: CardViewController = .init(cardConfig: nil);
      var cardContentItems: [CardContentItem] = [];
      
      let shapeContainer = UIView();
      let shapeView = ShapeView();
      
      shapeView.maskShapeConfig = .regularPolygon(
        numberOfSides: 3,
        pointConnectionStrategy: .continuousCurvedCorners(
          curvinessAmount: 0,
          curveHeightOffset: 0
        ),
        pointAdjustments: .init(
          shouldScaleToFitTargetRect: true,
          shouldPreserveAspectRatioWhenScaling: true,
          pathTransform: .init(rotateZ: .degrees(0))
        )
      );
      
      shapeView.borderStyle = .init(
        lineWidth: 8,
        strokeColor: self.colorThemeConfig.colorBgAccent
      );
      
      let checkerBoardImage = UIImage(named: "checker_board_pattern_5x5");
      let shapeBgImage = UIImageView(image: checkerBoardImage);
      shapeBgImage.contentMode = .scaleAspectFit;
      shapeBgImage.transform = .init(scaleX: 1.25, y: 1.25);
      
      shapeView.addSubview(shapeBgImage);
      shapeBgImage.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeBgImage.topAnchor.constraint(
          equalTo: shapeView.topAnchor
        ),
        shapeBgImage.bottomAnchor.constraint(
          equalTo: shapeView.bottomAnchor
        ),
        shapeBgImage.leadingAnchor.constraint(
          equalTo: shapeView.leadingAnchor
        ),
        shapeBgImage.trailingAnchor.constraint(
          equalTo: shapeView.trailingAnchor
        ),
      ]);
      
      shapeContainer.addSubview(shapeView);
      shapeView.translatesAutoresizingMaskIntoConstraints = false;
      shapeContainer.translatesAutoresizingMaskIntoConstraints = false;
      
      NSLayoutConstraint.activate([
        shapeContainer.widthAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeContainer.heightAnchor.constraint(
          equalToConstant: shapeSize
        ),
        shapeView.widthAnchor.constraint(
          equalTo: shapeContainer.widthAnchor
        ),
        shapeView.heightAnchor.constraint(
          equalTo: shapeContainer.heightAnchor
        ),
        shapeView.centerXAnchor.constraint(
          equalTo: shapeContainer.centerXAnchor
        ),
        shapeView.centerYAnchor.constraint(
          equalTo: shapeContainer.centerYAnchor
        ),
      ]);
      
      /// shape
      cardContentItems.append(
        .view(shapeContainer)
      );
      
      cardContentItems.append(
        .labelSubHeading(items: [
          .init(text: "Rotate:")
        ])
      );
      
      /// rotate
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: 360,
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let nextValue = CGFloat(control.value);
            
            cardVC.setInjectedValue(
              forKey: "shapeTransformRotate",
              value: nextValue
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let curvinessAmount: CGFloat = cardVC.getInjectedValue(
              forKey: "curvinessAmount",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              numberOfSides: numberOfSidesCount,
              pointConnectionStrategy: .continuousCurvedCorners(
                curvinessAmount: curvinessAmount,
                curveHeightOffset: 0
              ),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(nextValue))
              )
            );
          }
        )
      );
      
      cardContentItems += [
        .spacer(space: spaceBetweenControls),
        .labelSubHeading(items: [
          .init(text: "Curviness Amount:")
        ]),
      ];
      
      /// `curvinessAmount``
      cardContentItems.append(
        .slider(
          minValue: 0,
          maxValue: 1,
          initialValue: 0,
          valueLabelMinWidth: 50,
          onValueChanged: { _, control in
          
            let nextValue = CGFloat(control.value);
            
            cardVC.setInjectedValue(
              forKey: "curvinessAmount",
              value: nextValue
            );
            
            let numberOfSidesCount: Int = cardVC.getInjectedValue(
              forKey: "numberOfSidesCount",
              fallbackValue: 3
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              numberOfSides: numberOfSidesCount,
              pointConnectionStrategy: .continuousCurvedCorners(
                curvinessAmount: nextValue,
                curveHeightOffset: 0
              ),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
      
      // number of sides
      cardContentItems.append(
        .stepper(
          minValue: 3,
          maxValue: 10,
          initialValue: 3,
          title: [
            .init(text: "# of sides:")
          ],
          onValueChanged: { _, control in
            let nextValue = Int(control.value);
            cardVC.setInjectedValue(
              forKey: "numberOfSidesCount",
              value: nextValue
            );
            
            let curvinessAmount: CGFloat = cardVC.getInjectedValue(
              forKey: "curvinessAmount",
              fallbackValue: 0.0
            );
            
            let shapeTransformRotate: CGFloat = cardVC.getInjectedValue(
              forKey: "shapeTransformRotate",
              fallbackValue: 0.0
            );
            
            shapeView.maskShapeConfig = .regularPolygon(
              numberOfSides: nextValue,
              pointConnectionStrategy: .continuousCurvedCorners(
                curvinessAmount: curvinessAmount,
                curveHeightOffset: 0
              ),
              pointAdjustments: .init(
                shouldScaleToFitTargetRect: true,
                shouldPreserveAspectRatioWhenScaling: true,
                pathTransform: .init(rotateZ: .degrees(shapeTransformRotate))
              )
            );
          }
        )
      );
    
      cardVC.cardConfig = .init(
        title: "Regular Polygon",
        subtitle: "continuousCurvedCorners",
        desc: [],
        colorThemeConfig: self.colorThemeConfig,
        content: cardContentItems
      );
      
      return cardVC;
    }());

    self.cardControllers = cardControllers;
  };
  
  func refreshCardController(cardController cardVC: CardViewController){
    let match = self.cardControllers.first {
      $0 === cardVC;
    };
    
    guard let match = match else { return };
    match.applyCardConfig();
  };
};

fileprivate class ShapeAnimationTestController: UIViewController {
  
  var boxWrapperView: UIView!;
  var boxView: ShapeView!;
  
  var maskShapeConfigStart: ShapePreset!;
  var maskShapeConfigEnd: ShapePreset!;
  
  var startSize = CGSize(width: 75, height: 75);
  var startFrame: CGRect!;
  
  var endSize = CGSize(width: 250, height: 250);
  var endFrame: CGRect!;
  
  var endTransform: Transform3D!;
  
  override func viewDidLoad() {
    super.viewDidLoad();
    self.view.backgroundColor = .white;
      
    
    var startFrame = CGRect(origin: .zero, size: self.startSize);
    startFrame.setPoint(midX: self.view.bounds.midX);
    startFrame.setPoint(minY: 10);
    
    self.startFrame = startFrame;
    
    var endFrame = CGRect(origin: .zero, size: self.endSize);
    endFrame.setPoint(midX: self.view.bounds.midX);
    endFrame.setPoint(maxY: self.view.bounds.height - 100);
    
    self.endFrame = endFrame;
    
    let boxWrapperView = {
      let view = UIView();
      view.backgroundColor = .clear;
      view.frame = startFrame;
      view.backgroundColor = .black.withAlphaComponent(0.1);
      
      self.boxWrapperView = view;
      return view;
    }();
  
    let boxView: ShapeView = {
      let view = ShapeView();
      view.backgroundColor = .red;
      view.isExplicitlyBeingAnimated = false;
      
      view.maskShapeConfig = self.maskShapeConfigStart;
      
      view.borderStyle = .init(
        lineWidth: 6,
        strokeColor: .blue,
        linePattern:  .uniform(dashLength: 3, spacing: 0)
      );
      
      self.boxView = view;
      return view;
    }();
    
    boxWrapperView.addSubview(boxView);
    boxView.translatesAutoresizingMaskIntoConstraints = false;
  
    NSLayoutConstraint.activate([
      boxView.leadingAnchor.constraint(
        equalTo: boxWrapperView.leadingAnchor
      ),
      boxView.trailingAnchor.constraint(
        equalTo: boxWrapperView.trailingAnchor
      ),
      boxView.topAnchor.constraint(
        equalTo: boxWrapperView.topAnchor
      ),
      boxView.bottomAnchor.constraint(
        equalTo: boxWrapperView.bottomAnchor
      ),
    ]);
    
    self.view.addSubview(boxWrapperView);
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.beginAnimation();
    };
  };
  
  func beginAnimation(){
    boxWrapperView.layoutIfNeeded();
    boxView.layoutIfNeeded();
    
    print("Animation start\n");
    boxView.prepareForAnimation();
    
    UIView.animate(withDuration: 3, delay: 0) {
      self.boxView.backgroundColor = .yellow;
      self.boxView.maskShapeConfig = self.maskShapeConfigEnd;
      self.boxWrapperView.transform3D = self.endTransform.transform;
      
      self.boxView.borderStyle = .init(
        lineWidth: 8,
        strokeColor: .green,
        linePattern: .uniform(dashLength: 3, spacing: 4)
      );
      
      self.boxWrapperView.frame = self.endFrame;
      #if DEBUG
      self.boxView.debugLogViewInfo();
      #endif
      
    } completion: { _ in
      print("Animation end\n");
      
      self.view.setNeedsLayout();
      self.boxView.setNeedsLayout();
      self.boxWrapperView.setNeedsLayout();
      
      self.view.layoutIfNeeded();
      #if DEBUG
      self.boxView.debugLogViewInfo();
      #endif
    };
  };
};
