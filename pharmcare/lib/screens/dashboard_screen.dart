import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:pharmcare/screens/login_screen.dart';
import 'inventory_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isDarkMode = false;
  String selectedGraph = "Revenue"; // Toggle between Revenue & Profit
  String selectedTimeFrame = "Daily"; // Daily, Weekly, Monthly

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(
          'PharmCare Dashboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_4),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
              });
            },
          ),
        ],
      ),
      drawer: _buildSidebarMenu(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(),
            SizedBox(height: 20),
            _buildAnalyticsSection(),
            SizedBox(height: 20),
            _buildRevenueProfitGraph(),
            SizedBox(height: 20),
            _buildStockAlertsSection(),
            SizedBox(height: 20),
            _buildBestSellingList(),
          ],
        ),
      ),
    );
  }

  // Sidebar Drawer
  Widget _buildSidebarMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.green, size: 40),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green, Colors.teal]),
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "Dashboard", () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.inventory, "Inventory", () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => InventoryScreen()));
          }),
          _buildDrawerItem(Icons.logout, "Logout", () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      onTap: onTap,
    );
  }

  // Welcome Card
  Widget _buildWelcomeCard() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.green.shade300,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.local_pharmacy, size: 50, color: Colors.white),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome Back!", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                Text("Manage your pharmacy with ease.", style: TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Analytics Cards
  Widget _buildAnalyticsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoCard(Icons.attach_money, "Total Sales", "₹1,20,000", Colors.green),
        _buildInfoCard(Icons.show_chart, "Profit", "₹40,000", Colors.teal),
      ],
    );
  }

  // Stock Alerts
  Widget _buildStockAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Stock Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildInfoCard(Icons.warning, "Near Expiry", "5 Items", Colors.orange),
            _buildInfoCard(Icons.cancel, "Expired", "3 Items", Colors.red),
            _buildInfoCard(Icons.warning_amber, "Low Stock", "7 Items", Colors.purple),
          ],
        ),
      ],
    );
  }

  // Revenue & Profit Graph
  Widget _buildRevenueProfitGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Revenue & Profit Trends", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropdownButton<String>(
              value: selectedGraph,
              items: ["Revenue", "Profit"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGraph = value!;
                });
              },
            ),
            DropdownButton<String>(
              value: selectedTimeFrame,
              items: ["Daily", "Weekly", "Monthly"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTimeFrame = value!;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 300,
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
              ),
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: [FlSpot(1, 10), FlSpot(2, 20), FlSpot(3, 35), FlSpot(4, 50), FlSpot(5, 70)],
                  isCurved: true,
                  gradient: LinearGradient(colors: [Colors.green, Colors.blue]),
                  barWidth: 4,
                  isStrokeCapRound: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Info Card (Fixed Missing Method)
  Widget _buildInfoCard(IconData icon, String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: color,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 30),
              SizedBox(height: 8),
              Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(value, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  // Top Selling Medicines
  Widget _buildBestSellingList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Top Medicines", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        _buildMedicineCard("Paracetamol", "500 units sold"),
        _buildMedicineCard("Amoxicillin", "300 units sold"),
      ],
    );
  }

  Widget _buildMedicineCard(String name, String details) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(Icons.medication, color: Colors.green),
        title: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(details),
      ),
    );
  }
}
