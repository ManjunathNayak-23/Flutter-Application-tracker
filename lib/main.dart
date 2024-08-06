import 'package:flutter/material.dart';
import 'package:versiontracker/screens/bbdashboard.dart';
import 'package:versiontracker/screens/ccdashboard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
      home: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/beachcover.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(0, 0, 0, 0.5),
            title: const Center(
              child: Text(
                "ALG Version Tracker",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: HoverableContainerRow(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HoverableContainerRow extends StatefulWidget {
  const HoverableContainerRow({super.key});

  @override
  _HoverableContainerRowState createState() => _HoverableContainerRowState();
}

class _HoverableContainerRowState extends State<HoverableContainerRow> {
  bool _isHovered1 = false;
  bool _isHovered2 = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        return isMobile ? _buildColumnLayout() : _buildRowLayout();
      },
    );
  }

  Widget _buildRowLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildHoverableContainers(),
    );
  }

  Widget _buildColumnLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildHoverableContainers(),
    );
  }

  List<Widget> _buildHoverableContainers() {
    return [
      _buildHoverableContainer(
        "assets/bb-logo.svg",
        _isHovered1,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BBDashboard()),
          );
        },
        (hovered) {
          setState(() {
            _isHovered1 = hovered;
          });
        },
      ),
      const SizedBox(
          width: 40, height: 20), // Adjust height for spacing in column
      _buildHoverableContainer(
        "assets/cc-logo.svg",
        _isHovered2,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CCDashboard()),
          );
        },
        (hovered) {
          setState(() {
            _isHovered2 = hovered;
          });
        },
      ),
    ];
  }

  Widget _buildHoverableContainer(String imageUrl, bool isHovered,
      VoidCallback onClick, ValueChanged<bool> onHover) {
    return GestureDetector(
      onTap: onClick,
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: isHovered ? 220 : 200,
          width: isHovered ? 220 : 200, // Adjusted for mobile responsiveness
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isHovered)
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SvgPicture.asset(imageUrl),
          ),
        ),
      ),
    );
  }
}
