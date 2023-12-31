//
//  VerboseError.swift
//  react-native-ios-navigator
//
//  Created by Dominic Go on 9/11/21.
//

import Foundation


public struct VerboseError<
  Metadata: ErrorMetadata,
  Code: ErrorCode
>: LocalizedError {

  public var errorCode: Code?;
  public var description: String?;
  
  public var extraDebugValues: Dictionary<String, Any>?;
  public var extraDebugInfo: String?;

  public var filePath: String;
  public var lineNumber: Int;
  public var columnNumber: Int;
  public var functionName: String;
  
  public var stackTrace: [String]?;
  
  // MARK: - Computed Properties
  // ---------------------------
  
  public var debugMetadata: String {
    let fileURL: URL? = Metadata.shouldLogFileMetadata
      ? .init(fileURLWithPath: self.filePath)
      : nil;
    
    var string = "";
  
    string += "functionName: \(self.functionName)";
    string += " - lineNumber: \(self.lineNumber)";
    string += " - columnNumber: \(self.columnNumber)";
    
    if let fileURL = fileURL {
      string += " - fileName: \(fileURL.lastPathComponent)";
    };
    
    if Metadata.shouldLogFilePath {
      string += " - path: \(self.filePath)";
    };
    
    if let parentType = Metadata.parentType {
      string += " - type: \(parentType)";
    };
    
    return string;
  };
  
  public var debugStackTrace: String? {
    guard let stackTrace = self.stackTrace else { return nil };

    return stackTrace.enumerated().reduce(""){
      let isFirst = $1.offset == 0;
      return isFirst
        ? $0 + $1.element
        : "\($0) - \($1.element)"
    };
  };
  
  var extraDebugValuesString: String? {
    guard let extraDebugValues = self.extraDebugValues else { return nil };
    
    let items = extraDebugValues.enumerated().map {
      var string = "\($0.element.key): \($0.element.value)";
      
      let isLastItem = ($0.offset == extraDebugValues.count - 1);
      string += isLastItem ? "" : ", ";
      
      return string;
    };
    
    let itemsString = items.reduce("") {
      $0 + $1;
    };
    
    return "extraDebugValuesString: { \(itemsString) }";
  };
  
  public var baseErrorMessage: String {
    var strings: [String] = [];
    
    if let domain = Metadata.domain {
      strings.append("domain: \(domain)");
    };
  
    if let errorCode = self.errorCode {
      strings.append("code: \(errorCode.rawValue)");
    };
    
    if let description = self.description {
      strings.append("description: \(description)");
    };
  
    if let extraDebugInfo = self.extraDebugInfo {
      strings.append("extraDebugInfo: \(extraDebugInfo)");
    };
    
    if let extraDebugValuesString = self.extraDebugValuesString {
      strings.append("extraDebugValues: \(extraDebugValuesString)");
    };
    
    return strings.enumerated().reduce("") { acc, next in
      let prefix = next.offset > 0 ? " - " : "";
      return acc + prefix + next.element;
    };
  };
  
  public var errorDescription: String? {
    var message =
      "Error: \(self.baseErrorMessage)"
    + " - Error Metadata: \(self.debugMetadata)";
    
    if let debugStackTrace = self.debugStackTrace {
      message += " - Stack Trace: \(debugStackTrace)";
    };
    
    return debugStackTrace;
  };
  
  // MARK: - Init
  // ------------
  
  public init(
    description: String?,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function,
    stackTrace: [String]? = Metadata.shouldLogStackTrace
      ? Thread.callStackSymbols
      : nil
  ) {
  
    self.description = description;
    
    self.extraDebugValues = extraDebugValues;
    self.extraDebugInfo = extraDebugInfo;
    
    self.filePath = fileName;
    self.lineNumber = lineNumber;
    self.columnNumber = columnNumber;
    self.functionName = functionName;
    
    self.stackTrace = stackTrace;
  };
  
  public init(
    errorCode: Code,
    description: String? = nil,
    extraDebugValues: Dictionary<String, Any>? = nil,
    extraDebugInfo: String? = nil,e
    fileName: String = #file,
    lineNumber: Int = #line,
    columnNumber: Int = #column,
    functionName: String = #function,
    stackTrace: [String]? = Metadata.shouldLogStackTrace
      ? Thread.callStackSymbols
      : nil
  ) {
    
    self.init(
      description: description ?? errorCode.description,
      extraDebugValues: extraDebugValues,
      extraDebugInfo: extraDebugInfo,
      fileName: fileName,
      lineNumber: lineNumber,
      columnNumber: columnNumber,
      functionName: functionName,
      stackTrace: stackTrace
    );
    
    self.errorCode = errorCode;
  };
  
  // MARK: - Functions
  // -----------------
  
  public func log(){
    #if DEBUG
    guard let errorDescription = self.errorDescription else { return };
    print("Error -", errorDescription);
    #endif
  };
};
