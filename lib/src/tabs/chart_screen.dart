import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  bool isMonthlyView = true;
  String selectedFilter = '';
  String centerText = 'Total Spending';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: AppBar(
        title: const Text('Spending Breakdown'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Center(
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(20),
                  isSelected: [isMonthlyView, !isMonthlyView],
                  onPressed: (index) {
                    setState(() {
                      isMonthlyView = index == 0;
                      selectedFilter = '';
                      centerText = 'Total Spending';
                    });
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Monthly View'),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Category View'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _getDynamicSummary(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (isMonthlyView)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 2000,
                              barGroups: _getFilteredBarData(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    interval: 500,
                                    reservedSize: 40,
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      switch (value.toInt()) {
                                        case 0:
                                          return const Text('Jan');
                                        case 1:
                                          return const Text('Feb');
                                        case 2:
                                          return const Text('Mar');
                                        case 3:
                                          return const Text('Apr');
                                        case 4:
                                          return const Text('May');
                                        case 5:
                                          return const Text('Jun');
                                        case 6:
                                          return const Text('Jul');
                                        default:
                                          return const Text('');
                                      }
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barTouchData: BarTouchData(enabled: false),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: const [
                          Icon(Icons.warning, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '2 months were over spending budget',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              else
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 300,
                      child: PieChart(
                        PieChartData(
                          sections: _getFilteredPieData(),
                          centerSpaceRadius: 40,
                          centerSpaceColor: const Color(0xFFF7F6FB),
                          pieTouchData: PieTouchData(
                            touchCallback: (event, response) {
                              if (response != null &&
                                  response.touchedSection != null &&
                                  response.touchedSection!.touchedSectionIndex != null &&
                                  response.touchedSection!.touchedSectionIndex! >= 0 &&
                                  response.touchedSection!.touchedSectionIndex! < _getFilteredPieData().length) {
                                final index = response.touchedSection!.touchedSectionIndex!;
                                final section = _getFilteredPieData()[index];
                                setState(() {
                                  centerText =
                                      '${section.title}: \$${section.value.toStringAsFixed(2)}';
                                });
                              } else {
                                setState(() {
                                  centerText = 'Total Spending';
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildFilters(['Food', 'Home', 'Auto'],
                          isMonthlyView ? 'Filter by Category' : 'Filter by Time Period'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Time Period',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: 'Jan',
                            items: const [
                              DropdownMenuItem(value: 'Jan', child: Text('Jan')),
                              DropdownMenuItem(value: 'Feb', child: Text('Feb')),
                              DropdownMenuItem(value: 'Mar', child: Text('Mar')),
                              DropdownMenuItem(value: 'Apr', child: Text('Apr')),
                              DropdownMenuItem(value: 'May', child: Text('May')),
                              DropdownMenuItem(value: 'Jun', child: Text('Jun')),
                              DropdownMenuItem(value: 'Jul', child: Text('Jul')),
                              DropdownMenuItem(value: 'Aug', child: Text('Aug')),
                              DropdownMenuItem(value: 'Sep', child: Text('Sep')),
                              DropdownMenuItem(value: 'Oct', child: Text('Oct')),
                              DropdownMenuItem(value: 'Nov', child: Text('Nov')),
                              DropdownMenuItem(value: 'Dec', child: Text('Dec')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value ?? '';
                              });
                            },
                          ),
                          const Text(' to '),
                          DropdownButton<String>(
                            value: 'Jul',
                            items: const [
                              DropdownMenuItem(value: 'Jan', child: Text('Jan')),
                              DropdownMenuItem(value: 'Feb', child: Text('Feb')),
                              DropdownMenuItem(value: 'Mar', child: Text('Mar')),
                              DropdownMenuItem(value: 'Apr', child: Text('Apr')),
                              DropdownMenuItem(value: 'May', child: Text('May')),
                              DropdownMenuItem(value: 'Jun', child: Text('Jun')),
                              DropdownMenuItem(value: 'Jul', child: Text('Jul')),
                              DropdownMenuItem(value: 'Aug', child: Text('Aug')),
                              DropdownMenuItem(value: 'Sep', child: Text('Sep')),
                              DropdownMenuItem(value: 'Oct', child: Text('Oct')),
                              DropdownMenuItem(value: 'Nov', child: Text('Nov')),
                              DropdownMenuItem(value: 'Dec', child: Text('Dec')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                selectedFilter = value ?? '';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getDynamicSummary() {
    if (isMonthlyView) {
      double totalSpending = _getFilteredBarData().fold(0, (sum, group) => sum + group.barRods[0].toY);
      return 'Total spending for selected months: \$${totalSpending.toStringAsFixed(2)}';
    } else {
      double totalSpending = _getFilteredPieData().fold(0, (sum, section) => sum + section.value);
      return 'Total spending for selected categories: \$${totalSpending.toStringAsFixed(2)}';
    }
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 20,
        ),
      ],
    );
  }

  List<BarChartGroupData> _getFilteredBarData() {
    if (selectedFilter == 'Food') {
      return [
        _buildBarGroup(0, 500, Colors.green),
        _buildBarGroup(1, 600, Colors.green),
        _buildBarGroup(2, 700, Colors.green),
      ];
    } else if (selectedFilter == 'Home') {
      return [
        _buildBarGroup(0, 800, Colors.purple),
        _buildBarGroup(1, 850, Colors.purple),
        _buildBarGroup(2, 900, Colors.purple),
      ];
    } else {
      return [
        _buildBarGroup(0, 1345, Colors.green),
        _buildBarGroup(1, 1345, Colors.green),
        _buildBarGroup(2, 1618, Colors.blue),
        _buildBarGroup(3, 1345, Colors.green),
        _buildBarGroup(4, 1429, Colors.green),
        _buildBarGroup(5, 1958, Colors.blue),
      ];
    }
  }

  List<PieChartSectionData> _getFilteredPieData() {
    if (selectedFilter == 'Food') {
      return [
        PieChartSectionData(
          value: 690,
          color: Colors.green,
          title: 'Food',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ];
    } else if (selectedFilter == 'Home') {
      return [
        PieChartSectionData(
          value: 400,
          color: Colors.purple,
          title: 'Home',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ];
    } else if (selectedFilter == 'Auto') {
      return [
        PieChartSectionData(
          value: 264,
          color: Colors.yellow,
          title: 'Auto',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ];
    } else {
      return [
        PieChartSectionData(
          value: 690,
          color: Colors.green,
          title: 'Food',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        PieChartSectionData(
          value: 400,
          color: Colors.purple,
          title: 'Home',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        PieChartSectionData(
          value: 264,
          color: Colors.yellow,
          title: 'Auto',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ];
    }
  }

  Widget _buildFilters(List<String> options, String title) {
    return Wrap(
      spacing: 10.0,
      children: options.map((option) {
        return FilterChip(
          label: Text(option),
          selected: selectedFilter == option,
          onSelected: (bool selected) {
            setState(() {
              selectedFilter = selected ? option : '';
            });
          },
        );
      }).toList(),
    );
  }
}
