# Project Detail Screen

This directory contains the project detail screen with a modern two-column layout design.

## 📁 Files

- `project_detail_screen.dart` - Main project detail screen with two-column layout
- `project_detail_styles.dart` - Styles and theme configuration for the detail screen
- `README.md` - This documentation file

## 🎨 Layout Design

### Two-Column Layout

- **Left Column (0.5/3 width)**: Fixed navigation sidebar with section index
- **Right Column (2.5/3 width)**: Scrollable content area with detailed information

### Responsive Design

- **Desktop**: 0.5/3 left, 2.5/3 right (side by side)
- **Tablet**: 25% left, 75% right (side by side)
- **Mobile**: Stacked vertically (100% each)

### Styling

- **Left Column**: Transparent background, no borders
- **Right Column**: White background with rounded corners and white border (1px stroke)

## 🎯 Features

### Left Column Content

- Navigation sidebar with section index
- Interactive navigation items with icons
- Active section highlighting
- Smooth section transitions

### Right Column Content

- Dynamic content based on selected section
- Project overview with technologies and features
- Detailed project description
- Technologies showcase
- Features list
- Gallery section with three types of content:
  - **Image + Text Section**: 2/3 image, 1/3 text (configurable left/right)
  - **Text Only Section**: Clean text layout
  - **Parallax Image Section**: Full-width image with optional overlay title
- Process sections (expandable)
- Scrollable content area

### Styling System

- Consistent color scheme
- Typography hierarchy
- Responsive breakpoints
- Reusable style constants

## 🔧 Usage

The screen automatically adapts to different screen sizes and provides a clean, modern interface for displaying project details. The layout ensures good readability and user experience across all devices.

## 🎨 Style Classes

- `ProjectDetailStyles` - Main style configuration
- Responsive column width calculations
- Color scheme and typography definitions
- Border and decoration styles

## 🖼️ Gallery Section Features

### Image + Text Section
- **Layout**: 2/3 image, 1/3 text
- **Configurable**: Image can be on left or right
- **Styling**: Rounded corners with shadow effects
- **Responsive**: Adapts to content height

### Text Only Section
- **Layout**: Clean text presentation
- **Typography**: Consistent with design system
- **Spacing**: Proper vertical rhythm

### Parallax Image Section
- **Layout**: Full-width image display
- **Optional Title**: Overlay title at bottom with gradient
- **Effects**: Shadow and rounded corners
- **Height**: Fixed 400px height for consistency
