//
//  InLineDisplayLink.swift
//  
//
//  Created by Dominic Go on 12/27/24.
//

import Foundation
import QuartzCore


public class InLineDisplayLink {

  public typealias Context = (
    sender: InLineDisplayLink,
    displayLink: CADisplayLink
  );

  public typealias UpdateBlock = (_ context: Context) -> Void;
  
  private weak var displayLinkTarget: DisplayLinkTarget?;
  
  public var updateBlock: UpdateBlock?;
  public var startBlock: UpdateBlock?;
  public var endBlock: UpdateBlock?;
  
  public private(set) var displayLink: CADisplayLink;
  
  public var isRunning: Bool = false;
  public var frameCounter = 0;
  
  public var timestampStart: CFTimeInterval;
  public var timestampFirstFrame: CFTimeInterval?;
  
  public var timestampPrevFrame: CFTimeInterval?;
  public var timestampLastFrame: CFTimeInterval?;
  
  public var elapsedTime: TimeInterval = 0;
  public var frameDuration: TimeInterval = 0;
  
  public var shouldPauseUntilUpdateFinishes: Bool = false;
  public var frameTimestampDelta: TimeInterval {
    guard let timestampLastFrame = self.timestampLastFrame,
          let timestampPrevFrame = self.timestampPrevFrame
    else {
      return 0;
    };
    
    return timestampLastFrame - timestampPrevFrame;
  };
  
  public var isPaused: Bool {
    self.displayLink.isPaused;
  };
  
  public init(
    withRunloop runloop: RunLoop = .main,
    runLoopMode: RunLoop.Mode = .common,
    shouldRetain: Bool = false
  ) {
    let target = DisplayLinkTarget(
      shouldRetainParent: shouldRetain
    );
    
    self.displayLinkTarget = target;
  
    let displayLink = CADisplayLink(
      target: target,
      selector: #selector(DisplayLinkTarget._updateBlock(_:))
    );
    
    self.timestampStart = CACurrentMediaTime();
    
    self.displayLink = displayLink;
    target.parent = self;
    
    displayLink.add(to: runloop, forMode: runLoopMode);
  };
  
  public convenience init(
    withRunloop runloop: RunLoop = .main,
    runLoopMode: RunLoop.Mode = .common,
    shouldRetain: Bool = false,
    updateBlock: @escaping UpdateBlock,
    startBlock: Optional<UpdateBlock> = nil,
    endBlock: Optional<UpdateBlock> = nil
  ) {
    self.init(
      withRunloop: runloop,
      runLoopMode: runLoopMode,
      shouldRetain: shouldRetain
    );
  
    self.displayLink = displayLink;
    self.updateBlock = updateBlock;
    self.startBlock = startBlock;
    self.endBlock = endBlock;
    
    startBlock?((self, displayLink));
  };
  
  deinit {
    self.stop();
  }
  
  public func stop(){
    self.displayLink.invalidate();
    self.isRunning = false;
    self.endBlock?((self, self.displayLink));
  };
  
  public func restart(
    withRunloop runloop: RunLoop = .main,
    runLoopMode: RunLoop.Mode = .common
  ){
    self.stop();
    
    self.timestampStart = CACurrentMediaTime();
    self.timestampFirstFrame = nil;
    self.timestampPrevFrame = nil;
    self.timestampLastFrame = nil;
    
    self.frameCounter = 0;
    self.elapsedTime = 0;
    self.frameDuration = 0;
    
    self.startBlock?((self, self.displayLink));
    self.displayLink.add(to: runloop, forMode: runLoopMode);
  };
  
  public func pause() {
    self.displayLink.isPaused = true;
  }
  
  public func resume() {
    self.displayLink.isPaused = false;
  }
}

/// Retained by CADisplayLink.
fileprivate class DisplayLinkTarget {
  
  weak var _parentWeak: InLineDisplayLink?;
  var _parentStrong: InLineDisplayLink?;
  
  var shouldRetainParent: Bool;
  var parent: InLineDisplayLink? {
    set {
      if self.shouldRetainParent {
        self._parentStrong = newValue;
        
      } else {
        self._parentWeak = newValue
      };
    }
    get {
      self._parentWeak ?? self._parentStrong;
    }
  };
  
  init(
    parent: InLineDisplayLink? = nil,
    shouldRetainParent: Bool
  ) {
    self.shouldRetainParent = shouldRetainParent;
    self.parent = parent;
  };
  
  @objc func _updateBlock(_ sender: CADisplayLink) {
    guard let parent = self.parent else {
      return;
    };
    
    if !parent.isRunning {
      parent.isRunning = false;
    };
    
    if parent.timestampFirstFrame == nil {
      parent.timestampFirstFrame = sender.timestamp;
    };
    
    let prevFrame = parent.timestampLastFrame;
    parent.timestampPrevFrame = prevFrame;
    
    parent.frameCounter += 1;
    parent.timestampLastFrame = sender.timestamp;
    
    let elapsedTime = sender.timestamp - parent.timestampFirstFrame!;
    parent.elapsedTime = elapsedTime;
    
    let frameDuration = sender.targetTimestamp - sender.timestamp;
    parent.frameDuration = frameDuration;
    
    if parent.shouldPauseUntilUpdateFinishes {
      sender.isPaused = true;
    };
    
    parent.updateBlock?((
      sender: parent,
      displayLink: sender
    ));
    
    if parent.shouldPauseUntilUpdateFinishes {
      sender.isPaused = false;
    };
  };
}
