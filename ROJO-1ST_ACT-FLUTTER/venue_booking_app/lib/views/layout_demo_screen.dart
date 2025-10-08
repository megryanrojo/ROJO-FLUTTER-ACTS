import 'package:flutter/material.dart';
import '../widgets/layout_demo_widgets.dart';

class LayoutDemoScreen extends StatefulWidget {
  const LayoutDemoScreen({super.key});

  @override
  State<LayoutDemoScreen> createState() => _LayoutDemoScreenState();
}

class _LayoutDemoScreenState extends State<LayoutDemoScreen> {
  int _selectedIndex = 0;
  
  final List<Widget> _demoWidgets = [
    const RowTextSpacingDemo(),
    const ColumnButtonsDemo(),
    const ContainerStylingDemo(),
    const ProfileCardDemo(),
    const ExpandedLayoutDemo(),
    const NavigationBarDemo(),
    const StackLayoutDemo(),
    const FlexibleDemo(),
    const ChatBubbleDemo(),
    const GridLayoutDemo(),
  ];

  final List<String> _demoTitles = [
    'Row Text Spacing',
    'Column Buttons',
    'Container Styling',
    'Profile Card',
    'Expanded Layout',
    'Navigation Bar',
    'Stack Layout',
    'Flexible Demo',
    'Chat Bubble',
    'Grid Layout',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Layout Demos'),
        backgroundColor: Colors.purple[600],
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Demo selector
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _demoTitles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: FilterChip(
                    label: Text(_demoTitles[index]),
                    selected: _selectedIndex == index,
                    onSelected: (selected) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    selectedColor: Colors.purple[100],
                    checkmarkColor: Colors.purple[600],
                  ),
                );
              },
            ),
          ),
          const Divider(),
          // Demo content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _demoTitles[_selectedIndex],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _demoWidgets[_selectedIndex],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
