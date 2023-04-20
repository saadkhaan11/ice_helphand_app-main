import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/message_textfield.dart';
import '../../widgets/single_message.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = "/ChatScreen";
  final String currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;

  const ChatScreen({
    super.key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
    // required this.friendImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                SizedBox(
                  height: 55,
                  width: 55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      friendImage,
                      fit: BoxFit.cover,
                      // width: 50,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  friendName.toUpperCase(),
                  style: GoogleFonts.urbanist(
                      fontSize: 16, fontWeight: FontWeight.w500),
                )
              ],
            ),
          )),
          Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(currentUser)
                      .collection('messages')
                      .doc(friendId)
                      .collection('chats')
                      .orderBy("date", descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return const Center(
                          child: Text("Say Hi"),
                        );
                      }
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          reverse: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            bool isMe = snapshot.data.docs[index]['senderId'] ==
                                currentUser;
                            return SingleMessage(
                                message: snapshot.data.docs[index]['message'],
                                isMe: isMe);
                          });
                    }
                    return const Center(child: CircularProgressIndicator());
                  })),
          MessageTextField(currentUser, friendId),
        ],
      ),
    );
  }
}
