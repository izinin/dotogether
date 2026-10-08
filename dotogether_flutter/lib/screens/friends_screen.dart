import 'package:flutter/material.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart'
    as contact_picker;
import 'package:provider/provider.dart';
import 'package:dotogether_client/dotogether_client.dart';
import '../services/app_state.dart';
import 'create_project_screen.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final contact_picker.FlutterNativeContactPicker _contactPicker =
      contact_picker.FlutterNativeContactPicker();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateProjectScreen(String contactName, String contactPhone) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreateProjectScreen(
          contactName: contactName.isEmpty ? 'Unknown' : contactName,
          contactPhone: contactPhone,
        ),
      ),
    );
  }

  /// Opens the device's native contact picker and, if a contact with a
  /// phone number was selected, continues the same Project creation flow
  /// used for a contact picked from the server-backed Contact list.
  Future<void> _pickFromPhoneBook() async {
    try {
      final picked = await _contactPicker.selectPhoneNumber();
      if (picked == null) return;

      final phone =
          picked.selectedPhoneNumber ??
          (picked.phoneNumbers?.isNotEmpty == true
              ? picked.phoneNumbers!.first
              : '');
      if (!mounted) return;

      if (phone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Selected contact does not have a phone number.'),
          ),
        );
        return;
      }

      _openCreateProjectScreen(picked.fullName ?? '', phone);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact picker is not available on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final contacts = appState.contacts;

    // Filter contacts based on search query
    final filteredContacts = contacts.where((contact) {
      final name = contact.name.toLowerCase();
      final query = _searchQuery.toLowerCase();
      final phone = contact.phoneNumber.replaceAll(RegExp(r'\D'), '');
      return name.contains(query) || phone.contains(query);
    }).toList();

    // The "pick from phone book" entry is only available outside demo mode.
    final showPhoneBookPicker = !appState.isDemoMode;
    final itemCount = filteredContacts.length + (showPhoneBookPicker ? 1 : 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create TODO list for',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search friends or phone numbers...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Contacts List
          Expanded(
            child: appState.isLoadingContacts
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF2196F3),
                      ),
                    ),
                  )
                : itemCount == 0
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isNotEmpty
                              ? 'No contacts match your search.'
                              : 'No contacts found.',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    itemCount: itemCount,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (context, index) {
                      if (showPhoneBookPicker &&
                          index == filteredContacts.length) {
                        return _buildPickFromPhoneBookTile();
                      }
                      return _buildContactTile(filteredContacts[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickFromPhoneBookTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade200,
        child: Icon(Icons.contact_phone, color: Colors.grey.shade700),
      ),
      title: const Text(
        'Pick from phone book',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: const Text(
        'Select a contact from your device',
        style: TextStyle(color: Colors.grey, fontSize: 13),
      ),
      onTap: _pickFromPhoneBook,
    );
  }

  Widget _buildContactTile(Contact contact) {
    final String displayName = contact.name;
    final String phone = contact.phoneNumber.isNotEmpty
        ? contact.phoneNumber
        : 'No Phone Number';
    final firstLetter = displayName.isEmpty
        ? '?'
        : displayName[0].toUpperCase();

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade100,
        child: Text(
          firstLetter,
          style: const TextStyle(
            color: Color(0xFF2196F3),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        displayName.isEmpty ? 'Unknown' : displayName,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      subtitle: Text(
        phone,
        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
      ),
      onTap: () {
        if (contact.phoneNumber.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('This contact does not have a phone number.'),
            ),
          );
          return;
        }
        _openCreateProjectScreen(displayName, phone);
      },
    );
  }
}
