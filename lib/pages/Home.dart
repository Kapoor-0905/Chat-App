import 'dart:ui';

import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/Login.dart';
import 'package:chat_app/pages/Profile.dart';
import 'package:chat_app/pages/Search.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String userName = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? group;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettingUserData();
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNamefromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });

    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, const Search());
              },
              icon: Icon(Icons.search))
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Groups",
          style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Color.fromARGB(244, 145, 63, 216),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Divider(
              height: 2,
              indent: 20,
              endIndent: 20,
              color: Colors.white,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () {
                nextScreenReplace(
                    context, Profile(userName: userName, email: email));
              },
              iconColor: Color.fromARGB(255, 203, 152, 236),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color.fromARGB(255, 203, 152, 236),
                        title: const Text("LogOut"),
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              await authService.signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const Login()),
                                  (route) => false);
                            },
                            icon: const Icon(
                              Icons.done,
                              color: Color.fromARGB(255, 2, 128, 54),
                            ),
                          ),
                        ],
                      );
                    });
              },
              iconColor: Color.fromARGB(255, 203, 152, 236),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text(
                "LogOut",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: GroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Color.fromARGB(255, 203, 152, 236),
            title: const Text(
              "Create a new group",
              textAlign: TextAlign.left,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _isLoading == true
                    ? Center(
                        child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor))
                    : TextField(
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          setState(() {
                            groupName = value;
                          });
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      _isLoading = false;
                    });
                    Navigator.of(context).pop();
                    showSnackBar(
                        context, Colors.green, "Group created Successfully");
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                ),
                child: Text("Create"),
              ),
            ],
          );
        });
  }

  GroupList() {
    return StreamBuilder(
        stream: group,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['groups'] != null) {
              if (snapshot.data['groups'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    int reverseIndex =
                        snapshot.data['groups'].length - index - 1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data["fullName"],
                        groupName:
                            getName(snapshot.data["groups"][reverseIndex]));
                  },
                );
              } else {
                return noGroupWidget();
              }
            } else {
              return noGroupWidget();
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            );
          }
        });
  }

  noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Color.fromARGB(255, 188, 111, 241),
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You have not joined any group, tap on the add icon to create a group or search from top search button",
            style: TextStyle(
              color: Color.fromARGB(255, 203, 152, 236),
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
