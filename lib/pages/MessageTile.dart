import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile(
      {super.key,
      required this.message,
      required this.sender,
      required this.sentByMe});

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentByMe ? 0 : 24,
          right: widget.sentByMe ? 24 : 0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        margin: widget.sentByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
            color: widget.sentByMe
                ? Theme.of(context).primaryColor
                : Color.fromARGB(255, 243, 187, 115),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: widget.sentByMe ? Radius.circular(20) : Radius.zero,
                bottomRight:
                    widget.sentByMe ? Radius.zero : Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
