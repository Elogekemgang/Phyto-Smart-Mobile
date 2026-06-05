import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phytosmart_mobile/screens/cultures/culture.dart';

// ─────────────────────────────────────────────
//  PALETTE
// ─────────────────────────────────────────────
const _green1   = Color(0xFF1B5E20);
const _green2   = Color(0xFF2E7D32);
const _green3   = Color(0xFF4CAF50);
const _green4   = Color(0xFFE8F5E9);
const _green5   = Color(0xFFF1F8E9);
const _green6   = Color(0xFFC8E6C9);
const _blue1    = Color(0xFF0D47A1);
const _blue2    = Color(0xFF1565C0);
const _blueBg   = Color(0xFFE3F2FD);
const _purple   = Color(0xFF6A1B9A);
const _purpleBg = Color(0xFFF3E5F5);
const _orange   = Color(0xFFE65100);
const _orangeBg = Color(0xFFFFF3E0);
const _textDk   = Color(0xFF1A1A1A);
const _textMd   = Color(0xFF616161);
const _textLt   = Color(0xFF9E9E9E);
const _divider  = Color(0xFFF2F2F2);

// ─────────────────────────────────────────────
//  DATA MODELS
// ─────────────────────────────────────────────
enum _CropType { mais, piment, tomate, manioc }

class _CropCard {
  final String name, parcelle, surface, statusLabel;
  final Color statusBg, statusTxt;
  final double progress;
  final Color progressColor;
  final _CropType type;
  const _CropCard({
    required this.name, required this.parcelle, required this.surface,
    required this.statusLabel, required this.statusBg, required this.statusTxt,
    required this.progress, required this.progressColor, required this.type,
  });
}

enum _CalStatus { done, today, upcoming }

class _CalEvent {
  final String title, subtitle, date, statusLabel;
  final Color dateColor;
  final _CalStatus status;
  final _CalIcon icon;
  const _CalEvent({
    required this.title, required this.subtitle, required this.date,
    required this.statusLabel, required this.dateColor,
    required this.status, required this.icon,
  });
}

enum _CalIcon { semis, arrosage, fertilisation, traitement }

// ─────────────────────────────────────────────
//  CULTURES SCREEN
// ─────────────────────────────────────────────
class CulturesScreen extends StatelessWidget {
  const CulturesScreen({super.key});

  static const _crops = [
    _CropCard(name:'Maïs', parcelle:'Parcelle 1', surface:'10 m²',
        statusLabel:'En croissance', statusBg:Color(0xFFE8F5E9), statusTxt:Color(0xFF2E7D32),
        progress:0.65, progressColor:Color(0xFF4CAF50), type:_CropType.mais),
    _CropCard(name:'Piment', parcelle:'Parcelle 2', surface:'8 m²',
        statusLabel:'En croissance', statusBg:Color(0xFFE8F5E9), statusTxt:Color(0xFF2E7D32),
        progress:0.40, progressColor:Color(0xFF4CAF50), type:_CropType.piment),
    _CropCard(name:'Tomate', parcelle:'Parcelle 1', surface:'12 m²',
        statusLabel:'En croissance', statusBg:Color(0xFFE8F5E9), statusTxt:Color(0xFF2E7D32),
        progress:0.70, progressColor:Color(0xFF4CAF50), type:_CropType.tomate),
    _CropCard(name:'Manioc', parcelle:'Parcelle 3', surface:'15 m²',
        statusLabel:'Plantation', statusBg:Color(0xFFE3F2FD), statusTxt:Color(0xFF1565C0),
        progress:0.18, progressColor:Color(0xFF42A5F5), type:_CropType.manioc),
  ];

