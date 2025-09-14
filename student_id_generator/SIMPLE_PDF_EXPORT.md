# Simple PDF Export - One Page Per Student

## Overview
The Student ID Generator now has a simplified PDF export that creates exactly one page per student with their Excel data.

## How It Works

### Excel Data → PDF Pages
- **5 students in Excel** = **5 pages in PDF**
- **10 students in Excel** = **10 pages in PDF**
- **One student per page** with all their data

### Each Page Contains:
1. **ID Card Image** (350x400 pixels, centered)
2. **Divider Line**
3. **"Student Information" Header**
4. **All Excel Data** displayed as organized boxes:
   - Field name (bold, gray)
   - Field value (below the name)
   - Each field in its own bordered box
5. **Page Number** at bottom

## Example Layout:
```
┌─────────────────────────────────────┐
│           ID Card Image             │
│         (Student's Photo)           │
├─────────────────────────────────────┤
│        Student Information          │
│                                     │
│ ┌─────────────┐ ┌─────────────┐    │
│ │ Name        │ │ Student ID  │    │
│ │ John Doe    │ │ 12345       │    │
│ └─────────────┘ └─────────────┘    │
│                                     │
│ ┌─────────────┐ ┌─────────────┐    │
│ │ Grade       │ │ Class       │    │
│ │ 10th        │ │ A           │    │
│ └─────────────┘ └─────────────┘    │
│                                     │
│           Page 1 of 5               │
└─────────────────────────────────────┘
```

## How to Use:
1. **Upload** template image
2. **Upload** Excel file with student data
3. **Arrange** fields on template (optional)
4. **Generate** preview
5. **Click Export** → "Export All as PDF"
6. **Download** PDF with one page per student

## Technical Details:
- **File Format**: PDF (A4 pages)
- **File Name**: `id_cards_batch_[timestamp].pdf`
- **Page Count**: Exactly matches Excel row count
- **Data Source**: All columns from Excel file
- **Image Quality**: High resolution ID cards
- **Layout**: Professional, clean design

## Benefits:
✅ **Simple**: Just one export option  
✅ **Complete**: All student data included  
✅ **Organized**: Clean, readable layout  
✅ **Professional**: Print-ready format  
✅ **Efficient**: One file for all students  

The system now provides exactly what you need: a simple PDF export with one page per student containing their ID card and all their Excel data!
