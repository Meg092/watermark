import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_markly/db_water_markly/db_water_markly_entity.dart';


class _TagClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(12, 0);
    path.lineTo(size.width - 20, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - 20, size.height);
    path.lineTo(12, size.height);
    path.arcToPoint(Offset(0, size.height - 12), radius: Radius.circular(12));
    path.lineTo(0, 12);
    path.arcToPoint(Offset(12, 0), radius: Radius.circular(12));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


class WatermarkCardWidget extends StatelessWidget {
  final String templateName;
  final String timeString;
  final String location;
  final Map<String, String> customFields;
  final WatermarkTemplate? currentTemplate;
  final double width;
  final double scale; 

  const WatermarkCardWidget({
    super.key,
    required this.templateName,
    required this.timeString,
    required this.location,
    required this.customFields,
    this.currentTemplate,
    this.width = 250,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return _buildCardByTemplate(templateName);
  }

  
  double _w(double value) => scale != 1.0 ? value * scale : value.w;
  double _h(double value) => scale != 1.0 ? value * scale : value.h;
  double _sp(double value) => scale != 1.0 ? value * scale : value.sp;
  double _r(double value) => scale != 1.0 ? value * scale : value.r;

  EdgeInsets _edgeInsets({
    double all = 0,
    double horizontal = 0,
    double vertical = 0,
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    if (all > 0) {
      return EdgeInsets.all(_w(all));
    } else if (horizontal > 0 || vertical > 0) {
      return EdgeInsets.symmetric(
        horizontal: _w(horizontal),
        vertical: _h(vertical),
      );
    } else {
      return EdgeInsets.only(
        left: _w(left),
        right: _w(right),
        top: _h(top),
        bottom: _h(bottom),
      );
    }
  }

  Widget _buildCardByTemplate(String templateName) {
    if (templateName.contains('Attendance') || templateName.contains('Check')) {
      return _buildAttendanceCard();
    } else if (templateName.contains('Construction')) {
      return _buildConstructionCard();
    } else if (templateName.contains('Patrol')) {
      return _buildPatrolCard();
    } else if (templateName.contains('Sales')) {
      return _buildSalesCard();
    } else if (templateName.contains('Note')) {
      return _buildNoteCard();
    } else if (templateName.contains('Clock')) {
      return _buildClockCard();
    } else if (templateName.contains('Travel')) {
      return _buildTravelCard();
    } else if (templateName.contains('Inbound')) {
      return _buildInboundCard();
    } else if (templateName.contains('Outbound')) {
      return _buildOutboundCard();
    } else {
      return _buildDefaultCard();
    }
  }

  
  Widget _buildAttendanceCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(180),
        padding: _edgeInsets(all: 16),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(_r(16)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF3B82F6).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: _w(60),
              height: _w(60),
              decoration: BoxDecoration(
                color: Color(0xFF3B82F6).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF3B82F6), width: 2),
              ),
              child: Icon(
                Icons.access_time,
                color: Colors.white,
                size: _sp(36),
              ),
            ),
            SizedBox(height: _h(12)),
            Text(
              timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: _sp(24),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _h(8)),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: _sp(11),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAllFields(
              textColor: Colors.white,
              fontSize: 10,
              textAlign: TextAlign.center,
              maxFields: 2,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildConstructionCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(230),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(_r(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: _h(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(_r(4)),
                ),
                gradient: LinearGradient(
                  colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _w(16),
                    height: _w(16),
                    margin: _edgeInsets(top: _h(4)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Color(0xFFF97316), width: 2),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: _edgeInsets(all: 12),
              child: Row(
                children: [
                  Container(
                    width: _w(4),
                    height: _h(80),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                        colors: [Color(0xFFF97316), Color(0xFFEA580C)],
                      ),
                    ),
                  ),
                  SizedBox(width: _w(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.construction,
                              color: Color(0xFFF97316),
                              size: _sp(20),
                            ),
                            SizedBox(width: _w(6)),
                            Text(
                              'Construction',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: _sp(14),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: _h(8)),
                        Text(
                          timeString,
                          style: TextStyle(
                            color: Color(0xFFF97316),
                            fontSize: _sp(20),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: _h(4)),
                        Text(
                          location,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: _sp(10),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        _buildAllFields(
                          textColor: Colors.black87,
                          fontSize: 9,
                          maxFields: 3,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildPatrolCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(210),
        padding: _edgeInsets(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF8B5CF6).withOpacity(0.3),
              Color(0xFF7C3AED).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(_r(30)),
            bottom: Radius.circular(_r(12)),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF8B5CF6).withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield, color: Colors.white, size: _sp(40)),
            SizedBox(height: _h(8)),
            Text(
              timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: _sp(22),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _h(6)),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: _sp(11),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAllFields(
              textColor: Colors.white,
              fontSize: 10,
              textAlign: TextAlign.center,
              maxFields: 2,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildSalesCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: ClipPath(
        clipper: _TagClipper(),
        child: Container(
          width: _w(250),
          padding: _edgeInsets(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF10B981).withOpacity(0.3),
                Color(0xFF059669).withOpacity(0.3),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF10B981).withOpacity(0.4),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.shopping_bag, color: Colors.white, size: _sp(36)),
              SizedBox(width: _w(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      timeString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _sp(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: _h(4)),
                    Text(
                      location,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: _sp(11),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    _buildAllFields(
                      textColor: Colors.white,
                      fontSize: 10,
                      maxFields: 3,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Widget _buildNoteCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Transform.rotate(
        angle: -0.03,
        child: Stack(
          children: [
            Container(
              width: _w(230),
              padding: _edgeInsets(all: 16),
              decoration: BoxDecoration(
                color: Color(0xFFFDE68A).withOpacity(0.3),
                borderRadius: BorderRadius.circular(_r(2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: _h(8)),
                  Row(
                    children: [
                      Icon(Icons.note, color: Color(0xFFF59E0B), size: _sp(20)),
                      SizedBox(width: _w(6)),
                      Text(
                        'Note',
                        style: TextStyle(
                          color: Color(0xFF92400E),
                          fontSize: _sp(14),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: _h(8)),
                  Text(
                    timeString,
                    style: TextStyle(
                      color: Color(0xFF92400E),
                      fontSize: _sp(20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: _h(4)),
                  Text(
                    location,
                    style: TextStyle(
                      color: Color(0xFF92400E).withOpacity(0.8),
                      fontSize: _sp(11),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildAllFields(
                    textColor: Color(0xFF92400E),
                    fontSize: 9,
                    maxFields: 2,
                  ),
                ],
              ),
            ),
            Positioned(
              right: _w(10),
              top: -_h(5),
              child: Container(
                width: _w(20),
                height: _w(20),
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildClockCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(210),
        padding: _edgeInsets(all: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(_r(12)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF06B6D4).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString.split(' ').last,
                  style: TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: _sp(36),
                    fontWeight: FontWeight.bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                    height: 1.0,
                  ),
                ),
                Container(
                  width: _w(60),
                  height: _h(2),
                  color: Color(0xFF06B6D4),
                  margin: _edgeInsets(vertical: 4),
                ),
                Text(
                  timeString.split(' ').first,
                  style: TextStyle(
                    color: Color(0xFF06B6D4),
                    fontSize: _sp(11),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(width: _w(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.access_alarm, color: Colors.white, size: _sp(24)),
                  SizedBox(height: _h(6)),
                  Text(
                    location,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: _sp(10),
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  _buildAllFields(
                    textColor: Colors.white,
                    fontSize: 9,
                    maxFields: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildTravelCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Stack(
        children: [
          Container(
            width: _w(190),
            padding: _edgeInsets(all: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFEC4899).withOpacity(0.3),
                  Color(0xFFDB2777).withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(_r(30)),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFEC4899).withOpacity(0.4),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeString,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _sp(22),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: _h(8)),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: _sp(11),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                _buildAllFields(
                  textColor: Colors.white,
                  fontSize: 9,
                  textAlign: TextAlign.center,
                  maxFields: 1,
                  isCompact: true,
                ),
              ],
            ),
          ),
          Positioned(
            right: _w(8),
            top: _h(8),
            child: Container(
              padding: _edgeInsets(all: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.flight, color: Colors.white, size: _sp(24)),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildInboundCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(220),
        padding: _edgeInsets(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF6366F1).withOpacity(0.3),
              Color(0xFF4F46E5).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(_r(12)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6366F1).withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward, color: Colors.white, size: _sp(32)),
                SizedBox(width: _w(8)),
                Text(
                  'INBOUND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _sp(14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: _h(8)),
            Text(
              timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: _sp(22),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _h(4)),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: _sp(11),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAllFields(
              textColor: Colors.white,
              fontSize: 10,
              textAlign: TextAlign.center,
              maxFields: 2,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildOutboundCard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        width: _w(220),
        padding: _edgeInsets(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFEF4444).withOpacity(0.3),
              Color(0xFFDC2626).withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(_r(12)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFEF4444).withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward, color: Colors.white, size: _sp(32)),
                SizedBox(width: _w(8)),
                Text(
                  'OUTBOUND',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _sp(14),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            SizedBox(height: _h(8)),
            Text(
              timeString,
              style: TextStyle(
                color: Colors.white,
                fontSize: _sp(22),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: _h(4)),
            Text(
              location,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: _sp(11),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _buildAllFields(
              textColor: Colors.white,
              fontSize: 10,
              textAlign: TextAlign.center,
              maxFields: 2,
              isCompact: true,
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildDefaultCard() {
    return Container(
      padding: _edgeInsets(all: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF667eea).withOpacity(0.3),
            Color(0xFF764ba2).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(_r(12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.image, color: Colors.white, size: _sp(20)),
              SizedBox(width: _w(8)),
              Expanded(
                child: Text(
                  templateName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _sp(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Icon(
                Icons.edit,
                color: Colors.white.withOpacity(0.8),
                size: _sp(16),
              ),
            ],
          ),
          SizedBox(height: _h(12)),
          Text(
            timeString,
            style: TextStyle(
              color: Colors.white.withOpacity(0.95),
              fontSize: _sp(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _h(6)),
          Text(
            location,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: _sp(12),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          _buildAllFields(
            textColor: Colors.white,
            fontSize: 11,
            maxFields: 3,
          ),
        ],
      ),
    );
  }

  
  Widget _buildAllFields({
    required Color textColor,
    required double fontSize,
    TextAlign textAlign = TextAlign.start,
    int? maxFields,
    bool isCompact = false,
  }) {
    if (currentTemplate == null) {
      return SizedBox.shrink();
    }

    final fieldsConfig = currentTemplate!.fieldsConfig;
    if (fieldsConfig.isEmpty) {
      return SizedBox.shrink();
    }

    final fieldsToShow = maxFields != null
        ? fieldsConfig.take(maxFields).toList()
        : fieldsConfig;

    return Column(
      crossAxisAlignment: textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: fieldsToShow.map((config) {
        final fieldName = config['name'] as String;
        final fieldLabel = config['label'] as String;
        final value = customFields[fieldName] ?? '';
        final hasValue = value.isNotEmpty;

        return Padding(
          padding: _edgeInsets(top: isCompact ? 4 : 6),
          child: Row(
            mainAxisSize: textAlign == TextAlign.center
                ? MainAxisSize.min
                : MainAxisSize.max,
            children: [
              if (!isCompact) ...[
                Icon(
                  hasValue ? Icons.check_circle : Icons.edit,
                  color: textColor.withOpacity(hasValue ? 0.9 : 0.6),
                  size: (fontSize + 2).sp,
                ),
                SizedBox(width: _w(4)),
              ],
              Flexible(
                child: Text(
                  hasValue
                      ? '$fieldLabel: $value'
                      : '$fieldLabel: Tap to edit',
                  style: TextStyle(
                    color: textColor.withOpacity(hasValue ? 0.9 : 0.6),
                    fontSize: fontSize.sp,
                    fontStyle: hasValue ? FontStyle.normal : FontStyle.italic,
                  ),
                  textAlign: textAlign,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