  static const _events = [
    _CalEvent(title:'Semis', subtitle:'Piment – Parcelle 2',
        date:'12 Mai 2024', statusLabel:'Terminé',
        dateColor:_green2, status:_CalStatus.done, icon:_CalIcon.semis),
    _CalEvent(title:'Arrosage', subtitle:'Maïs – Parcelle 1',
        date:'16 Mai 2024', statusLabel:"Aujourd'hui",
        dateColor:_orange, status:_CalStatus.today, icon:_CalIcon.arrosage),
    _CalEvent(title:'Fertilisation', subtitle:'Tomate – Parcelle 1',
        date:'20 Mai 2024', statusLabel:'À venir',
        dateColor:_blue2, status:_CalStatus.upcoming, icon:_CalIcon.fertilisation),
    _CalEvent(title:'Traitement phytosanitaire', subtitle:'Piment – Parcelle 2',
        date:'23 Mai 2024', statusLabel:'À venir',
        dateColor:_blue2, status:_CalStatus.upcoming, icon:_CalIcon.traitement),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHero()),
          SliverToBoxAdapter(child: const SizedBox(height: 20)),
          SliverPadding(padding:const EdgeInsets.symmetric(horizontal:18),
              sliver:SliverToBoxAdapter(child: _buildQuickActions())),
          SliverToBoxAdapter(child: const SizedBox(height: 28)),
          SliverToBoxAdapter(child: _buildSectionHeader('Mes cultures')),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverToBoxAdapter(child: _buildCulturesRow()),
          SliverToBoxAdapter(child: const SizedBox(height: 22)),
          SliverPadding(padding:const EdgeInsets.symmetric(horizontal:18),
              sliver:SliverToBoxAdapter(child: _buildRecoCard())),
          SliverToBoxAdapter(child: const SizedBox(height: 26)),
          SliverToBoxAdapter(child: _buildSectionHeader('Calendrier de culture')),
          SliverToBoxAdapter(child: const SizedBox(height: 14)),
          SliverPadding(padding:const EdgeInsets.symmetric(horizontal:18),
              sliver:SliverToBoxAdapter(child: _buildCalendar())),
          SliverToBoxAdapter(child: const SizedBox(height: 16)),
          SliverPadding(padding:const EdgeInsets.symmetric(horizontal:18),
              sliver:SliverToBoxAdapter(child: _buildAddCard())),
          SliverToBoxAdapter(child: const SizedBox(height: 32)),
        ],
      ),
    );
  }

  // ── APP BAR ────────────────────────────────────────────────────────────
  Widget _buildAppBar() => Padding(
    padding: const EdgeInsets.fromLTRB(18, 12, 16, 8),
    child: Row(children: [
      SizedBox(width:42, height:42, child:CustomPaint(painter:_PSLogoPainter())),
      const SizedBox(width:10),
      RichText(text:const TextSpan(children:[
        TextSpan(text:'Phyto ', style:TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:_green2)),
        TextSpan(text:'Smart', style:TextStyle(fontSize:21,fontWeight:FontWeight.w800,color:_blue1)),
      ])),
      const Spacer(),
      Stack(clipBehavior:Clip.none, children:[
        _CircBtn(child:const Icon(Icons.notifications_outlined,color:_textDk,size:22)),
        Positioned(top:-3,right:-3,child:Container(
          width:19,height:19,
          decoration:const BoxDecoration(color:Colors.red,shape:BoxShape.circle),
          child:const Center(child:Text('3',style:TextStyle(color:Colors.white,fontSize:10,fontWeight:FontWeight.w800))),
        )),
      ]),
      const SizedBox(width:10),
      Container(
        width:42,height:42,
        decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:_green6,width:2.2)),
        child:ClipOval(child:CustomPaint(painter:_AvatarPainter())),
      ),
    ]),
  );

  // ── HERO ───────────────────────────────────────────────────────────────
  Widget _buildHero() => Padding(
    padding:const EdgeInsets.fromLTRB(18,8,18,0),
    child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[
      const Text('Cultures', style:TextStyle(fontSize:34,fontWeight:FontWeight.w900,color:_green1,height:1.1)),
      const SizedBox(height:5),
      const Text('Gérez vos cultures et améliorez vos rendements',
          style:TextStyle(fontSize:14,color:_textMd)),
    ]),
  );

  // ── 4 ACTIONS RAPIDES ──────────────────────────────────────────────────
  Widget _buildQuickActions() {
    final actions = [
      _QuickData('Recommandations','Cultures adaptées',_green4,Icons.eco_outlined,_green2),
      _QuickData('Calendrier','Plan de culture',_blueBg,Icons.calendar_month_outlined,_blue2),
      _QuickData('Suivi','Suivre mes cultures',_green4,Icons.trending_up_rounded,_green2),
      _QuickData('Rendements','Estimations',_purpleBg,Icons.bar_chart_rounded,_purple),
    ];
    return Row(children: actions.map((a) => Expanded(child: Padding(
      padding:EdgeInsets.only(right: actions.indexOf(a)<3?10:0),
      child:_QuickCard(data:a),
    ))).toList());
  }

  // ── CULTURES HORIZONTALES ──────────────────────────────────────────────
  Widget _buildCulturesRow() => SizedBox(
    height:262,
    child:ListView.separated(
      scrollDirection:Axis.horizontal,
      padding:const EdgeInsets.symmetric(horizontal:18),
      physics:const BouncingScrollPhysics(),
      itemCount:_crops.length,
      separatorBuilder:(_,__)=>const SizedBox(width:14),
      itemBuilder:(_,i)=>_CultureCard(crop:_crops[i]),
    ),
  );

  // ── RECOMMANDATIONS ZONE ───────────────────────────────────────────────
  Widget _buildRecoCard() => Container(
    padding:const EdgeInsets.fromLTRB(8,12,12,12),
    decoration:BoxDecoration(
      color:_green5,
      borderRadius:BorderRadius.circular(12),
      border:Border.all(color:_green6,width:1),
    ),
    child:Row(children:[
      SizedBox(width:35,height:35,child:Icon(Icons.location_on_outlined,size: 35,color: _green2,)),
      const SizedBox(width:8),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('Recommandations pour votre zone',
            style:TextStyle(fontSize:13.5,fontWeight:FontWeight.w800,color:_textDk)),
        const SizedBox(height:3),
        const Text('Basées sur votre sol, climat et saison actuelle',
            style:TextStyle(fontSize:12,color:_textMd)),
      ])),
      const SizedBox(width:8),
      GestureDetector(child:Container(
        padding:const EdgeInsets.symmetric(horizontal:14,vertical:12),
        decoration:BoxDecoration(color:_green2,borderRadius:BorderRadius.circular(12)),
        child: const Text('Voir les cultures \nrecommandées',textAlign: TextAlign.center,
              style:TextStyle(fontSize:11.5,fontWeight:FontWeight.w700,color:Colors.white)),

      )),
    ]),
  );

  // ── CALENDRIER SECTION ─────────────────────────────────────────────────
  Widget _buildCalendar() => Container(
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(16),
      border:Border.all(color:const Color(0xFFF0F0F0),width:1),
      boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:14,offset:const Offset(0,2))],
    ),
    child:Column(children:List.generate(_events.length,(i)=>Column(children:[
      _CalRow(event:_events[i]),
      if(i<_events.length-1) const Divider(height:1,thickness:1,color:_divider,indent:72,endIndent:0),
    ]))),
  );

  // ── AJOUTER CULTURE ────────────────────────────────────────────────────
  Widget _buildAddCard() => GestureDetector(
    child:Container(
      padding:const EdgeInsets.symmetric(horizontal:16,vertical:16),
      decoration:BoxDecoration(
        color:_green5,
        borderRadius:BorderRadius.circular(16),
        border:Border.all(color:_green6,width:1),
      ),
      child:Row(children:[
        Container(width:46,height:46,
            decoration:const BoxDecoration(color:_green4,shape:BoxShape.circle),
            child:const Center(child:Icon(Icons.calendar_today_outlined,color:_green2,size:22))),
        const SizedBox(width:14),
        Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Text('Ajouter une nouvelle culture',
              style:TextStyle(fontSize:14,fontWeight:FontWeight.w800,color:_green2)),
          const SizedBox(height:3),
          const Text('Démarrer une nouvelle culture dans votre parcelle',
              style:TextStyle(fontSize:12.5,color:_textMd)),
        ])),
        const Icon(Icons.chevron_right_rounded,color:_textMd,size:22),
      ]),
    ),
  );

  // ── SECTION HEADER ─────────────────────────────────────────────────────
  Widget _buildSectionHeader(String title) => Padding(
    padding:const EdgeInsets.symmetric(horizontal:18),
    child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
      Text(title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800,color:_textDk)),
      TextButton(onPressed:(){},
          style:TextButton.styleFrom(padding:EdgeInsets.zero,minimumSize:Size.zero,
              tapTargetSize:MaterialTapTargetSize.shrinkWrap),
          child:const Text('Voir tout',style:TextStyle(fontSize:14,color:_green3,fontWeight:FontWeight.w600))),
    ]),
  );
}

