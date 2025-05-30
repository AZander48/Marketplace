import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final Function(String) onSearch;
  final VoidCallback? onTap;
  final bool showClearButton;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool autofocus;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onSearch,
    this.onTap,
    this.showClearButton = true,
    this.keyboardType,
    this.textInputAction,
    this.autofocus = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: textInputAction ?? TextInputAction.search,
              onSubmitted: onSearch,
              onTap: onTap,
              enableInteractiveSelection: true,
              enableSuggestions: true,
              autocorrect: true,
              autofocus: autofocus,
            ),
          ),
          if (showClearButton && controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.grey),
              onPressed: () {
                controller.clear();
                focusNode.requestFocus();
              },
            ),
        ],
      ),
    );
  }
} 