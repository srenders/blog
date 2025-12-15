# Document Preview Demo

This demo showcases the **ExtendedDatatype = Document** feature introduced in Business Central v27, which enables portrait-optimized document previews in FactBoxes.

## Overview

The feature allows displaying image-based previews of documents (like invoices) directly in FactBoxes without requiring users to print or open the full document.

## Implementation Components

### 1. Table Extension (DocumentPreview.TableExt.al)
- Extends **Sales Invoice Header** table
- Adds a `Media` field with `ExtendedDatatype = Document`
- This property tells BC to render the content in portrait-optimized format

### 2. FactBox Page (InvoicePreviewFactBox.Page.al)
- **PageType**: CardPart (required for FactBoxes)
- **SourceTable**: Temporary table (no database storage needed)
- **Key Features**:
  - Automatically generates preview when invoice is viewed
  - Converts report PDF to PNG image on-demand
  - Uses system caching for performance

### 3. Page Extension (PostedSalesInvoice.PageExt.al)
- Adds the preview FactBox to Posted Sales Invoice page
- Links preview to current record via SubPageLink

## How It Works

1. User opens a Posted Sales Invoice
2. FactBox triggers `OnAfterGetCurrRecord`
3. If no preview exists, `GeneratePreview()` is called:
   - Renders "Standard Sales - Invoice" report to PDF
   - Loads PDF using `PDF Document` codeunit
   - Converts first page to PNG image
   - Imports image into Media field
4. Preview displays in portrait format in FactBox

## Key Features

✅ **No Database Storage**: Uses temporary tables for previews  
✅ **On-Demand Generation**: Only creates preview when needed  
✅ **PDF Conversion**: Automatically converts report PDFs to images  
✅ **Portrait Optimized**: Special rendering for document-style content  
✅ **First Page Preview**: Shows the first page of multi-page documents  

## Supported Page Types

- `CardPart`
- `ListPart`

## Limitations

⚠️ **No Native PDF Rendering**: PDFs must be converted to images  
⚠️ **First Page Only**: Initial version supports only first page (can be changed via `ConvertToImage` parameter)  
⚠️ **Image Format**: Media field stores PNG/JPG, not PDF  

## Best Practices

1. **Complement with Full View**: Provide a separate "View PDF" action for complete document access
2. **Standardize on First Page**: Use consistent page selection for thumbnails
3. **Performance**: Consider background session execution for production
4. **User Communication**: Clearly indicate this is a preview, not the full document

## Practical Applications

- Display invoice/order previews in approval workflows
- Show scanned documents on customer/vendor cards
- Provide visual confirmation without leaving current page
- Assist with dispute resolution by showing document at-a-glance

## Production Considerations

⚠️ **This is demo code** - For production use, consider:
- Running preview generation in background sessions
- Adding error handling and retry logic
- Caching previews to avoid regeneration
- Adding user settings to enable/disable previews
- Monitoring performance impact on large documents

## References

- Blog Post: [Document Previews in Business Central v27](https://ssosic.com/development/document-previews-in-business-central-v27-pdf-viewer/)
- Feature: Available from Business Central v27 (Runtime 16.0+)
- Property: `ExtendedDatatype = Document`