// ─────────────────────────────────────────────
//  QUICK ACTION DATA + CARD
// ─────────────────────────────────────────────
class _QuickData {
  final String title, sub;
  final Color bg;
  final IconData icon;
  final Color iconColor;
  const _QuickData(this.title, this.sub, this.bg, this.icon, this.iconColor);
}

class _QuickCard extends StatelessWidget {
  final _QuickData data;
  const _QuickCard({required this.data});
  @override
  Widget build(BuildContext context) => Container(
    padding:const EdgeInsets.symmetric(horizontal:8,vertical:8),
    decoration:BoxDecoration(
      color:Colors.white,
      borderRadius:BorderRadius.circular(8),
      border:Border.all(color:const Color(0xFFF0F0F0),width:1),
      boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.05),blurRadius:10,offset:const Offset(0,2))],
    ),
    child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
      Container(width:48,height:48,
          decoration:BoxDecoration(color:data.bg,shape:BoxShape.circle),
          child:Icon(data.icon,color:data.iconColor,size:24)),
      const SizedBox(height:10),
      Text(data.title,textAlign:TextAlign.center,
          style:const TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:_textDk),maxLines:1),
      const SizedBox(height:2),
      Text(data.sub,textAlign:TextAlign.center,
          style:const TextStyle(fontSize:10.5,color:_textLt),maxLines:1,overflow:TextOverflow.ellipsis),
    ]),
  );
}

