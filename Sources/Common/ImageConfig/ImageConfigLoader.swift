//
//  ImageConfigParser.swift
//  
//
//  Created by Dominic Go on 8/7/24.
//

import UIKit


public final class ImageConfigLoader {

  public typealias `Self` = ImageConfigLoader;
  
  public static var imageLoadMaxAttemptsDefault: Int = 3;
  
  public var eventDelegates:
    MulticastDelegate<ImageConfigLoaderEventsNotifiable> = .init();
  
  public var imageConfig: ImageConfig;
  
  public var dispatchQosDefault: DispatchQoS.QoSClass = .background;
  
  private(set) public var imageLoadAttemptCount = 0;
  public var imageLoadMaxAttemptsOverride: Int?;
  
  public init(imageConfig: ImageConfig) {
    self.imageConfig = imageConfig;
  };
};


// MARK: - ImageConfigLoader+ComputedProperties
// --------------------------------------------

public extension ImageConfigLoader {
  
  var imageType: String {
    type(of: self.imageConfig).imageType;
  };
  
  var isImageLoading: Bool {
    self.imageConfig.isImageLoaded;
  };
  
  var cachedImage: UIImage? {
    self.imageConfig.cachedImage;
  };
  
  var imageLoadMaxAttempts: Int {
       self.imageLoadMaxAttemptsOverride
    ?? Self.imageLoadMaxAttemptsDefault;
  };
};

// MARK: - ImageConfigLoader+PublicMethods
// ---------------------------------------

public extension ImageConfigLoader {
  typealias CompletionHandler = (_ sender: Self) -> Void;

  func resetImageLoadAttemptCount(){
    self.imageLoadAttemptCount = 0;
  };
  
  func loadImageIfNeeded(
    dispatchQos dispatchQosOverride: DispatchQoS.QoSClass? = nil,
    completion: CompletionHandler? = nil
    // useSharedQueue: Bool = false
  ) {
    guard !self.imageConfig.isImageLoaded else { return };
    
    self.imageConfig.isImageLoading = true;
    self.imageLoadAttemptCount += 1;
    
    self.eventDelegates.invoke {
      $0.notifyOnImageWillLoad(sender: self);
    };
    
    let dispatchQoS = dispatchQosOverride ?? self.dispatchQosDefault;
    
    DispatchQueue.global(qos: dispatchQoS).async {
      var imageConfigCopy = self.imageConfig;
      
      let image = try? imageConfigCopy.makeImage();
      imageConfigCopy.cachedImage = image;
      imageConfigCopy.isImageLoading = false;
      
      DispatchQueue.main.async {
        self.imageConfig = imageConfigCopy;
        
        completion?(self);
        self.eventDelegates.invoke {
          $0.notifyOnImageDidLoad(sender: self);
        };
      }
    };
  };
};
