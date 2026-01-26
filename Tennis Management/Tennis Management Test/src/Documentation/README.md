# Tennis Management Test App

## Overview

This test app provides comprehensive testing coverage for the Tennis Management solution, including unit tests, integration tests, performance tests, and regression tests.

## Project Structure

```
📁 src/
├── 📁 Codeunit/
│   ├── 📁 Library/
│   │   └── LibraryTennisTest.Codeunit.al          # Test utility functions and helpers
│   ├── 📁 TestRunners/
│   │   ├── TennisTestRunner.Codeunit.al           # Main test orchestrator
│   │   ├── TennisSmokeTestRunner.Codeunit.al      # Quick validation tests
│   │   ├── TennisPerformanceTestRunner.Codeunit.al # Performance testing
│   │   ├── TennisRegressionTestRunner.Codeunit.al  # Critical scenario testing
│   │   └── TennisIntegrationTestRunner.Codeunit.al # End-to-end testing
│   └── 📁 UnitTests/
│       ├── TennisPlayerTest.Codeunit.al           # Player functionality tests
│       ├── TennisMatchTest.Codeunit.al            # Match functionality tests
│       ├── TennisMatchLineTest.Codeunit.al        # Match line tests
│       ├── TennisSetupTest.Codeunit.al            # Setup and configuration tests
│       ├── TennisPageTest.Codeunit.al             # Page interaction tests
│       ├── TennisAPITest.Codeunit.al              # API endpoint tests
│       ├── TennisReportXMLportTest.Codeunit.al    # Report and XMLport tests
│       ├── TennisInstallTest.Codeunit.al          # Installation tests
│       └── TennisAssistedSetupTest.Codeunit.al    # Assisted setup tests
└── 📁 Documentation/
    ├── README.md                                  # This file
    └── TestingStrategy.md                         # Testing methodology and guidelines
```

## Test Categories

### 🏃‍♂️ Test Runners (Orchestration)
- **TennisTestRunner**: Main orchestrator that runs all test categories
- **TennisSmokeTestRunner**: Quick validation tests for basic functionality
- **TennisPerformanceTestRunner**: Performance testing with large datasets
- **TennisRegressionTestRunner**: Critical scenarios that must not break
- **TennisIntegrationTestRunner**: End-to-end workflow testing

### 🧪 Unit Tests (Component Testing)
- **TennisPlayerTest**: Player creation, validation, modification
- **TennisMatchTest**: Match lifecycle, status transitions
- **TennisMatchLineTest**: Player-match assignments, teams, winners
- **TennisSetupTest**: System configuration and number series
- **TennisPageTest**: UI page interactions and validations
- **TennisAPITest**: API endpoints and data access
- **TennisReportXMLportTest**: Report generation and data export
- **TennisInstallTest**: App installation and upgrade scenarios
- **TennisAssistedSetupTest**: Guided setup workflows

### 🛠️ Library (Utilities)
- **LibraryTennisTest**: Shared test utilities and helper functions

## Running Tests

### Quick Validation (Smoke Tests)
```al
// Run smoke tests for basic functionality validation
TennisSmokeTestRunner.RunSmokeTestSuite();
```

### Complete Test Suite
```al
// Run all tests (unit, integration, performance, regression)
TennisTestRunner.RunAllTennisTests();
```

### Specific Test Categories
```al
// Run only player-related tests
TennisTestRunner.RunPlayerTests();

// Run only performance tests
TennisPerformanceTestRunner.RunPerformanceTestSuite();

// Run only regression tests
TennisRegressionTestRunner.RunRegressionTestSuite();
```

### Individual Component Tests
```al
// Test specific functionality
TennisPlayerTest.TestTennisPlayerCreation();
TennisMatchTest.TestTennisMatchCreation();
```

## Test Data Management

All test runners use the `LibraryTennisTest` library for:
- Creating consistent test data
- Setting up test environments
- Cleaning up after tests
- Providing reusable test utilities

## Performance Testing

The performance test runner includes:
- **Bulk Operations**: Testing with 100+ players and 50+ matches
- **Large Dataset Reporting**: Report generation with substantial data
- **Data Deletion Performance**: Cleanup operation efficiency
- **API Query Performance**: Large dataset query optimization

## Best Practices

1. **Test Isolation**: Each test should be independent and not rely on other tests
2. **Data Cleanup**: Use `LibraryTennisTest` utilities for consistent cleanup
3. **Meaningful Assertions**: Provide clear error messages in test assertions
4. **Performance Benchmarks**: Include timing validations in performance tests
5. **Regression Coverage**: Add new tests for any bug fixes to prevent regression

## Continuous Integration

These tests are designed to be run in CI/CD pipelines:
- **Smoke tests**: Run on every commit (fast feedback)
- **Full test suite**: Run on pull requests and releases
- **Performance tests**: Run on release candidates
- **Regression tests**: Run on critical deployments

## Contributing

When adding new tests:
1. Place unit tests in the appropriate `UnitTests/` subfolder
2. Add orchestration logic to relevant test runners
3. Use `LibraryTennisTest` for test data creation
4. Follow existing naming conventions
5. Update this documentation for new test categories

## Dependencies

This test app depends on:
- Tennis Management App (main application under test)
- Business Central Test Framework
- Standard AL Test Libraries

## Troubleshooting

Common issues and solutions:
- **Test Data Conflicts**: Ensure proper cleanup using `LibraryTennisTest.CleanupTestData()`
- **Permission Issues**: Verify `TestPermissions = Disabled` on all test codeunits
- **Number Series Conflicts**: Use test-specific number series ranges
- **Performance Test Timeouts**: Adjust timeout values for slower environments