// ─────────────────────────────────────────────
//  CULTURE CARD
// ─────────────────────────────────────────────
class _CultureCard extends StatelessWidget {
  final _CropCard crop;
  const _CultureCard({required this.crop});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CultureDetailScreen()));
      },
      child: Container(
        width:150,
        decoration:BoxDecoration(
          color:Colors.white,
          borderRadius:BorderRadius.circular(16),
            border: Border.all(color: _green6)
            //boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.08),blurRadius:14,offset:const Offset(0,3))],
        ),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          // Photo + badge emoji
          Stack(children:[
            Column(
              children: [
                ClipRRect(
                  borderRadius:const BorderRadius.only(topLeft:Radius.circular(16),topRight:Radius.circular(16)),
                  child:SizedBox(width:158,height:110,
                      child:Image.asset("assets/plantes/tomate.jpg",fit: BoxFit.cover,)),
                ),
                Padding(
                  padding:const EdgeInsets.fromLTRB(10,12,10,12),
                  child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text(crop.name,style:const TextStyle(fontSize:15,fontWeight:FontWeight.w800,color:_textDk)),
                    const SizedBox(height:6),
                    // Badge statut
                    Container(
                      padding:const EdgeInsets.symmetric(horizontal:9,vertical:3.5),
                      decoration:BoxDecoration(color:crop.statusBg,borderRadius:BorderRadius.circular(20)),
                      child:Text(crop.statusLabel,style:TextStyle(fontSize:11,fontWeight:FontWeight.w600,color:crop.statusTxt)),
                    ),
                    const SizedBox(height:8),
                    // Parcelle
                    Row(children:[
                      const Icon(Icons.location_on_outlined,size:13,color:_textLt),
                      const SizedBox(width:3),
                      Text(crop.parcelle,style:const TextStyle(fontSize:11.5,color:_textMd)),
                    ]),
                    const SizedBox(height:3),
                    // Surface
                    Row(children:[
                      const Icon(Icons.crop_square_rounded,size:13,color:_textLt),
                      const SizedBox(width:3),
                      Text(crop.surface,style:const TextStyle(fontSize:11.5,color:_textMd)),
                    ]),
                    const SizedBox(height:9),
                    // Progress
                    Row(children:[
                      Expanded(child:ClipRRect(
                        borderRadius:BorderRadius.circular(4),
                        child:LinearProgressIndicator(
                          value:crop.progress,minHeight:5,
                          backgroundColor:const Color(0xFFE0E0E0),
                          color:crop.progressColor,
                        ),
                      )),
                      const SizedBox(width:6),
                      Text('${(crop.progress*100).toInt()}%',
                          style:const TextStyle(fontSize:11,fontWeight:FontWeight.w700,color:_textMd)),
                    ]),
                  ]),
                ),
              ],
            ),
            // Badge icône en bas-gauche
            Positioned(top:88,left:20,child:Container(
              width:34,height:34,
              decoration:BoxDecoration(color:Colors.white,shape:BoxShape.circle,
                  boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.12),blurRadius:6,offset:const Offset(0,2))]),
              child:Center(child:Text(_cropEmoji(crop.type),style:const TextStyle(fontSize:18))),
            )),
          ]),
          // Infos

        ]),
      ),
    );
  }
  String _cropEmoji(_CropType t) {
    switch(t){
      case _CropType.mais:   return '🌽';
      case _CropType.piment: return '🌶️';
      case _CropType.tomate: return '🍅';
      case _CropType.manioc: return '🌿';
    }
  }
}

