
import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({Key key, this.photoUrl, @required this.radius, @required this.name,  @required this.group}) : super(key: key);
  final String photoUrl;
  final double radius;
  final String name;
  final bool group;

  @override
  Widget build(BuildContext context) {
    print(photoUrl);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black54,
          width: 3.0,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.black12,
        backgroundImage: photoUrl != 'null' ? NetworkImage('$photoUrl') : group == false ? AssetImage('images/${name[0]}.png') : AssetImage('images/group_icon.png'),
        child: photoUrl == null ? Icon(Icons.camera_alt, size: radius) : null,
      ),
    );
  }
}
