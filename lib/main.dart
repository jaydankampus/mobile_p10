
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const IoTMonitoringApp());
}

class IoTMonitoringApp extends StatelessWidget {
  const IoTMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IoT Monitoring',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B1220),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF38BDF8),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double temperature = 28.5;
  double humidity = 65;
  bool connected = true;
  DateTime lastUpdated = DateTime.now();

  void refreshData() {
    final random = Random();

    setState(() {
      temperature = 25 + random.nextDouble() * 8;
      humidity = 50 + random.nextDouble() * 30;
      lastUpdated = DateTime.now();
    });
  }

  String get updateTime {
    return '${lastUpdated.hour.toString().padLeft(2, '0')}:'
        '${lastUpdated.minute.toString().padLeft(2, '0')}:'
        '${lastUpdated.second.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'IOT MONITORING',
                        style: TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 12,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFF1E293B),
                    child: const Icon(
                      Icons.sensors,
                      color: Color(0xFF38BDF8),
                      size: 28,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // MQTT STATUS
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF142B2A),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.wifi,
                      color: connected
                          ? Colors.greenAccent
                          : Colors.redAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            connected
                                ? 'MQTT Connected'
                                : 'MQTT Disconnected',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Broker connection status',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: connected
                            ? Colors.green.withOpacity(0.2)
                            : Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        connected ? 'ONLINE' : 'OFFLINE',
                        style: TextStyle(
                          color: connected
                              ? Colors.greenAccent
                              : Colors.redAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Sensor Monitoring',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              // SENSOR CARDS
              Row(
                children: [
                  Expanded(
                    child: sensorCard(
                      'Temperature',
                      temperature.toStringAsFixed(1),
                      '°C',
                      Icons.thermostat,
                      Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: sensorCard(
                      'Humidity',
                      humidity.toStringAsFixed(1),
                      '%',
                      Icons.water_drop,
                      Colors.lightBlueAccent,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // GRAPH
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF172337),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monitoring Overview',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Temperature history',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 140,
                      width: double.infinity,
                      child: CustomPaint(
                        painter: ChartPainter(),
                      ),
                    ),
                    const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text('08:00',
                            style: TextStyle(color: Colors.white54)),
                        Text('10:00',
                            style: TextStyle(color: Colors.white54)),
                        Text('12:00',
                            style: TextStyle(color: Colors.white54)),
                        Text('14:00',
                            style: TextStyle(color: Colors.white54)),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // LAST UPDATED
              Container(
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: const Color(0xFF172337),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      color: Colors.lightBlueAccent,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last Updated',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            updateTime,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: refreshData,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.lightBlueAccent,
                      ),
                      tooltip: 'Refresh data',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  'IoT Monitoring System • Demo Version',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget sensorCard(
    String title,
    String value,
    String unit,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFF172337),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            child: Text(
              '$value$unit',
              style: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Sensor Active',
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// CUSTOM CHART
class ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white12
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final y = i * size.height / 3;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final points = [
      Offset(0, size.height * 0.75),
      Offset(size.width * 0.16, size.height * 0.60),
      Offset(size.width * 0.32, size.height * 0.68),
      Offset(size.width * 0.48, size.height * 0.30),
      Offset(size.width * 0.64, size.height * 0.43),
      Offset(size.width * 0.82, size.height * 0.15),
      Offset(size.width, size.height * 0.28),
    ];

    final path = Path()..moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final paint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);

    final dotPaint = Paint()
      ..color = const Color(0xFF38BDF8);

    for (final point in points) {
      canvas.drawCircle(point, 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