// ─────────────────────────────────────────────
//  CALENDAR ROW
// ─────────────────────────────────────────────
class _CalRow extends StatelessWidget {
  final _CalEvent event;
  const _CalRow({required this.event});
  @override
  Widget build(BuildContext context) => Padding(
    padding:const EdgeInsets.symmetric(horizontal:14,vertical:14),
    child:Row(children:[
      // Icône
      Container(width:44,height:44,
          decoration:BoxDecoration(color:_iconBg(event.icon),shape:BoxShape.circle),
          child:Center(child:SizedBox(width:22,height:22,
              child:CustomPaint(painter:_calIconPainter(event.icon))))),
      const SizedBox(width:14),
      // Titre + sous-titre
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(event.title,style:const TextStyle(fontSize:14,fontWeight:FontWeight.w700,color:_textDk)),
        const SizedBox(height:2),
        Text(event.subtitle,style:const TextStyle(fontSize:12.5,color:_textMd)),
      ])),
      // Date + statut
      Column(crossAxisAlignment:CrossAxisAlignment.end,children:[
        Text(event.date,style:TextStyle(fontSize:12,fontWeight:FontWeight.w700,color:event.dateColor)),
        const SizedBox(height:2),
        Text(event.statusLabel,style:TextStyle(fontSize:11.5,color:
        event.status==_CalStatus.today?_orange:_textLt)),
      ]),
      const SizedBox(width:12),
      // Statut icône
      _statusWidget(event.status),
    ]),
  );

  Color _iconBg(_CalIcon i){
    switch(i){
      case _CalIcon.semis: return _green4;
      case _CalIcon.arrosage: return _blueBg;
      case _CalIcon.fertilisation: return _orangeBg;
      case _CalIcon.traitement: return _green4;
    }
  }

  CustomPainter _calIconPainter(_CalIcon i){
    switch(i){
      case _CalIcon.semis: return _SemisIcon();
      case _CalIcon.arrosage: return _ArrosageIcon();
      case _CalIcon.fertilisation: return _FertilisationIcon();
      case _CalIcon.traitement: return _TraitementIcon();
    }
  }

  Widget _statusWidget(_CalStatus s){
    switch(s){
      case _CalStatus.done:
        return const Icon(Icons.check_circle_outline_rounded,color:_green3,size:26);
      case _CalStatus.today:
        return Container(width:26,height:26,
            decoration:BoxDecoration(shape:BoxShape.circle,border:Border.all(color:_orange,width:2)),
            child:Center(child:Container(width:12,height:12,
                decoration:const BoxDecoration(color:_orange,shape:BoxShape.circle))));
      case _CalStatus.upcoming:
        return Container(width:26,height:26,
            decoration:BoxDecoration(shape:BoxShape.circle,
                border:Border.all(color:const Color(0xFFBDBDBD),width:1.8)));
    }
  }
}

// ─────────────────────────────────────────────
//  CIRCLE BUTTON HELPER
// ─────────────────────────────────────────────
class _CircBtn extends StatelessWidget {
  final Widget child;
  const _CircBtn({required this.child});
  @override
  Widget build(BuildContext context) => Container(
    width:42,height:42,
    decoration:BoxDecoration(color:Colors.white,shape:BoxShape.circle,
        boxShadow:[BoxShadow(color:Colors.black.withOpacity(0.07),blurRadius:8,offset:const Offset(0,2))]),
    child:child,
  );
}

// ══════════════════════════════════════════════
//  PAINTERS
// ══════════════════════════════════════════════

