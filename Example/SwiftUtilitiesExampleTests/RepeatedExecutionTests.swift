//
//  RepeatedExecutionTests.swift
//  SwiftUtilitiesExample
//
//  Created by Dominic Go on 7/26/25.
//

import Testing
@testable @preconcurrency import DGSwiftUtilities
import Foundation


struct RepeatedExecutionTests {

  @Test func test_initialState() async throws {
    let execution = RepeatedExecution(
      limit: .noLimit,
      debounce: .minTimeInterval(0.1),
      executeBlock: { _ in },
      executionEndConditionBlock: { _ in false }
    );

    #expect(execution.state == .idle);
    #expect(execution.iterationCount == 0);
  };

  @Test func test_startAndEnd() async throws {
    let execution = RepeatedExecution(
      limit: .maxIterations(1),
      debounce: .minTimeInterval(0.01),
      executeBlock: { _ in },
      executionEndConditionBlock: { _ in false }
    );

    execution.start();
    try await Task.sleep(nanoseconds: 50_000_000); // 50ms
    #expect(execution.state != .idle);

    execution.end(successfully: true);
    #expect(execution.state == .endedSuccessfully);
  };

  @Test func test_maxIterationsLimit() async throws {
    var count = 0;

    let execution = RepeatedExecution(
      limit: .maxIterations(3),
      debounce: .minTimeInterval(0.01),
      executeBlock: { _ in count += 1 },
      executionEndConditionBlock: { _ in false }
    );

    execution.start();
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      #expect(execution.iterationCount == 3);
      #expect(execution.state == .endedPrematurely);
    };
  };

  @Test func test_maxTimeIntervalLimit() async throws {
    var count = 0;

    let execution = RepeatedExecution(
      limit: .maxTimeInterval(0.1),
      debounce: .minTimeInterval(0.01),
      executeBlock: { _ in count += 1 },
      executionEndConditionBlock: { _ in false }
    );

    execution.start();
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      #expect(execution.iterationCount > 0);
      #expect(execution.timestampTotalExecutionDuration <= 0.2);
      #expect(execution.state == .endedPrematurely);
    };
  };

  @Test func test_customConditionLimit() async throws {
    var count = 0;

    let execution = RepeatedExecution(
      limit: .customCondition({ $0.iterationCount >= 5 }),
      debounce: .minTimeInterval(0.01),
      executeBlock: { _ in count += 1 },
      executionEndConditionBlock: { _ in false }
    );

    execution.start();
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      #expect(count == 5);
      #expect(execution.state == .endedPrematurely);
    };
  };

  @Test func test_executionEndConditionBlock() async throws {
    var count = 0;

    let execution = RepeatedExecution(
      limit: .noLimit,
      debounce: .minTimeInterval(0.01),
      executeBlock: { _ in count += 1 },
      executionEndConditionBlock: { $0.iterationCount >= 4 }
    );

    execution.start();
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      #expect(count == 4);
      #expect(execution.state == .endedSuccessfully);
    };
  };
}
