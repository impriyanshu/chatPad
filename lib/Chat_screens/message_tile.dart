import 'package:chattingapp/Modles/username.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool sendByMe;
  final bool isimage;
  final bool isgroup;
  final String sendby;
  final bool sending;
  final String sendTo;
  final bool activity;
  final int time;
  final int msgtime;
  final UsernameClass usernameClass;
  final String lastsender;
  final String senderusername;
  final String timeshow;
  final String lastchatdate;
  final String nowchatdate;
  final bool storyreply;
  final bool creatednow;
  final String createdtime;
  final String groupusernamename;

  MessageTile({Key key ,@required this.message, @required this.sendByMe , @required this.isimage , @required this.isgroup , @required this.sendby , this.sending , this.sendTo , this.activity, this.time, @required this.msgtime, @required this.usernameClass , this.lastsender , this.senderusername , this.timeshow, this.lastchatdate, this.nowchatdate, this.storyreply ,this.creatednow , this.createdtime , this.groupusernamename}): super (key : key);


  @override
  Widget build(BuildContext context) {

    print(lastchatdate);
    print(nowchatdate);
    String by;
    String to;

    by = usernameClass.username == senderusername ? "You" : senderusername;
    to = usernameClass.username == sendTo ? "you" : sendTo;

    void showimage() {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) =>
            Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(''),
                centerTitle: true,
                actions: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(right: 20),
                  )
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage('$message')
                    )
                ),
              ),
            ),
      )

      );
    }
    return isgroup == true && creatednow==true ?
    Column(
      children: <Widget>[
        Container( padding: EdgeInsets.only(
            top: 10,
            bottom: 10,
            left: 10,
            right:  10 ),
          alignment: Alignment.center,
          child: Container(
            padding:EdgeInsets.only(
                top: 5, bottom: 5, left: 8, right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8) ,
                gradient: activity == true ? LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                ) : LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                )
            ),
            child: Text( createdtime == DateFormat("dd/MM/yyyy").format(DateTime.now()) ? 'Today' :  '$createdtime',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Notable',
                    fontWeight: FontWeight.w400)),
          ),),
        Container( padding: EdgeInsets.only(
            top: 10,
            bottom: 5,
            left: 10,
            right:  10 ),
          alignment: Alignment.center,
          child: Container(
            padding:EdgeInsets.only(
                top: 5, bottom: 5, left: 8, right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8) ,
                gradient: activity == true ? LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                ) : LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                )
            ),
            child: Text( '$by' + ' created group " $groupusernamename"',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Notable',
                    fontWeight: FontWeight.w400)),
          ),),
      ],
    )



        :  isgroup  == true  && ( msgtime < time||  msgtime == time ) ? SizedBox(height: 0,) : sending == true ? Column(
      children: <Widget>[
        Container( padding: EdgeInsets.symmetric(vertical: 12),
          alignment: Alignment.center,
          child: Container(
              padding:EdgeInsets.only(
                  top: 5, bottom: 5, left: 8, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8) ,
                  gradient: activity == true ? LinearGradient(
                    colors: [
                      const Color(0xFF00838F),
                      const Color(0xFF00838F)
                    ],
                  ) : LinearGradient(
                    colors: [
                      const Color(0xFF00838F),
                      const Color(0xFF00838F)
                    ],
                  )
              ),
              child: Text( activity == true ? "$by left" : " $by added $to",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Notable',
                      fontWeight: FontWeight.w400)),
          ),),
      ],
    ) : Column(
      children: <Widget>[
        nowchatdate == lastchatdate || lastchatdate == null?   SizedBox(width: 0,) : Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding:EdgeInsets.only(
                top: 5, bottom: 5, left: 8, right: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8) ,
                gradient: activity == true ? LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                ) : LinearGradient(
                  colors: [
                    const Color(0xFF00838F),
                    const Color(0xFF00838F)
                  ],
                )
            ),
            child: Text( nowchatdate == DateFormat("dd/MM/yyyy").format(DateTime.now()) ? 'Today' :  '$nowchatdate',
                textAlign: TextAlign.start,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Notable',
                    fontWeight: FontWeight.w400)),
          ),
        ) ,
        isgroup == true && sendByMe == false ? Container(padding : EdgeInsets.only(right: 280 , top: 5) , child: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            children: <Widget>[
              Text( '$senderusername' , style: TextStyle(color: Colors.grey[400] ,fontWeight: FontWeight.w300 )),
            ],
          ),
        )) : SizedBox(height: 0,),
        Container( padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: sendByMe ? 0 : 10,
            right: sendByMe ? 10 : 0),
          alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              storyreply == true ?Container(
                padding: const EdgeInsets.only(bottom: 5 , top: 10),
                child: Text('STORY REPLY . . .' , style: TextStyle(color: Colors.yellow , fontSize: 15 , fontWeight: FontWeight.w400),),
              ) : SizedBox(height: 0,),
              Container(
                  margin: sendByMe
                      ? EdgeInsets.only(left: 50)
                      : EdgeInsets.only(right: 50),
                  padding: isimage == true ? EdgeInsets.all(2) : EdgeInsets.only(
                      top: 12, bottom: 12, left: 20, right: 20),
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
                  child: isimage == false ? Column(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                                            text: message +"\t\t\t\t\t",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontFamily: 'Notable',
                                                fontWeight: FontWeight.w400),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: timeshow,
                                                style: TextStyle(
                                                  color: Colors.indigo[100],
                                                  fontSize: 12.5,
                                                ),
                                              ),
                                            ]),
                                      ),
                    ],
                  )
                                : FlatButton(
                                    padding: EdgeInsets.all(0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                                '$message' , fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context , Widget child , ImageChunkEvent loadingProgress){
                                  if(loadingProgress == null)
                                    return child;
                                  return Center(
                                    child : CircularProgressIndicator()
                                  );
                              }
                            )
                          ),
                          width: 280,
                          height:  280,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: Text('\n' + timeshow , style: TextStyle(fontSize: 12.5 , color: Colors.indigo[100]),),
                        )
                      ],
                    ),
                    onPressed:()=> showimage(),
                  )
              ),
            ],
          ),),
      ],
    );

  }




}
