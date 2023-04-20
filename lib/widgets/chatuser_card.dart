import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_helphand/models/user_model.dart';

import '../screens/chatScreen/chat_screen.dart';

class ChatUserCard extends StatelessWidget {
  final UserModel userModel;
  ChatUserCard({
    required this.userModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: ((context) => ChatScreen(username: userModel.email, currentUser: userModel.,)
      //           )
      //           )
      //           );
      // },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Image.asset('assets/images/chatprof.png'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userModel.email,
                            style: GoogleFonts.urbanist(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userModel.uid,
                            style: GoogleFonts.urbanist(
                              fontSize: 14,
                              color: Color(0xff767676),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '08:50',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    color: Color(0xff767676),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
