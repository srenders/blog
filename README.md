# Tennis Management Test App

A comprehensive test suite for the Tennis Management Business Central extension, providing automated testing for all major functionality including tables, pages, APIs, reports, and XMLports.

## Overview

The Tennis Management Test app is a dedicated test extension that validates the functionality of the Tennis Management app. It follows Business Central testing best practices and provides comprehensive coverage of all business logic, user interfaces, and data operations.

## Dependencies

- **Tennis Management App** (ID: f7b56103-2333-4b4c-bc9c-de75b3cfa620)
  - Publisher: Tennis Solutions
  - Version: 1.0.0.0

## Object Range

- **Test Objects**: 51100 - 51149
- **Platform**: Business Central 25.0.0.0
- **Runtime**: 14.0

## Test Structure

### Library Codeunit
- **`LibraryTennisTest.Codeunit.al`** (ID: 51101)
  - Central test data creation and management
  - Setup utilities for consistent test environments
  - Helper functions for creating players, matches, and configurations

### Test Categories

#### 1. Table Tests
Validate core data structures and business logic:

- **`TennisPlayerTest.Codeunit.al`** (ID: 51100)
  - Player creation and number series validation
  - Field validation (name, phone, email, date of birth)
  - Flow field calculations (total matches, wins, losses)
  - AssistEdit functionality

- **`TennisMatchTest.Codeunit.al`** (ID: 51102)
  - Match creation with automatic numbering
  - Status transitions (Open → Finished → Cancelled)
  - Field validation and custom number handling

- **`TennisMatchLineTest.Codeunit.al`** (ID: 51103)
  - Match line creation and player association
  - Winner/loser logic validation
  - Singles and doubles match scenarios
  - Team assignment verification

- **`TennisSetupTest.Codeunit.al`** (ID: 51104)
  - Setup record creation and singleton pattern
  - Number series configuration validation
  - Setup modification scenarios

#### 2. Business Logic Tests
Test setup, installation, and configuration logic:

- **`TennisAssistedSetupTest.Codeunit.al`** (ID: 51105)
  - Assisted setup registration and completion
  - Setup completeness validation
  - Configuration state verification

- **`TennisInstallTest.Codeunit.al`** (ID: 51106)
  - Number series structure validation
  - Installation data integrity checks
  - Setup dependencies verification

#### 3. API Tests
Validate web service endpoints and data exposure:

- **`TennisAPITest.Codeunit.al`** (ID: 51107)
  - Tennis Players API query validation
  - Tennis Matches API query validation
  - Tennis Match Lines API query validation
  - Flow field calculations in API responses

#### 4. User Interface Tests
Test page functionality and user interactions:

- **`TennisPageTest.Codeunit.al`** (ID: 51108)
  - Tennis Player Card and List pages
  - Tennis Match Card and List pages
  - Tennis Management Setup page
  - New record creation workflows
  - Page navigation and data display

#### 5. Reports and Data Exchange Tests
Validate reporting and import/export functionality:

- **`TennisReportXMLportTest.Codeunit.al`** (ID: 51109)
  - Tennis Players and Matches report generation
  - Report filtering and data accuracy
  - Tennis Player XMLport export functionality
  - XML import validation and duplicate handling

## Key Testing Features

### Comprehensive Coverage
- ✅ All table operations (CRUD)
- ✅ Business rule validation
- ✅ User interface functionality
- ✅ API endpoint validation
- ✅ Report generation and filtering
- ✅ Data import/export operations

### Automated Test Data Management
- Consistent test environment setup
- Automatic cleanup between tests
- Realistic test data generation
- Number series management

### Business Rule Validation
- Winner/loser assignment logic
- Flow field calculations
- Number series handling
- Data validation rules

### Integration Testing
- Cross-table relationships
- Page-to-table integration
- API-to-table consistency
- Report data accuracy

## Running the Tests

### Prerequisites
1. Business Central Development Environment
2. Tennis Management app installed
3. Test framework enabled

### Execution Methods

#### Using VS Code
1. Open the Tennis Management Test workspace
2. Use Command Palette: `AL: Run Tests`
3. Select specific test codeunits or run all tests

#### Using Test Tool
1. Navigate to the Test Tool page in Business Central
2. Load the Tennis Management Test suite
3. Execute individual tests or full suite

#### Command Line
```powershell
# Run all tests
Invoke-ALTestRunner -TestSuite "Tennis Management Test"

# Run specific test codeunit
Invoke-ALTestRunner -TestCodeunit "Tennis Player Test"
```

## Test Data Setup

The test suite automatically creates the following test data:

### Tennis Setup
- Player number series: `PLAYERS`
- Match number series: `MATCHES`
- Configured with appropriate ranges and increments

### Sample Players
- Players with various names, contact information
- Different birth dates for age-related testing
- Mix of players with and without match history

### Sample Matches
- Singles and doubles matches
- Various match statuses (Open, Finished, Cancelled)
- Different match dates for filtering tests
- Court assignments

### Match Lines
- Player assignments to teams A and B
- Winner/loser scenarios
- Various team compositions

## Test Scenarios Covered

### Data Integrity
- ✅ Primary key constraints
- ✅ Required field validation
- ✅ Data type validation
- ✅ Relationship integrity

### Business Logic
- ✅ Number series automation
- ✅ Flow field calculations
- ✅ Winner determination logic
- ✅ Status transitions

### User Interface
- ✅ Page opening and navigation
- ✅ Data entry and validation
- ✅ List filtering and sorting
- ✅ Card page functionality

### APIs and Integration
- ✅ Query result accuracy
- ✅ Data formatting
- ✅ Filter application
- ✅ Performance validation

### Reports and Export
- ✅ Report generation
- ✅ Data filtering
- ✅ Export formats
- ✅ Import validation

## Best Practices Implemented

### Test Design
- Each test is independent and self-contained
- Proper setup and teardown procedures
- Clear test naming conventions
- Comprehensive scenario coverage

### Data Management
- Isolated test environments
- Consistent test data creation
- Automatic cleanup procedures
- Realistic data scenarios

### Error Handling
- Validation of error conditions
- Boundary condition testing
- Exception handling verification
- Recovery scenario testing

## Troubleshooting

### Common Issues

#### Test Data Conflicts
- **Issue**: Tests fail due to existing data
- **Solution**: Ensure proper test isolation and cleanup

#### Permission Issues
- **Issue**: Tests fail with permission errors
- **Solution**: Run with appropriate test permissions

#### Number Series Conflicts
- **Issue**: Number series already exist
- **Solution**: Use test-specific number series codes

### Debug Mode
Enable debug mode for detailed test execution logging:
```json
{
  "testFramework": {
    "enableDebugMode": true,
    "logLevel": "Verbose"
  }
}
```

## Contributing

### Adding New Tests
1. Follow existing naming conventions
2. Use the LibraryTennisTest codeunit for test data
3. Include proper scenario documentation
4. Add both positive and negative test cases

### Test Categories
- **Unit Tests**: Individual function validation
- **Integration Tests**: Cross-component validation
- **UI Tests**: User interface validation
- **API Tests**: Service endpoint validation

## Support

For issues or questions regarding the Tennis Management Test suite:

1. Check existing test documentation
2. Review test execution logs
3. Validate Tennis Management app installation
4. Ensure proper test environment configuration

## Version History

- **v1.0.0.0**: Initial comprehensive test suite
  - Complete table validation
  - Business logic testing
  - UI functionality tests
  - API endpoint validation
  - Report and XMLport testing

---

**Note**: This test suite is designed to be run in development and testing environments. Do not execute against production data.