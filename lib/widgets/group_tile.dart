import 'package:chat_app/pages/ChatPage.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:flutter/material.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const GroupTile(
      {Key? key,
      required this.groupId,
      required this.userName,
      required this.groupName})
      : super(key: key);
  _GroupTileState createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(
            context,
            ChatPage(
              groupId: widget.groupId,
              groupName: widget.groupName,
              userName: widget.userName,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 28,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          title: Text(
            widget.groupName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(169, 202, 152, 236),
            ),
          ),
        ),
      ),
    );
  }
}
