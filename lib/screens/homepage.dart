import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messengerapp/screens/chatroom.dart';
class HomePage extends StatefulWidget {
  final String currentuserid;

  HomePage({Key key,@required this.currentuserid}):super(key:key);
  @override
  _HomePageState createState() => _HomePageState(currentuserid:currentuserid);
}

class _HomePageState extends State<HomePage> {

  _HomePageState({Key key,@required this.currentuserid});
  final String currentuserid;
  Widget BuildItem(BuildContext context,DocumentSnapshot document)
  {
    if(document["id"]==currentuserid) 
    {
      return Container();

    }
    else
    {
       return GestureDetector(
         onTap: ()
         {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(peerId: document.documentID)));
         },
                child: Container(
          color: Colors.black26,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
                child: Text(document.data["username"].substring(0, 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'OverpassRegular',
                        fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                width: 12,
              ),
              Text(document.data["username"],
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'OverpassRegular',
                      fontWeight: FontWeight.w300))
            ],
          ),
      ),
       );
    }
   

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
        centerTitle: true,
        
      ),
      body:Container(
        child:StreamBuilder(
          stream:Firestore.instance.collection("user").snapshots(),
          builder: (context,snapshot)
          {
            if(!snapshot.hasData)
            {
              return Center(child: CircularProgressIndicator(),);
            }
            else
            {
              return ListView.builder(
               padding: EdgeInsets.all(10.0),
                itemBuilder: (context,index)=>BuildItem(context,snapshot.data.documents[index]),
                 itemCount: snapshot.data.documents.length,
              );
            }
            

          })
      )


    );
  }
}