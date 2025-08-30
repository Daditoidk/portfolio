import 'package:flutter/material.dart';
import 'base_property_widget.dart';
import 'dart:convert';
import 'package:portfolio_web/screens/lab/widgets/custom_toast.dart';

/// Property widget for importing text order data via JSON paste
class TextOrderImportProperty extends PropertyWidget {
  final dynamic value;
  final Function(dynamic) onChanged;
  final Function(bool) onValidationChanged;

  const TextOrderImportProperty({
    super.key,
    required super.propertyName,
    super.description,
    super.required,
    super.unit,
    required this.value,
    required this.onChanged,
    required this.onValidationChanged,
  });

  @override
  Widget buildPropertyContent() {
    return Builder(
      builder: (context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showImportDialog(context),
          icon: Icon(Icons.upload_file, size: 16),
          label: Text('Import JSON Data'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }

  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ImportJsonDialog(
          onImport: (jsonData) {
            _handleImport(jsonData);
          },
        );
      },
    );
  }

  void _handleImport(String jsonString) {
    try {
      if (jsonString.isNotEmpty) {
        final parsedData = _parseJson(jsonString);
        if (parsedData != null) {
          // First, notify validation success
          onValidationChanged(true);
          // Then, pass the parsed data
          onChanged(parsedData);
        } else {
          onValidationChanged(false);
        }
      } else {
        onValidationChanged(false);
      }
    } catch (e) {
      onValidationChanged(false);
    }
  }

  Map<String, dynamic>? _parseJson(String jsonString) {
    try {
      return Map<String, dynamic>.from(json.decode(jsonString) as Map);
    } catch (e) {
      return null;
    }
  }
}

/// Dialog for importing JSON data
class _ImportJsonDialog extends StatefulWidget {
  final Function(String) onImport;

  const _ImportJsonDialog({required this.onImport});

  @override
  State<_ImportJsonDialog> createState() => _ImportJsonDialogState();
}

class _ImportJsonDialogState extends State<_ImportJsonDialog> {
  final TextEditingController _jsonController = TextEditingController();
  bool _isValidJson = false;

  @override
  void initState() {
    super.initState();
    _jsonController.addListener(_validateJson);
  }

  @override
  void dispose() {
    _jsonController.dispose();
    super.dispose();
  }

  void _validateJson() {
    try {
      if (_jsonController.text.isNotEmpty) {
        json.decode(_jsonController.text);
        setState(() => _isValidJson = true);
      } else {
        setState(() => _isValidJson = false);
      }
    } catch (e) {
      setState(() => _isValidJson = false);
    }
  }

  void _showSuccessToast() {
    CustomToast.showSuccess(context, message: 'JSON imported successfully!');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.upload_file, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Text('Import JSON Data'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paste your JSON data from the Text Order Visualizer:',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _jsonController,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Paste JSON here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: _isValidJson
                      ? Colors.green.shade400
                      : Colors.grey.shade400,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                  color: _isValidJson
                      ? Colors.green.shade600
                      : Colors.blue.shade600,
                  width: 2,
                ),
              ),
              suffixIcon: _isValidJson
                  ? Icon(Icons.check_circle, color: Colors.green.shade600)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                _isValidJson ? Icons.check_circle : Icons.info_outline,
                size: 16,
                color: _isValidJson
                    ? Colors.green.shade600
                    : Colors.grey.shade600,
              ),
              const SizedBox(width: 4),
              Text(
                _isValidJson ? 'Valid JSON' : 'Invalid JSON format',
                style: TextStyle(
                  fontSize: 12,
                  color: _isValidJson
                      ? Colors.green.shade600
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isValidJson && _jsonController.text.isNotEmpty
              ? () {
                  widget.onImport(_jsonController.text);
                  Navigator.of(context).pop();
                  _showSuccessToast();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade600,
            foregroundColor: Colors.white,
          ),
          child: Text('Import'),
        ),
      ],
    );
  }
}
