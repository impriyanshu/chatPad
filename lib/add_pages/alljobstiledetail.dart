import 'package:auto_size_text/auto_size_text.dart';
import 'package:chattingapp/Modles/reciever.dart';
import 'package:chattingapp/customs/avatar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllJobsTileDetail extends StatefulWidget {
  AllJobsTileDetail({@required this.job});
  final Reciever job;

  @override
  _AllJobsTileDetailState createState() => _AllJobsTileDetailState();
}

class _AllJobsTileDetailState extends State<AllJobsTileDetail> {



  @override
  Widget build(BuildContext context) {
    print(widget.job.nameof);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile' , style: TextStyle(letterSpacing: 2 , fontWeight: FontWeight.w600),),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: _buildUserInfo(),
        ),
      ),
      body: SingleChildScrollView(child: _bodyinfo()),
    );
  }

  Widget _buildUserInfo() {
    print(widget.job.isgroup);
    return Column(
      children: <Widget>[
        Avatar(
            name : widget.job.nameof.toString(),
            photoUrl: '${widget.job.urlof}',
            radius: 65,
            group : false
        ),
        SizedBox(height: 6),
        Text(
          widget.job.nameof.toString(),
          style: GoogleFonts.acme(
            textStyle : TextStyle(
                letterSpacing: 1,
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.indigo[50]
            ),
          ),
        ),
        SizedBox(height: 15),
      ],
    );
  }

  Widget _bodyinfo() {
    return Column(
      children: <Widget>[
        SizedBox(height: 45,),
        Center(child: Text(
          'Username',
          style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),
        )),
        SizedBox(height: 5,),
        Text(
          widget.job.usernameof.toString(),
          style: GoogleFonts.acme(
            textStyle : TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Colors.indigo[800],
            ),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 25,),
        Center(child: Text(
          'Status',
          style: TextStyle(fontSize: 20 , fontWeight: FontWeight.w700),
        )),
        SizedBox(height: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                widget.job.statusof != null ? widget.job.statusof : "",
                style: GoogleFonts.acme(
                  textStyle : TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[800],
                  ),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 25,),
        Row(
          children: <Widget>[
            SizedBox(
              width: 200,
            ),
            Icon(Icons.email),
            SizedBox(
              width: 95,
            ),
          ],
        ),
        SizedBox(height: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: AutoSizeText(
                widget.job.emailof != null ? widget.job.emailof : "",
                style: GoogleFonts.acme(
                  textStyle : TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.indigo[800],
                  ),
                ),
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
