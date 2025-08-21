# Animation Settings Panel

This folder contains all the widgets and styles needed for the animation settings panel in the animation editor.

## 📁 Structure

```
animation_settings_panel/
├── index.dart                           # Exports all classes
├── animation_panel_styles.dart          # Text theme and styling constants
├── animation_settings_panel.dart        # Main settings panel widget
├── property_widgets.dart                # Reusable property widgets
├── animation_property_config.dart       # Animation-specific configurations
└── README.md                            # This documentation
```

## 🎨 **AnimationPanelStyles**

A centralized text theme class that provides consistent typography throughout the animation settings panel.

### **Available Styles:**

- **`title`**: Major titles (18px, bold, white)
- **`subheading`**: Section headers (14px, semibold)
- **`dropdownOption`**: Dropdown menu options (12px)
- **`label`**: Labels for inputs (12px, regular)
- **`numberValue`**: Numbers and values (14px, bold, white)
- **`sliderLabel`**: Slider labels (10px, white54)

### **Spacing Constants:**

- **`horizontalPadding`**: 16.0
- **`verticalPadding`**: 8.0

## ⚙️ **AnimationSettingsPanel**

The main widget that contains all the animation settings controls.

### **Features:**

- **Direction Setting**: Left to Right, Right to Left, Top to Bottom, Bottom to Top
- **Speed Control**: Slider from 0.1x to 3.0x
- **Animation Type**: By Lines, By Blocks, By Elements, Custom
- **Animation Curve**: Ease In Out, Ease In, Ease Out, Linear, Bounce, Elastic
- **Repeat Count**: Stepper control with +/- buttons
- **Advanced Options**: Loop, Reverse, Load from JSON

### **Props:**

- **`selectedAnimation`**: Currently selected animation ID
- **`onAnimationChanged`**: Callback when animation changes
- **`onSettingsChanged`**: Callback when settings change
- **`currentSettings`**: Current animation settings map

### **State Management:**

- Internal state for all settings
- Automatic callback to parent when settings change
- Initialization from current settings
- Real-time updates

## 🔧 **Usage**

```dart
import 'animation_settings_panel/index.dart';

// In your widget
AnimationSettingsPanel(
  selectedAnimation: _selectedAnimation,
  onAnimationChanged: (animationId) {
    // Handle animation change
  },
  onSettingsChanged: (settings) {
    // Handle settings change
    print('New settings: $settings');
  },
  currentSettings: _currentSettings,
)
```

## 🎯 **Benefits**

- **Consistent Typography**: All text uses the same theme
- **Modular Design**: Easy to maintain and update
- **Reusable**: Can be used in other parts of the app
- **Type Safe**: Proper TypeScript-like typing
- **Clean Architecture**: Separation of concerns

## 🧩 **Property Widgets**

Reusable widgets for common property types:

- **`DropdownProperty`**: Dropdown selection with options (36px height)
- **`NumericProperty`**: Text input for numeric values with min/max display (36px height)
- **`SliderProperty`**: Interactive slider + text input with visual feedback (36px input height)
- **`CheckboxProperty`**: Boolean toggle with label
- **`TextProperty`**: Text input field with placeholder (36px height for single line)
- **`ColorProperty`**: Color picker with predefined options

### **Features:**

- **Clean Row Layout**: Properties displayed in 2-column rows (name + input)
- **Info Tooltips**: Hover over info button to see property descriptions
- **Consistent Styling**: All use `AnimationPanelStyles`
- **Type Safety**: Proper type casting and validation
- **Min/Max Display**: Min/max values shown below numeric inputs (min left, max right)
- **Required Fields**: Visual indication for required properties
- **Compact Design**: Efficient use of horizontal space

## ⚙️ **Animation Property Configuration**

Dynamic configuration system that defines which properties each animation should show:

### **Configuration Features:**

- **Animation-Specific Properties**: Each animation has its own set of properties
- **Default Values**: Pre-configured sensible defaults
- **Property Types**: Automatic widget selection based on property type
- **Options**: Dropdown options, min/max values, units, etc.
- **Required Fields**: Mark properties as required

### **Example Configuration:**

```dart
'text_scramble': AnimationPropertyConfig(
  animationId: 'text_scramble',
  properties: [
    PropertyConfig(
      name: 'Direction',
      type: PropertyType.dropdown,
      defaultValue: 'Left to Right',
      options: {
        'options': ['Left to Right', 'Right to Left', 'Top to Bottom', 'Bottom to Top'],
      },
      description: 'Direction of the scramble effect',
    ),
    PropertyConfig(
      name: 'Speed',
      type: PropertyType.numeric,
      defaultValue: 1.0,
      options: {
        'min': 0.1,
        'max': 3.0,
        'unit': 'x',
      },
    ),
  ],
),
```

## 🚀 **Future Enhancements**

- **Custom Themes**: Support for different color schemes
- **Animation Presets**: Pre-built animation configurations
- **Validation**: Input validation and error handling
- **Accessibility**: Screen reader support and keyboard navigation
- **Property Groups**: Group related properties together
- **Conditional Properties**: Show/hide properties based on other values
