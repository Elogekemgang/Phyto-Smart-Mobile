import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/diagnosis_screen.dart';
import 'package:phytosmart_mobile/screens/home.dart';
import 'package:phytosmart_mobile/screens/navigation/culturescreen.dart';
import 'package:phytosmart_mobile/screens/navigation/profilescreen.dart';
import 'package:phytosmart_mobile/screens/analyse/resultatscreen.dart';
import 'package:phytosmart_mobile/services/notification_service.dart';

import 'screens/analyse/analyseaiscreen.dart';
import 'screens/navigation/diagnoticscreen.dart';
import 'screens/analyse/historyscreen.dart';
import 'screens/navigation/homescreen.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}
List<Widget> pages = [
  const HomeScreen(),
  const CulturesScreen(),
  const DiagnosticScreen(),
  //const DiagnosisScreen(),
  //const ResultatsScreen(),
  Home(),
  const ProfilScreen(),

];
int _currentIndex = 0;

const _green1 = Color(0xFF1B5E20);   // titres
const _green2 = Color(0xFF2E7D32);   // primaire
const _green3 = Color(0xFF4CAF50);   // boutons / icônes
const _green4 = Color(0xFFE8F5E9);   // fonds cards verts clairs
const _green5 = Color(0xFFC8E6C9);   // bordures vertes
const _blue1  = Color(0xFF0D47A1);   // "Smart"
const _blue2  = Color(0xFF1565C0);
const _orange = Color(0xFFFF6F00);   // heure critique
const _textDark = Color(0xFF212121);
const _textMed  = Color(0xFF616161);
const _textLight = Color(0xFF9E9E9E);


class _NavigationState extends State<Navigation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Phyto ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _green2,
                ),
              ),
              TextSpan(
                text: 'Smart',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _blue1,
                ),
              ),
            ],
          ),
        ),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Image.asset("assets/logo/logo_b.png"),
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: (){
                    NotificationService.showNotification(
                      id: 1,

                      title: "Traitement agricole",

                      body: "Pulvériser insecticide XYZ",
                    );
                  },
                  child: const Icon(Icons.notifications_outlined,
                      color: _textDark, size: 22),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text('3',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 10,),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _green3, width: 2.2),
              // Remplacer par Image.asset / Image.network

            ),
            child: ClipOval(
              child: Image.asset("assets/avatar.png",fit: BoxFit.cover,),
            ),
          ),
          SizedBox(width: 10,),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        currentIndex: _currentIndex,
        selectedLabelStyle: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),
        unselectedItemColor: Colors.green.shade300,
        selectedItemColor: Colors.green.shade800,
        showUnselectedLabels: true,
        onTap:(a){
          setState(() {
            _currentIndex = a;
          });
        } ,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined,),label: "Accueil",),
            BottomNavigationBarItem(icon: Icon(Icons.energy_savings_leaf,),label: "Cultures",),
            BottomNavigationBarItem(icon: Icon(Icons.camera_alt_outlined,),label: "Diagnostic",),
            BottomNavigationBarItem(icon: Icon(Icons.work_history_outlined,),label: "Test",),
            BottomNavigationBarItem(icon: Icon(Icons.person,),label: "Profil",),

      ]),
      body: pages[_currentIndex],
    );
  }
}
