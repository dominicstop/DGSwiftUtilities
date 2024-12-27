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
  
  public var runloop: RunLoop;
  public var runloopMode: RunLoop.Mode;
  
  private weak var displayLinkTarget: DisplayLinkTarget?;
  public private(set) var displayLink: CADisplayLink;
  
  public var updateBlock: UpdateBlock?;
  public var startBlock: UpdateBlock?;
  public var endBlock: UpdateBlock?;
  
  public var isRunning: Bool = false;
  public var isExplicitlyPaused: Bool = false;
  
  public var timestampStart: CFTimeInterval;
  public var timestampFirstFrame: CFTimeInterval?;
  
  public var timestampPrevFrame: CFTimeInterval?;
  public var timestampLastFrame: CFTimeInterval?;
  
  public var frameCounter = 0;
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
    self.displayLink.isPaused || self.isExplicitlyPaused;
  };
  
  public init(
    withRunloop runloop: RunLoop = .main,
    runLoopMode: RunLoop.Mode = .common,
    shouldRetain: Bool = false,
    shouldImmediatelyStart: Bool = true,
  ) {
  
    self.runloop = runloop;
    self.runloopMode = runLoopMode;
  
    let target = DisplayLinkTarget(shouldRetainParent: shouldRetain);
    self.displayLinkTarget = target;
  
    let displayLink = CADisplayLink(
      target: target,
      selector: #selector(DisplayLinkTarget._updateBlock(_:))
    );
    
    self.timestampStart = CACurrentMediaTime();
    
    self.displayLink = displayLink;
    target.parent = self;
    
    if shouldImmediatelyStart {
      self.startIfNeeded();
    };
  };
  
  public convenience init(
    withRunloop runloop: RunLoop = .main,
    runLoopMode: RunLoop.Mode = .common,
    shouldRetain: Bool = false,
    shouldImmediatelyStart: Bool = true,
    updateBlock: @escaping UpdateBlock,
    startBlock: Optional<UpdateBlock> = nil,
    endBlock: Optional<UpdateBlock> = nil
  ) {
  
    self.init(
      withRunloop: runloop,
      runLoopMode: runLoopMode,
      shouldRetain: shouldRetain,
      shouldImmediatelyStart: false,
    );
    
    self.updateBlock = updateBlock;
    self.startBlock = startBlock;
    self.endBlock = endBlock;
    
    if shouldImmediatelyStart {
      self.startIfNeeded();
    };
  };
  
  deinit {
    self.stop();
  }
  public func startIfNeeded(){
    guard !self.isRunning else {
      return;
    };
    
    self.timestampStart = CACurrentMediaTime();
    
    self.displayLink.add(
      to: self.runloop,
      forMode: self.runloopMode
    );
    
    self.isRunning = true;
    self.startBlock?((self, displayLink));
  };
  
  public func stop(){
    self.isRunning = false;
    self.displayLink.invalidate();
    self.endBlock?((self, self.displayLink));
  };
  
  public func restart(){
    self.stop();

    self.timestampFirstFrame = nil;
    self.timestampPrevFrame = nil;
    self.timestampLastFrame = nil;
    
    self.frameCounter = 0;
    self.elapsedTime = 0;
    self.frameDuration = 0;
    
    self.startIfNeeded();
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
    
    // temp. pause timer
    if parent.shouldPauseUntilUpdateFinishes {
      sender.isPaused = true;
    };
    
    parent.updateBlock?((
      sender: parent,
      displayLink: sender
    ));
    
    parent.delegates.invoke {
      $0.notifyOnDisplayLinkTick(
        sender: parent,
        displayLink: sender
      );
    };
    
    // undo temp. pause (if not paused externally)
    if parent.shouldPauseUntilUpdateFinishes,
      !parent.isExplicitlyPaused
    {
      sender.isPaused = false;
    };
  };
}