// ─── MINI PS LOGO ─────────────────────────────
class _PSLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    final gS = const LinearGradient(colors:[Color(0xFF66BB6A),Color(0xFF2E7D32)])
        .createShader(Rect.fromLTWH(0,0,s.width*.6,s.height));
    final bS = const LinearGradient(colors:[Color(0xFF42A5F5),Color(0xFF0D47A1)],
        begin:Alignment.topRight,end:Alignment.bottomLeft)
        .createShader(Rect.fromLTWH(s.width*.4,0,s.width*.6,s.height));
    final thick = s.width*.12;
    final gp = Paint()..shader=gS..style=PaintingStyle.fill;
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(s.width*.04,s.height*.18,thick,s.height*.68), Radius.circular(thick/2)))
      ..moveTo(s.width*.04+thick,s.height*.18)..lineTo(s.width*.46,s.height*.18)
      ..arcToPoint(Offset(s.width*.46,s.height*.50),radius:Radius.circular(s.width*.16),clockwise:true)
      ..lineTo(s.width*.04+thick,s.height*.50)..lineTo(s.width*.04+thick,s.height*.50-thick)
      ..lineTo(s.width*.40,s.height*.50-thick)
      ..arcToPoint(Offset(s.width*.40,s.height*.18+thick),radius:Radius.circular(s.width*.12),clockwise:false)
      ..lineTo(s.width*.04+thick,s.height*.18+thick)..close();
    canvas.drawPath(path,gp);
    final sp = Path()
      ..moveTo(s.width*.88,s.height*.20)
      ..arcToPoint(Offset(s.width*.48,s.height*.34),radius:Radius.circular(s.width*.22),clockwise:false)
      ..arcToPoint(Offset(s.width*.88,s.height*.50),radius:Radius.circular(s.width*.15),clockwise:true)
      ..arcToPoint(Offset(s.width*.48,s.height*.65),radius:Radius.circular(s.width*.15),clockwise:false)
      ..arcToPoint(Offset(s.width*.88,s.height*.80),radius:Radius.circular(s.width*.22),clockwise:true);
    canvas.drawPath(sp,Paint()..shader=bS..style=PaintingStyle.stroke..strokeWidth=thick..strokeCap=StrokeCap.round);
    _drawLeaves(canvas,Offset(s.width*.145,s.height*.16),s.width*.10);
  }
  void _drawLeaves(Canvas canvas, Offset base, double r){
    final p = Paint()..color=const Color(0xFF4CAF50)..style=PaintingStyle.fill;
    canvas.drawLine(base,Offset(base.dx,base.dy-r*1.4),
        Paint()..color=const Color(0xFF388E3C)..strokeWidth=r*.25..strokeCap=StrokeCap.round);
    for(final dx in [-r*.55, r*.55, 0.0]){
      canvas.save();
      canvas.translate(base.dx+dx, base.dy-r*.9);
      canvas.rotate(dx==0?0.0:(dx<0?-0.45:0.45));
      canvas.drawPath(Path()
        ..moveTo(0,-r*.8)..cubicTo(r*.5,-r*.4,r*.5,r*.4,0,r*.6)
        ..cubicTo(-r*.5,r*.4,-r*.5,-r*.4,0,-r*.8)..close(),p);
      canvas.restore();
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── AVATAR FERMIER ───────────────────────────
class _AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s) {
    canvas.drawRect(Rect.fromLTWH(0,0,s.width,s.height),Paint()..color=const Color(0xFF87CEEB));
    canvas.drawRect(Rect.fromLTWH(0,s.height*.62,s.width,s.height*.38),Paint()..color=const Color(0xFF4CAF50));
    canvas.drawOval(Rect.fromCenter(center:Offset(s.width/2,s.height*.90),width:s.width*.85,height:s.height*.62),
        Paint()..color=const Color(0xFF388E3C));
    canvas.drawRect(Rect.fromLTWH(s.width*.40,s.height*.48,s.width*.20,s.height*.16),Paint()..color=const Color(0xFFC68642));
    canvas.drawCircle(Offset(s.width/2,s.height*.40),s.width*.24,Paint()..color=const Color(0xFFC68642));
    canvas.drawArc(Rect.fromCenter(center:Offset(s.width/2,s.height*.42),width:s.width*.16,height:s.height*.08),
        0,math.pi,false,Paint()..color=const Color(0xFF8D4004)..strokeWidth=1.8..style=PaintingStyle.stroke);
    for(final dx in [-0.08,0.08])
      canvas.drawCircle(Offset(s.width*(0.5+dx),s.height*.38),s.width*.024,Paint()..color=const Color(0xFF4E2700));
    canvas.drawOval(Rect.fromCenter(center:Offset(s.width/2,s.height*.195),width:s.width*.82,height:s.height*.092),
        Paint()..color=const Color(0xFFBF8040));
    canvas.drawPath(Path()
      ..moveTo(s.width*.22,s.height*.195)
      ..quadraticBezierTo(s.width*.22,s.height*.05,s.width/2,s.height*.05)
      ..quadraticBezierTo(s.width*.78,s.height*.05,s.width*.78,s.height*.195)..close(),
        Paint()..color=const Color(0xFFBF8040));
    canvas.drawRect(Rect.fromLTWH(s.width*.22,s.height*.17,s.width*.56,s.height*.04),
        Paint()..color=const Color(0xFF8D5524));
  }
  @override
  bool shouldRepaint(covariant CustomPainter _) => false;
}

