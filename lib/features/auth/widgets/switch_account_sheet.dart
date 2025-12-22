import 'package:flutter/material.dart';
import 'package:smart_interview_ai/features/auth/models/save_user_model.dart';

class SwitchAccountSheet extends StatelessWidget {
  final List<SaveUserModel> accounts;
  final Function(SaveUserModel) onSelect;
  final VoidCallback onAddAccount;

  const SwitchAccountSheet({
    super.key,
    required this.accounts,
    required this.onSelect,
    required this.onAddAccount,
  });

  @override
  Widget build(BuildContext context) {
    print('user accouunt: $accounts');
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...accounts.map(
            (acc) => ListTile(
              leading: CircleAvatar(
                backgroundImage: acc.photoUrl != null
                    ? NetworkImage(acc.photoUrl!)
                    : null,
                child: acc.photoUrl == null ? const Icon(Icons.person) : null,
              ),
              title: Text(
                acc.displayName,
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(acc.email, style: TextStyle(color: Colors.black)),
              onTap: () => onSelect(acc),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.add, color: Colors.black),
            title: const Text(
              'Add another account',
              style: TextStyle(color: Colors.black),
            ),
            onTap: onAddAccount,
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
