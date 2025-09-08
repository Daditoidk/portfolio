import 'package:flutter/material.dart';

class CustomNavBarPortfolioV2 extends StatelessWidget {
  const CustomNavBarPortfolioV2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildNavItem('Home', true),
          const SizedBox(width: 20),
          _buildNavItem('About', false),
          const SizedBox(width: 20),
          _buildNavItem('Skills', false),
          const SizedBox(width: 20),
          _buildNavItem('Projects', false),
          const SizedBox(width: 20),
          _buildNavItem('Contact', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black87,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          fontSize: 14,
        ),
      ),
    );
  }
}
