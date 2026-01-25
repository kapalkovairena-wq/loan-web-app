import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          /// Menu (3 traits)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),

          /// Logo centré
          Expanded(
            child: Center(
              child: Image.network(
                "https://yztryuurtkxoygpcmlmu.supabase.co/storage/v1/object/public/loan/logo.png",
                height: 150,
              ),
            ),
          ),

          /// Contact à droite
          Row(
            children: const [
              Icon(Icons.phone, size: 18),
              SizedBox(width: 8),
              Text('+41 798079225'),
            ],
          ),
        ],
      ),
    );
  }
}