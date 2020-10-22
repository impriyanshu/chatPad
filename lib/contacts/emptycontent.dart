import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {

  EmptyContent({Key key , this.title : 'Chatbox is empty' , this.content : 'Press menu button to add users'});
  final String title;
  final String content;


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 220,
            width: 200,
            child: Image(
              image: AssetImage('images/oops1.png'),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 32,
              color: Colors.black38,
            ),
          ),
          SizedBox(height: 8,),
          Text(
            content,
            style: TextStyle(
              fontSize: 24,
              color: Colors.black38,
            ),
          )
        ],
      ),
    );
  }
}
