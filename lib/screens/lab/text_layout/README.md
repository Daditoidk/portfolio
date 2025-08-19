# Text Layout System - Organized Structure

This folder contains the organized text layout management system for the portfolio's language animation feature. The system has been restructured for better maintainability and organization.

## 📁 **Folder Structure**

```
lib/screens/lab/text_layout/
├── core/                           # Core system components
│   ├── models/                     # Data models and structures
│   │   ├── line.dart              # Line data model
│   │   ├── line_manager.dart      # Line management utilities
│   │   └── text_layout_config.dart # Configuration classes
│   ├── managers/                   # System managers and controllers
│   │   ├── line_state_manager.dart # Line state management
│   │   ├── scroll_manager.dart     # Scroll behavior management
│   │   └── drag_speed_manager.dart # Drag speed calculations
│   └── integration/                # Integration with other systems
│       └── text_layout_integration.dart # Text animation registry integration
├── editor/                         # Visual editor components
│   ├── text_layout_editor.dart     # Main visual editor widget
│   └── portfolio_preview_widget.dart # Portfolio preview component
├── widgets/                        # Reusable UI widgets
│   ├── line_widget.dart           # Individual line display widget
│   └── line_creation_widget.dart  # Line creation preview widget
├── debug/                          # Debug and testing tools
│   ├── text_layout_debug.dart     # Layout editor debug widget
│   └── text_detection_integration.dart # Text detection system integration
├── README.md                       # This documentation
└── index.dart                      # Main export file
```

## 🏗️ **Core Components**

### **Models** (`core/models/`)

#### **Line** (`line.dart`)

Represents a single text line in the layout system.

**Key Properties:**

- `id`: Unique identifier
- `order`: Line position (0-32)
- `l10nKeys`: Localization keys for this line
- `height`: Line height in pixels
- `yPosition`: Y-coordinate position

#### **LineManager** (`line_manager.dart`)

Utility class for line operations and ID generation.

**Key Methods:**

- `generateId()`: Generate unique line IDs
- `calculateLineNumberAtPosition()`: Calculate line number from Y position

#### **TextLayoutConfig** (`text_layout_config.dart`)

Configuration class for the entire text layout system.

**Key Properties:**

- `sections`: List of layout sections
- `lines`: List of text lines
- `l10nKeyToText`: Localization key mappings

### **Managers** (`core/managers/`)

#### **LineStateManager** (`line_state_manager.dart`)

Manages the state of all lines in the system.

**Key Features:**

- Add/remove lines
- Update line positions
- Manage line state changes
- Canvas height management

#### **ScrollManager** (`scroll_manager.dart`)

Handles scroll behavior and coordinate calculations.

**Key Features:**

- Scroll controller management
- Canvas height calculations
- Position conversions
- Pointer scroll handling

#### **DragSpeedManager** (`drag_speed_manager.dart`)

Manages drag speed and movement calculations.

**Key Features:**

- Consistent drag speed across different contexts
- Movement vs. creation speed differentiation
- Viewport to canvas coordinate conversion

### **Integration** (`core/integration/`)

#### **TextLayoutIntegration** (`text_layout_integration.dart`)

Integrates the text layout system with the text animation registry.

**Key Features:**

- Apply configurations to registry
- Set manual line and block indices
- Coordinate with animation system

## 🎨 **Editor Components** (`editor/`)

### **TextLayoutEditor** (`text_layout_editor.dart`)

Main visual editor widget for organizing text lines and sections.

**Key Features:**

- Visual line management
- Section organization
- Real-time portfolio preview
- Drag and drop line creation
- Configuration export/import

### **PortfolioPreviewWidget** (`portfolio_preview_widget.dart`)

Live preview of the portfolio with current layout configuration.

**Key Features:**

- Real portfolio rendering
- Scroll integration
- Layout validation

## 🧩 **Widgets** (`widgets/`)

### **LineWidget** (`line_widget.dart`)

Individual line display and interaction widget.

**Key Features:**

- Line visualization
- Drag and drop support
- Resize handles
- Visual feedback

### **LineCreationWidget** (`line_creation_widget.dart`)

Preview widget for line creation process.

**Key Features:**

- Creation preview
- Position calculation
- Line number prediction

## 🐛 **Debug Tools** (`debug/`)

### **TextLayoutDebug** (`text_layout_debug.dart`)

Debug widget for testing the text layout editor.

**Key Features:**

- Editor access
- Configuration testing
- Layout validation

### **TextDetectionIntegration** (`text_detection_integration.dart`)

Integration widget for the text detection system.

**Key Features:**

- Quick detection dialog
- Full debug access
- System integration

## 🚀 **Usage**

### **Basic Import**

```dart
import 'package:portfolio_web/screens/lab/text_layout/index.dart';
```

### **Using the Editor**

```dart
// Open the visual editor
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => const TextLayoutEditor(),
  ),
);
```

### **Using Debug Tools**

```dart
// Quick text detection
const TextDetectionIntegration()

// Full debug interface
const TextLayoutDebug()
```

## 🔧 **Configuration**

### **Line Thresholds**

```dart
// Configure detection sensitivity
final scrollManager = ScrollManager(
  scrollController: ScrollController(),
  onScrollChanged: () {},
);
```

### **Drag Speed Settings**

```dart
// Adjust drag behavior
DragSpeedManager.configure(
  movementSpeed: 1.0,
  creationSpeed: 0.5,
);
```

## 📊 **Features**

- **Visual Editor**: Drag-and-drop line management
- **Real-time Preview**: Live portfolio rendering
- **Configuration Management**: Export/import layouts
- **Debug Tools**: Comprehensive testing interface
- **Integration**: Seamless animation system connection
- **Responsive Design**: Adapts to different screen sizes

## 🔍 **Debugging**

### **Common Issues**

1. **Rendering Errors**: Check line constraints and positioning
2. **Import Issues**: Verify file paths after reorganization
3. **Scroll Problems**: Ensure scroll controller initialization
4. **Drag Issues**: Check drag speed manager configuration

### **Debug Steps**

1. Use `TextLayoutDebug` for editor testing
2. Check console for constraint warnings
3. Verify manager initialization order
4. Test with different screen sizes

## 🎯 **Best Practices**

1. **Always use the index.dart exports** for clean imports
2. **Initialize managers in correct order** (scroll → line state → drag)
3. **Handle constraints properly** to avoid rendering errors
4. **Use debug tools** for testing and validation
5. **Maintain separation of concerns** between models, managers, and UI

## 🔮 **Future Enhancements**

- **Machine Learning**: Intelligent line positioning
- **Performance Optimization**: GPU-accelerated rendering
- **Accessibility**: Screen reader support
- **Internationalization**: Multi-language layout support
- **Cloud Sync**: Layout configuration sharing

## 📝 **Contributing**

When contributing to the text layout system:

1. **Follow the folder structure** for new components
2. **Update this README** for any structural changes
3. **Test thoroughly** with debug tools
4. **Maintain separation** between core logic and UI
5. **Document changes** in code comments

---

_This system provides a comprehensive solution for managing text layout in the portfolio, with clear separation of concerns and extensive debugging capabilities._
