import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  bool isJoined = false;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserName();
  }

  getCurrentUserName() async {
    await HelperFunctions.getUserNamefromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          "Search",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'courier new',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Groups...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'courier new',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    SearchMethod();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  SearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
      });
      await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
          .searchGroupByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String adminName) {
    // already in group
    joinedOrNot(userName, groupId, groupName, adminName);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      title: Text(
        groupName,
        style: TextStyle(
          color: Color.fromARGB(255, 185, 118, 230),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        "Admin: ${getName(adminName)}",
        style: TextStyle(
          color: Color.fromARGB(150, 255, 255, 255),
          fontSize: 14,
        ),
      ),
      trailing: InkWell(
        onTap: () async {
          await DatabaseService(uid: user!.uid)
              .togglegroupJoin(groupId, userName, groupName);
          if (isJoined) {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(
                context, Colors.green, "Successfully Joined the Group");
            Future.delayed(
                Duration(
                  seconds: 2,
                ), () {
              nextScreen(
                  context,
                  ChatPage(
                      groupId: groupId,
                      groupName: groupName,
                      userName: userName));
            });
          } else {
            setState(() {
              isJoined = !isJoined;
            });
            showSnackBar(context, Colors.red,
                "Successfully Left the Group ${groupName}");
          }
        },
        child: isJoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 146, 72, 211),
                  border: Border.all(
                    color: Color.fromARGB(255, 82, 5, 123),
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "Joined",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Join Now",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
      ),
    );
  }
}
