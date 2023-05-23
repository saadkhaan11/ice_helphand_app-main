import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ice_helphand/models/added_contacts.dart';
import 'package:ice_helphand/size_config.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ContactCard extends StatelessWidget {
  String? name;
  List<Item>? phNo;
  bool addIcon;
  List<AddedContacts>? addedContacts;
  Function? addContactfunction;
  Function? removeContactFunction;
  final snackBar = SnackBar(
    /// need to set following properties for best effect of awesome_snackbar_content
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent,
    content: AwesomeSnackbarContent(
      title: 'Contact Added',
      message: 'Contact Has Added to your Emergency List!',

      /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
      contentType: ContentType.success,
    ),
  );
  ContactCard({
    super.key,
    required this.name,
    required this.phNo,
    required this.addIcon,
    this.addedContacts,
    this.addContactfunction,
    this.removeContactFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        height: getProportionateScreenHeight(70),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(70)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        'assets/images/user.png',
                        fit: BoxFit.cover,
                        // width: 50,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: getProportionateScreenWidth(200),
                        child: Text(
                          name.toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      // ...phNo!.map(
                      //   (e) {
                      //     return Text(e.value.toString());
                      //   },
                      // ).toList(),
                      Text(
                        phNo![0].value!,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
              addIcon
                  ? GestureDetector(
                      onTap: () {
                        addContactfunction!(name, phNo);

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      },
                      child: SvgPicture.asset('assets/icons/icons8-done.svg'))
                  : GestureDetector(
                      onTap: () {
                        removeContactFunction!();
                      },
                      child: SvgPicture.asset('assets/icons/cross.svg'))
            ],
          ),
        ),
      ),
    );
  }
}
