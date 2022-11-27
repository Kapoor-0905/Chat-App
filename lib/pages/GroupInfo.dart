import 'package:chat_app/pages/Home.dart';
import 'package:chat_app/pages/Login.dart';
import 'package:chat_app/services/auth_services.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo(
      {super.key,
      required this.adminName,
      required this.groupId,
      required this.groupName});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  AuthService authService = AuthService();
  Stream? members;
  @override
  void initState() {
    getMembers();
    // TODO: implement initState
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
    });
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getAdmin(String admin) {
    return admin.substring(admin.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          'Group Info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Color.fromARGB(255, 203, 152, 236),
                      title: const Text("Leave Group"),
                      content: const Text(
                          "Are you sure you want to exit the group?"),
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
                            DatabaseService(
                                    uid: FirebaseAuth.instance.currentUser!.uid)
                                .togglegroupJoin(widget.groupId,
                                    getName(widget.adminName), widget.groupName)
                                .whenComplete(() {
                              nextScreenReplace(context, Home());
                            });
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
            icon: const Icon(
              Icons.exit_to_app,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(
                20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color.fromARGB(255, 203, 152, 236).withOpacity(0.7),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                        height: 2,
                      ),
                      Text(
                        "Admin: ${getAdmin(widget.adminName)}",
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].length != 0) {
                return ListView.builder(
                  itemCount: snapshot.data['members'].length,
                  itemBuilder: (context, index) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            getName(snapshot.data['members'][index])
                                .substring(0, 1)
                                .toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          getName(snapshot.data['members'][index]),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          getId(snapshot.data['members'][index]),
                          style: TextStyle(
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  shrinkWrap: true,
                );
              } else {
                return Center(
                  child: Text(
                    "No Members",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                );
              }
            } else {
              return Center(
                child: Text(
                  "No Members",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            }
          } else {
            return CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            );
          }
        });
  }
}
