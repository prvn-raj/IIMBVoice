import 'package:flutter/material.dart';
import 'radio_controller.dart';
import 'azura_service.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _radioController = RadioController();
  final _azuraService = AzuraService();
  String _currentPlaying = "Loading...";
  bool _isPlaying = false;
  bool _isButtonPressed = false;
  double _progressValue = 0.0; // Progress value for the progress bar
  bool _isDarkTheme = false;


  @override
  void initState() {
    super.initState();
    _fetchCurrentPlaying();
  }
  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }


  _fetchCurrentPlaying() async {
    final data = await _azuraService.fetchNowPlaying();
    if (data != null) {
      setState(() {
        _currentPlaying = data['now_playing']['song']['title'];
        // Assuming the JSON has a key 'elapsed' for elapsed time and 'duration' for total duration
        double elapsed = double.parse(data['now_playing']['elapsed'].toString());
        double duration = double.parse(data['now_playing']['duration'].toString());
        _progressValue = duration > 0 ? elapsed / duration : 0.0;
      });
    } else {
      setState(() {
        _currentPlaying = "Unable to fetch track details";
      });
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Only Believe-Live Radio(தமிழ்) v1.0",
            style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
            fontFamily: 'Nunito',
          ),),
          content: Text("எங்கள் தமிழ் வானொலி நிலையத்திற்கு வரவேற்கிறோம் 🙏 \n\n" "சகோதரர் வில்லியம் மேரியன் பிரான்ஹாமின்👼 ஞானப் பிரசங்கங்களை ஒலிபரப்புவதற்கு நாங்கள் அர்ப்பணித்துள்ளோம்.\n\n""இந்த ஆழமான செய்திகள் அனைத்தும் 'வாய்ஸ் ஆஃப் காட் ரெக்கார்டிங்ஸ்📖' மூலம் அன்புடன் வழங்கப்படுகின்றன.\n\n" "உங்களை கடவுளின் வார்த்தையுடன் இணைக்கவும், போதனைகளை உள்வாங்கவும், அவை உள்ளுக்குள் எதிரொலிக்கவும் உங்களை அழைக்கிறோம். நீங்கள் கேட்கும் போது கடவுள் உங்களை மிகுதியாக ஆசீர்வதிப்பாராக ✝️ "),
          actions: [
            TextButton(
              child: Text("Close",
                style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.lightBlue[300],
          fontFamily: 'Nunito',
        ),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.info_rounded),
                  color: _isDarkTheme ? Colors.white : Colors.grey[800],
                  onPressed: _showInfoDialog,
                ),
                IconButton(
                  icon: Icon(_isDarkTheme ? Icons.brightness_7 : Icons.brightness_4),
                  color: _isDarkTheme ? Colors.white : Colors.grey[800],
                  onPressed: _toggleTheme,
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400]!,
                          offset: Offset(-4, -4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.blueGrey,
                          offset: Offset(4, 4),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                        radius: 100,
                        backgroundImage: AssetImage('assets/images/WMB2.jpg')
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Only Believe - Live Radio\n""                 தமிழ்",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                      fontFamily: 'Nunito',
                    ),
                  ),
                  SizedBox(height: 90),
                  Text(
                    _currentPlaying,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                      fontFamily: 'OneDay',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: LinearProgressIndicator(
                      value: _progressValue, // Updated value
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        LinearGradient(
                          colors: [Colors.blue, Colors.lightBlue.shade300],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).colors.last,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: _convexButton(
              onPressed: () {
                if (_isPlaying) {
                  _radioController.stopRadio();
                  setState(() {
                    _currentPlaying = "Stopped";
                    _isPlaying = false;
                  });
                } else {
                  _radioController.playRadio();
                  _fetchCurrentPlaying();
                  setState(() {
                    _isPlaying = true;
                  });
                }
              },
              icon: _isPlaying ? Icons.stop : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }


  Widget _convexButton({required VoidCallback onPressed, required IconData icon}) {
    Color backgroundColor = _isDarkTheme ? (Colors.grey[800] ?? Colors.grey) : (Colors.grey[300] ?? Colors.grey);
    Color boxShadowColor = _isDarkTheme ? (Colors.grey[600] ?? Colors.grey) : (Colors.grey[400] ?? Colors.grey);
    Color iconColor = _isDarkTheme ? Colors.white : (Colors.lightBlue[300] ?? Colors.lightBlue);



    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          _isButtonPressed = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          _isButtonPressed = false;
        });
        onPressed();
      },
      onTapCancel: () {
        setState(() {
          _isButtonPressed = false;
        });
      },
      child: Transform.scale(
        scale: _isButtonPressed ? 0.9 : 1.0,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(40),
            boxShadow: _isButtonPressed
                ? [
              BoxShadow(
                color: boxShadowColor,
                offset: Offset(4, 4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ]
                : [
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 10,
                spreadRadius: 1,
              ),
              BoxShadow(
                color: boxShadowColor,
                offset: Offset(4, 4),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, size: 40, color: iconColor),
          ),
        ),
      ),
    );
  }

}
