class Reciever {

  Reciever({this.id, this.usernameof, this.timejob ,  this.token,  this.statusof ,  this.nameof ,  this.emailof , this.urlof , this.timeof , this.isstoryof , this.storytextof , this.storytimeof , this.storyurlof , this.timestr , this.isgroup , this.deletetime , this.lastmsg , this.lstphoto , this.lastsender ,  this.dateof , this.storytimecheck , this.block, this.storyadder , this.chatdate});

  final String id;
  final String usernameof;
  final String statusof;
  final String nameof ;
  final String emailof;
  final String urlof;
  final int timeof;
  final String storyurlof;
  final int storytimeof;
  final String storytextof;
  final bool isstoryof;
  final String timestr;
  final bool isgroup;
  final String token;
  final String timejob;
  final int deletetime;
  final String lastmsg;
  final bool lstphoto;
  final String lastsender;
  final String dateof;
  final int storytimecheck;
  final String block;
  final int storyadder;
  final String chatdate;




  factory Reciever.fromMap ( Map<String , dynamic>data , String documentID) {
    if(data == null){
      return null ;
    }
    final String usernameof = data['usernameof'];
    final String statusof = data['statusof'] ;
    final String nameof = data['nameof'];
    final String emailof = data['emailof'];
    final String urlof = data['urlof'];
    final int timeof = data['timeof'];
    final String storyurlof = data['storyurlof'];
    final int storytimeof = data['storytimeof'];
    final String storytextof = data['storytextof'];
    final bool isstoryof = data['isstoryof'];
    final String timestr = data['timestr'];
    final bool isgroup = data['isgroup'];
    final String token = data['token'];
    final String timejob = data['timejob'];
    final int deletetime = data['deletetime'];
    final String lastmsg = data['lastmsg'];
    final bool lstphoto = data['lstphoto'];
    final String lastsender = data['lastsender'];
    final String dateof = data['dateof'];
    final int storytimecheck = data['storytimecheck'];
    final String block = data['block'];
    final int storyadder = data['storyadder'];
    final String chatdate = data['chatdate'];



    return Reciever(
      id: documentID,
      usernameof: usernameof,
      statusof: statusof,
      nameof : nameof,
      emailof: emailof,
      urlof: urlof,
      timeof: timeof,
        storyurlof:storyurlof,
        storytimeof : storytimeof  ,
      storytextof: storytextof,
        isstoryof : isstoryof,
      timestr: timestr,
        isgroup : isgroup,
      token: token,
        timejob : timejob,
        deletetime : deletetime,
        lastmsg : lastmsg,
        lstphoto : lstphoto,
        lastsender : lastsender,
        dateof : dateof,
        storytimecheck : storytimecheck,
      block: block,
        storyadder : storyadder,
        chatdate : chatdate
    );
  }
  Map <String , dynamic> toMap() {
    return{
      'usernameof' :usernameof,
      'statusof' : statusof,
      'nameof' : nameof,
      'emailof' : emailof,
      'urlof' : urlof,
      'timeof' : timeof,
      'storyurlof' : storyurlof,
      'storytimeof' : storytimeof,
      'storytextof' : storytextof,
      'isstoryof' : isstoryof,
      'timestr' : timestr,
      'isgroup' : isgroup,
      'token' : token,
      'timejob' : timejob,
      'deletetime' : deletetime,
      'lastmsg' : lastmsg,
      'lstphoto' : lstphoto,
      'lastsender' : lastsender,
      'dateof' : dateof,
      'storytimecheck' : storytimecheck,
      'block' : block,
      'storyadder' : storyadder,
      'chatdate' : chatdate
    };
  }

}