import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ChatScreen extends StatefulWidget {
final String peerId;
  ChatScreen({Key key, @required this.peerId}) : super(key: key);

  @override
  State createState() => ChatScreenState(peerId: peerId);
}

class ChatScreenState extends State<ChatScreen> {
  ChatScreenState({Key key, @required this.peerId});
 String peerId;
  String id;
  String groupChatId;
  SharedPreferences prefs;
  final TextEditingController textEditingController = TextEditingController();
  // final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    groupChatId='';
    readlocal();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Chat da')
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buildmessage(),
              buildInput()
            ],
          ),
        ],
      ),
    );
  }
   readlocal() async{
prefs = await SharedPreferences.getInstance();
id = prefs.getString("id");
if(id.hashCode<=peerId.hashCode)
{
  groupChatId = '$peerId-$id';

}
else
{
  groupChatId ='$peerId-$id';

}
Firestore.instance.collection("user").document(id).updateData({"chattingwith":peerId});

}
addmessage()
  {
    if(textEditingController.text.isNotEmpty)
    {
      Firestore.instance.collection("messages").document(groupChatId).collection(groupChatId).add({"idfrom":id,"idto":peerId,"message":textEditingController.text,"time":DateTime.now().millisecondsSinceEpoch});

    }
  }
  Widget buildmessage(){
    return StreamBuilder(
      stream: Firestore.instance.collection("messages").document(groupChatId).collection(groupChatId).orderBy('time',descending: false).snapshots(),
      builder: (context, snapshot){
        return snapshot.hasData?ListView.builder(
          itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(
                message: snapshot.data.documents[index].data["message"],
                sendByMe: id == snapshot.data.documents[index].data["idfrom"],
              );
            }) : Container(child: Text('munji mwonuse'),);
      }
    );
  }
    Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => addmessage(),
                color: Colors.grey,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }
  }
class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;

  MessageTile({this.message,this.sendByMe});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only( 
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(message,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}
