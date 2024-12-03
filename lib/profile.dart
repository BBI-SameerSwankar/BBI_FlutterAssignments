import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
    bool _toggleDesc = false;

    
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;  
    double screenHeight = MediaQuery.of(context).size.height; 

    return Scaffold(
      body: SingleChildScrollView(  // Make entire screen scrollable
        child: screenWidth < 600  
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  
                  children: [
                    ProfilePicture(),
                    SizedBox(height: 30),
                    ProfileName(),
                    SizedBox(height: 30),
                    ProfileDescription(),
                    SizedBox(height: 30),
                    DividerWidget(),
                    SizedBox(height: 30),
                    SocialMediaIcons(),
                  ],
                ),
              )
            : Center(
              
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
                  child: Row(
                    
                    children: [
                      Expanded( 
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            print(screenHeight);
                            setState(() {
                              _toggleDesc = !_toggleDesc;
                            });
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ProfilePicture(),
                              SizedBox(height: 30),
                              ProfileName(),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(width: 30), 
                      Container(height: screenHeight*1,width: 1,color: Colors.grey,
                      margin: EdgeInsets.only(right: 10),),

                      Expanded(
                    flex: 2,
                        child: AnimatedOpacity(
                          
                          duration: Duration(seconds: 1),
                          opacity: _toggleDesc ? 1.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 30),
                                ProfileDescription(),
                                SizedBox(height: 30),
                                DividerWidget(),
                                SizedBox(height: 30),
                                SocialMediaIcons(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}

// Profile Picture Widget
class ProfilePicture extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      maxRadius: 100,
    );
  }
}


class ProfileName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Sameer Swankar",
      style: TextStyle(fontSize: 20),
    );
  }
}


class ProfileDescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Hi, I'm Jose Mourinho, a dedicated Software Developer currently working at BBI. I specialize in Flutter and Web Development, and I'm passionate about building beautiful, scalable applications that solve real-world problems.",
      style: TextStyle(),
      textAlign: TextAlign.justify,
    );
  }
}


class DividerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      width: double.infinity,
      color: Colors.black,
    );
  }
}

// Social Media Icons Widget
class SocialMediaIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        Icon(FontAwesomeIcons.github),
        Icon(FontAwesomeIcons.instagram),
        Icon(FontAwesomeIcons.twitter),
        Icon(FontAwesomeIcons.linkedin),
      ],
    );
  }
}
