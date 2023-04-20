import 'package:flutter/material.dart';

class ContactsSearchField extends StatelessWidget {
  Function(String value) runFilter;
  ContactsSearchField({
    super.key,
    required this.runFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        // focusNode: _focus,
        // style: TextStyle(fontSize: 1),
        onTap: () {
          // textFieldSelected = true;
        },
        onChanged: (value) => runFilter(value),
        // controller: searchController,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10),
          prefixIcon: const Icon(
            Icons.search,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.red),
          ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.all(Radius.circular(30.0)),
          //   borderSide: BorderSide(color: Colors.blue),
          // ),
          filled: true,
          hintStyle: TextStyle(color: Colors.grey[800], fontSize: 12),
          hintText: "Type in your text",
          fillColor: const Color(0x0d2F2F2F),
        ),
      ),
    );
  }
}
