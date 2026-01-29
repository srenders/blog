# Service Declaration Correction

## Overview

This app provides a supplemental correction system for Business Central Service Declarations. It allows you to fix Value Entries that are missing Service Declaration fields without modifying the original posted entries.

## How It Works

1. **Correction Table**: Stores correction data separately from posted entries
2. **Independent Action**: "Add Lines from Corrections" button creates Service Declaration lines directly from corrections
3. **Audit Trail**: Tracks who created corrections and when
4. **No Posted Data Changes**: Value Entries and other posted records are never modified

## Usage

### Step 1: Configure Settings
Open **TAI Service Declaration Correction Setup** and configure:
- Starting Date / Ending Date
- Default Service Transaction Type Code
- Filter Method (All Entries / Item Type Service)
- Limit to EU Countries (optional)

### Step 2: Suggest Corrections
Click **Suggest Corrections** to create correction entries for Value Entries missing Service Declaration fields. The system processes both invoices and credit memos and retrieves partner information (VAT ID and Country/Region Code) from the Bill-to Customer (for sales) or Pay-to Vendor (for purchases).

### Step 3: Review/Edit Corrections
Click **View Corrections** or open **TAI Serv. Decl. Corrections** to review and modify correction entries.

### Step 4: Add Lines from Corrections
Go to your Service Declaration and click **Add Lines from Corrections** to create Service Declaration lines from your correction entries.

Optionally, you can also run the standard **Suggest Lines** action for regular entries - both approaches work independently.

## Key Features

✅ **Non-invasive**: Original Value Entries are never modified  
✅ **Independent**: Works separately from standard "Suggest Lines"  
✅ **Reversible**: Corrections can be edited or deleted at any time  
✅ **Audit trail**: Tracks when and by whom corrections were created  
✅ **Upgrade-safe**: Doesn't override standard Business Central functionality  
✅ **Flexible filtering**: Multiple filter options for different scenarios

## Objects

- **Table 60200**: TAI Service Decl. Fix Setup
- **Table 60201**: TAI Serv. Decl. Correction
- **Page 60200**: TAI Service Decl. Fix Setup
- **Page 60201**: TAI Serv. Decl. Corrections
- **Page 60202**: TAI Serv. Decl. Corr. Card
- **Codeunit 60201**: TAI Add Serv. Decl. Lines
- **Codeunit 60202**: TAI Suggest Serv. Decl. Corr.
- **Enum 60200**: TAI Serv. Decl. Filter Method

## Technical Notes

The solution adds an "Add Lines from Corrections" action to the Service Declaration page. This action reads the correction table and creates Service Declaration lines directly for any corrections applicable to the current declaration period.

**Partner Data Accuracy**: The system retrieves partner VAT ID and Country/Region Code from the Bill-to Customer (for sales) or Pay-to Vendor (for purchases) by looking up posted invoice/credit memo headers. This ensures the correct invoicing party is reported, as required for Service Declaration compliance.

**Document Type Support**: Processes Sales Invoices, Sales Credit Memos, Purchase Invoices, and Purchase Credit Memos.

This approach ensures that:

- No posted Value Entry records are ever modified
- Partner information comes from the correct invoicing party
- Works completely independently of standard Business Central functionality
- Corrections can be applied multiple times without side effects
- No event subscribers or code overrides needed
- Original data integrity is preserved

## License

This project is licensed under the MIT License - you are free to use, modify, and distribute this software for any purpose, including commercial use.

## Disclaimer

⚠️ **Important**: This app is provided as-is without any warranties or guarantees.

- **Test thoroughly** in a sandbox or test environment before using in production
- **Verify compliance** with your local Service Declaration regulations and requirements
- **Backup your data** before installing or using this extension
- The author is not responsible for any data loss, compliance issues, or problems arising from the use of this app
- This is a community contribution and is not officially supported by Microsoft or any other organization

For production use, always consult with your Business Central partner or compliance advisor to ensure this solution meets your specific regulatory requirements.
