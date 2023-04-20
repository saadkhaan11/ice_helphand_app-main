import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ice_helphand/screens/chatScreen/chat_screen.dart';
import 'package:intl/intl.dart';

class ChatUsersScreen extends StatefulWidget {
  static const routeName = "/ChatUsersScreen";
  // UserModel user;
  ChatUsersScreen({super.key});

  @override
  State<ChatUsersScreen> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  int charLength = 0;
  bool textFieldSelected = false;
  List<Map<dynamic, dynamic>> _foundUsers = [];
  TextEditingController searchController = TextEditingController();

  final List<Map> _allUsers = [];

  bool isLoading = false;
  User? user = FirebaseAuth.instance.currentUser;

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    setState(() {
      charLength = enteredKeyword.length;
      print(charLength);
      if (charLength < 1) {
        textFieldSelected = false;
      } else {
        textFieldSelected = true;
      }
    });
    List<Map<dynamic, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["username"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void listSearch() async {
    await FirebaseFirestore.instance
        .collection('users')
        // .where('username', isEqualTo: searchController.text)
        .get()
        .then((value) {
      value.docs.forEach((users) {
        if (users.data()['email'] != user!.email) {
          _allUsers.add(users.data());
          // print(_allUsers);
        }
      });
      _foundUsers = _allUsers;
      // print(_foundUsers);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    listSearch();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final users = ModalRoute.of(context)!.settings.arguments as UserModel;
    // final userProvider = Provider.of<UserModel>(context);

    // Future<List> users = userProvider.getData();
    return Scaffold(
        backgroundColor: const Color(0xffF8F8F8),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xffF8F8F8),
          centerTitle: true,
          // leading: const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          //   child: CircleAvatar(
          //     foregroundImage: AssetImage('assets/profile.jpg'),
          //   ),
          // ),
          title: Text(
            'Chat',
            style: GoogleFonts.urbanist(fontSize: 24, color: Colors.black),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                // focusNode: _focus,
                // style: TextStyle(fontSize: 1),
                onTap: () {
                  textFieldSelected = true;
                },
                onChanged: (value) => _runFilter(value),
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
            ),
            const SizedBox(
              height: 40,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffECECEC),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: textFieldSelected
                      ? ListView.builder(
                          itemCount: _foundUsers.length,
                          itemBuilder: ((context, index) {
                            return GestureDetector(
                                onTap: (() {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: ((context) {
                                    return ChatScreen(
                                        currentUser: user!.uid,
                                        friendId: _foundUsers[index]['uid'],
                                        friendName: _foundUsers[index]
                                            ['username'],
                                        friendImage: _foundUsers[index]
                                            ['image']);
                                  })));
                                  // print(_foundUsers[index]['username']);
                                }),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: SizedBox(
                                      height: 100,
                                      width: 55,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        // child: Image.network(
                                        //     _foundUsers[index]['image']),
                                        child: CachedNetworkImage(
                                          imageUrl: _foundUsers[index]['image'],
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          // fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      _foundUsers[index]['username'],
                                    ),
                                    trailing: FaIcon(FontAwesomeIcons.message),
                                  ),
                                ));
                          }))
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(user!.uid)
                              .collection('messages')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length < 1) {
                                return const Center(
                                  child: Text("No Chats Available !"),
                                );
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    var friendId = snapshot.data.docs[index].id;
                                    var lastMsg =
                                        snapshot.data.docs[index]['last_msg'];
                                    return FutureBuilder(
                                      future: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(friendId)
                                          .get(),
                                      builder: (context,
                                          AsyncSnapshot asyncSnapshot) {
                                        if (asyncSnapshot.hasData) {
                                          var friend = asyncSnapshot.data;
                                          final Timestamp timestamp =
                                              friend['date'] as Timestamp;
                                          final DateTime dateTime =
                                              timestamp.toDate();
                                          final dateString =
                                              DateFormat.jm().format(dateTime);

                                          return ListTile(
                                            leading: SizedBox(
                                              height: 100,
                                              width: 55,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  child: Image.network(
                                                    friend['image'],
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            title: Text(
                                              friend['username'],
                                            ),
                                            trailing: Text(dateString),
                                            subtitle: Container(
                                              child: Text(
                                                "$lastMsg",
                                                style: TextStyle(
                                                    color: Colors.grey),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatScreen(
                                                            currentUser:
                                                                user!.uid,
                                                            friendId:
                                                                friend['uid'],
                                                            friendName: friend[
                                                                'username'],
                                                            friendImage:
                                                                friend['image'],
                                                          )));
                                            },
                                          );
                                        }
                                        return LinearProgressIndicator();
                                      },
                                    );
                                  });
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),

                  // TextButton(
                  //   onPressed: (() => print('object')),
                  //   child: Text('Press'),
                  // )
                  // ListView.builder(
                  //   itemCount: ,
                  //   itemBuilder: ((context, index) {
                  //   return ChatUserCard(email: email, username: username)
                  // }))
                  // child: ListView.builder(itemBuilder: ((context, index) {
                  //   // return ChatUserCard(email: email, username: username)
                  // })),
                  // child: StreamBuilder(
                  //     stream: FirebaseFirestore.instance
                  //         .collection('users')
                  //         .snapshots(),
                  //     builder: (BuildContext context, snapshot) {
                  //       if (!snapshot.hasData) {
                  //         return Text("There is no expense");
                  //       } else {
                  //         return ListView.builder(
                  //           itemCount: snapshot.data!.docs.length,
                  //           itemBuilder: (context, index) {
                  //             DocumentSnapshot products =
                  //                 snapshot.data!.docs[index];
                  //             return ChatUserCard(
                  //               email: products['email'],
                  //               username: products['username'],
                  //             );
                  //           },
                  //         );
                  //       }
                  //     }),
                ),
              ),
            )
          ],
        ));
  }
}