// ─── PHOTOS CULTURES (placeholder) ────────────
class _CropPhotoPainter extends CustomPainter {
  final _CropType type;
  const _CropPhotoPainter(this.type);
  @override
  void paint(Canvas canvas, Size s){
    canvas.drawRect(Rect.fromLTWH(0,0,s.width,s.height),Paint()
      ..shader=LinearGradient(colors:_bgColors,begin:Alignment.topLeft,end:Alignment.bottomRight)
          .createShader(Rect.fromLTWH(0,0,s.width,s.height)));
    final rng = math.Random(_seed);
    final lp = Paint()..color=Colors.white.withOpacity(.15)..style=PaintingStyle.fill;
    for(int i=0;i<4;i++){
      final cx=rng.nextDouble()*s.width, cy=rng.nextDouble()*s.height, r=15.0+rng.nextDouble()*25;
      canvas.drawPath(Path()
        ..moveTo(cx,cy-r)..cubicTo(cx+r*.6,cy-r*.5,cx+r*.6,cy+r*.5,cx,cy+r)
        ..cubicTo(cx-r*.6,cy+r*.5,cx-r*.6,cy-r*.5,cx,cy-r)..close(),lp);
    }
    final tp = TextPainter(
      text:TextSpan(text:_emoji,style:const TextStyle(fontSize:40)),
      textDirection:TextDirection.ltr,
    )..layout();
    tp.paint(canvas,Offset(s.width/2-tp.width/2,s.height/2-tp.height/2));
  }
  List<Color> get _bgColors { switch(type){
    case _CropType.mais:   return [const Color(0xFF558B2F),const Color(0xFF2E7D32)];
    case _CropType.piment: return [const Color(0xFF2E7D32),const Color(0xFF1B5E20)];
    case _CropType.tomate: return [const Color(0xFF388E3C),const Color(0xFF1B5E20)];
    case _CropType.manioc: return [const Color(0xFF33691E),const Color(0xFF558B2F)];
  }}
  String get _emoji { switch(type){
    case _CropType.mais: return '🌽'; case _CropType.piment: return '🌶️';
    case _CropType.tomate: return '🍅'; case _CropType.manioc: return '🌿';
  }}
  int get _seed { switch(type){
    case _CropType.mais:return 11; case _CropType.piment:return 22;
    case _CropType.tomate:return 33; case _CropType.manioc:return 44;
  }}
  @override
  bool shouldRepaint(covariant _CropPhotoPainter old)=>old.type!=type;
}

// ─── ICÔNE MAP PIN RECO ───────────────────────
class _MapPinIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s){
    final p = Paint()..color=_green2..strokeWidth=1.8..style=PaintingStyle.stroke..strokeCap=StrokeCap.round..strokeJoin=StrokeJoin.round;
    // Fond cercle léger
    canvas.drawCircle(Offset(s.width/2,s.height/2),s.width*.44,Paint()..color=_green4);
    // Pin
    final pin = Path()
      ..moveTo(s.width*.50,s.height*.88)
      ..cubicTo(s.width*.25,s.height*.62,s.width*.14,s.height*.40,s.width*.14,s.height*.34)
      ..arcToPoint(Offset(s.width*.86,s.height*.34),radius:Radius.circular(s.width*.36),clockwise:false)
      ..cubicTo(s.width*.86,s.height*.40,s.width*.75,s.height*.62,s.width*.50,s.height*.88)..close();
    canvas.drawPath(pin,p..style=PaintingStyle.stroke);
    canvas.drawCircle(Offset(s.width*.50,s.height*.35),s.width*.12,p);
    // Arches reco
    canvas.drawArc(Rect.fromCircle(center:Offset(s.width*.50,s.height*.34),radius:s.width*.22),
        -math.pi*.9,math.pi*.4,false,p..strokeWidth=1.4);
    canvas.drawArc(Rect.fromCircle(center:Offset(s.width*.50,s.height*.34),radius:s.width*.30),
        -math.pi*.9,math.pi*.4,false,p..strokeWidth=1.2);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _)=>false;
}

// ─── ICÔNES CALENDRIER ────────────────────────
class _SemisIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s){
    final p = Paint()..color=_green2..style=PaintingStyle.fill;
    canvas.drawLine(Offset(s.width/2,s.height),Offset(s.width/2,s.height*.35),
        Paint()..color=_green2..strokeWidth=2.2..strokeCap=StrokeCap.round);
    void leaf(bool right){
      canvas.drawPath(Path()
        ..moveTo(s.width/2,s.height*.52)
        ..cubicTo(right?s.width*.82:s.width*.18,s.height*.38,right?s.width*.88:s.width*.12,s.height*.10,right?s.width*.68:s.width*.32,s.height*.05)
        ..cubicTo(s.width*.50,s.height*.00,right?s.width*.44:s.width*.56,s.height*.24,s.width/2,s.height*.35)..close(),p);
    }
    leaf(true); leaf(false);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _)=>false;
}

class _ArrosageIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s){
    final p = Paint()..color=_blue2..strokeWidth=1.8..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    // Goutte
    canvas.drawPath(Path()
      ..moveTo(s.width*.50,s.height*.05)
      ..cubicTo(s.width*.80,s.height*.38,s.width*.88,s.height*.55,s.width*.50,s.height*.88)
      ..cubicTo(s.width*.12,s.height*.55,s.width*.20,s.height*.38,s.width*.50,s.height*.05)..close(),
        Paint()..color=_blue2..style=PaintingStyle.fill);
    // Brillance
    canvas.drawPath(Path()
      ..moveTo(s.width*.38,s.height*.32)..cubicTo(s.width*.32,s.height*.50,s.width*.32,s.height*.60,s.width*.38,s.height*.68),
        Paint()..color=Colors.white.withOpacity(.5)..strokeWidth=1.4..style=PaintingStyle.stroke..strokeCap=StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _)=>false;
}

class _FertilisationIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s){
    final p = Paint()..color=const Color(0xFFF57F17)..style=PaintingStyle.fill;
    // Sac engrais
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width*.12,s.height*.30,s.width*.76,s.height*.65),Radius.circular(s.width*.08)),p);
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width*.28,s.height*.10,s.width*.44,s.height*.22),Radius.circular(s.width*.06)),
        Paint()..color=const Color(0xFFFF8F00));
    // Étiquette
    canvas.drawRect(Rect.fromLTWH(s.width*.22,s.height*.44,s.width*.56,s.height*.30),
        Paint()..color=const Color(0xFFFF8F00).withOpacity(.4));
    // "F"
    final tp = TextPainter(text:const TextSpan(text:'F',style:TextStyle(color:Colors.white,fontSize:14,fontWeight:FontWeight.w900)),
        textDirection:TextDirection.ltr)..layout();
    tp.paint(canvas,Offset(s.width/2-tp.width/2,s.height*.46));
  }
  @override
  bool shouldRepaint(covariant CustomPainter _)=>false;
}

class _TraitementIcon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size s){
    final p = Paint()..color=_green2..strokeWidth=1.8..style=PaintingStyle.stroke..strokeCap=StrokeCap.round;
    // Flacon spray
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width*.18,s.height*.28,s.width*.52,s.height*.64),Radius.circular(s.width*.08)),p);
    canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(s.width*.30,s.height*.10,s.width*.28,s.height*.20),Radius.circular(s.width*.05)),p);
    // Buse spray
    canvas.drawLine(Offset(s.width*.58,s.height*.18),Offset(s.width*.90,s.height*.18),p);
    // Gouttelettes
    for(int i=0;i<3;i++)
      canvas.drawCircle(Offset(s.width*.88,s.height*(.08+i*.12)),2.5,
          Paint()..color=_green3..style=PaintingStyle.fill);
    // Feuille
    canvas.drawPath(Path()
      ..moveTo(s.width*.44,s.height*.52)
      ..cubicTo(s.width*.55,s.height*.38,s.width*.62,s.height*.46,s.width*.55,s.height*.58)
      ..cubicTo(s.width*.48,s.height*.66,s.width*.40,s.height*.58,s.width*.44,s.height*.52)..close(),
        Paint()..color=_green2..style=PaintingStyle.fill);
    // Croix
    canvas.drawLine(Offset(s.width*.20,s.height*.42),Offset(s.width*.32,s.height*.54),
        Paint()..color=const Color(0xFFE53935)..strokeWidth=1.6..strokeCap=StrokeCap.round);
    canvas.drawLine(Offset(s.width*.32,s.height*.42),Offset(s.width*.20,s.height*.54),
        Paint()..color=const Color(0xFFE53935)..strokeWidth=1.6..strokeCap=StrokeCap.round);
  }
  @override
  bool shouldRepaint(covariant CustomPainter _)=>false;
}