import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/cluster_model.dart';
import './dashed_divide.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Cluster>> futureClusters;

  String selectedCategory = 'World'; // Default selected category
  final List<String> categories = ['World', 'Nature'];

  @override
  void initState() {
    super.initState();
    futureClusters = ApiService.fetchClusters();
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('EEE, d MMM yyyy').format(DateTime.now());

    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Arial',
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,

          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                pinned: false,
                elevation: 0,
                expandedHeight: 50.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.all(0),
                  background: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.bottomCenter, // Aligns content to the bottom
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/kite_logo.png', // Replace with your actual path
                                width: 32, // Adjust the size of the logo
                                height: 32,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Kite',
                                style: const TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          const Icon(Icons.settings, color: Colors.grey, size: 28),
                        ],
                      ),
                    ),
                  ),
                ),
                backgroundColor: Colors.white,
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: _StickyHeaderDelegate(
                  category: selectedCategory,
                  childBuilder: (currentCategory) {
                    return Container(
                      height: 100.0,
                      color: Colors.white,
                      child: Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16.0),
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Handle left arrow click
                                },
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _showCategorySelector(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 130.0, vertical: 4.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        currentCategory, // Pass the dynamic category
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle right arrow click
                                },
                                icon: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                      color: Colors.white, // Background color of the container
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            todayDate,
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                },
                                icon: const Icon(
                                  Icons.menu,
                                  color: Colors.blue,
                                  size: 24.0,
                                ),
                              ),
                              const SizedBox(width: 8), // Space between icons
                              IconButton(
                                onPressed: () {
                                },
                                icon: const Icon(
                                  Icons.map,
                                  color: Colors.grey,
                                  size: 24.0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adds horizontal padding
                      child: const Divider(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),


              SliverToBoxAdapter(
                child: FutureBuilder<List<Cluster>>(
                  future: futureClusters,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (snapshot.hasData) {
                      final clusters = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clusters.length,
                        itemBuilder: (context, index) {
                          final cluster = clusters[index];
                          final categoryColor = _getCategoryColor(cluster.category);

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return InkWell(
                                onTap: () {
                                  setState(() => cluster.isExpanded = !cluster.isExpanded);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
                                  decoration: const BoxDecoration(
                                    color: Colors.transparent,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 8,
                                              height: 8,
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                color: categoryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            Text(
                                              cluster.category,
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '${cluster.numberOfTitles} Sources',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                            const Spacer(),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.share, size: 18),
                                            const SizedBox(width: 8),
                                            const Icon(Icons.check_circle, size: 18, color: Colors.grey),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(cluster.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
                                            const SizedBox(height: 4),
                                          ],
                                        ),
                                      ),
                                      if (cluster.isExpanded)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(cluster.shortSummary, style: const TextStyle(fontSize: 14.0)),
                                              const SizedBox(height: 50),
                                              if (cluster.talkingPoints.isNotEmpty)
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      const Text(
                                                        "Highlights",
                                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                      ),

                                                      const SizedBox(height: 8),
                                                      const DashedDivider(
                                                        color: Colors.grey,
                                                        dashWidth: 5.0,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      ...List.generate(
                                                        cluster.talkingPoints!.length, (index) {
                                                        final point = cluster.talkingPoints![index];

                                                        final splitPoint = point.indexOf(':');
                                                        final title = splitPoint != -1 ? point.substring(0, splitPoint + 1) : '';
                                                        final content = splitPoint != -1 ? point.substring(splitPoint + 1).trim() : point;

                                                        return Column(
                                                          children: [
                                                            const SizedBox(height: 8),
                                                            Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          CircleAvatar(
                                                                            radius: 12,
                                                                            backgroundColor: Colors.orangeAccent,
                                                                            child: Text(
                                                                              '${index + 1}',
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 12,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          const SizedBox(width: 10), // Space between circle and title
                                                                          Text(
                                                                            title,
                                                                            style: const TextStyle(
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 16,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 10), // Space between title and content
                                                                      Text(
                                                                        content,
                                                                        style: const TextStyle(
                                                                          fontSize: 14,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            if (index < cluster.talkingPoints!.length)
                                                              const Padding(
                                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                                child: DashedDivider(
                                                                  color: Colors.grey,
                                                                  dashWidth: 5.0,
                                                                ),
                                                              ),
                                                          ],
                                                        );
                                                      },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              const SizedBox(height: 50),


                                              if (cluster.quote.isNotEmpty) ...[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFF3F6FF), // Background color
                                                    borderRadius: BorderRadius.circular(20), // Rounded corners
                                                    border: Border.all(
                                                      color: Color(0xFFF3F6FF),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      // Opening quote symbol (using the exact Unicode for normal quotes)
                                                      const Text(
                                                        '”', // Same character as the text quotes
                                                        style: TextStyle(
                                                          fontSize: 48, // Large size for the opening quote
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black, // Color of the quote
                                                          height: 0.8, // Adjust height to position quote closer to text
                                                        ),
                                                      ),
                                                      // Main quote text
                                                      Text(
                                                        cluster.quote,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0,
                                                          height: 1.5, // Line height for readability
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Author name
                                                      Text(
                                                        cluster.quoteAuthor,
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      Text(
                                                        cluster.location,
                                                        style: const TextStyle(
                                                          fontSize: 12.0,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      // Button
                                                      OutlinedButton(
                                                        onPressed: () async {

                                                        },
                                                        style: OutlinedButton.styleFrom(
                                                          side: const BorderSide(color: Colors.blue), // Outline color
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(20), // Rounded corners
                                                          ),
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Button padding
                                                        ),
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min, // Ensures the button adjusts to content
                                                          children: [
                                                            const Icon(Icons.language, size: 16, color: Colors.blue), // Language icon
                                                            const SizedBox(width: 4), // Space between icon and text
                                                            Text(
                                                              cluster.quoteSourceDomain,
                                                              style: const TextStyle(
                                                                fontSize: 12.0,
                                                                color: Colors.blue,
                                                                decoration: TextDecoration.none, // Remove underline for button text
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 50)
                                              ],

                                              if (cluster.perspectives?.isNotEmpty ?? false) ...[
                                                const Text("Perspectives", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                                const SizedBox(height: 20),
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Row(
                                                    children: cluster.perspectives!.map((perspective) {
                                                      final splitPoint = perspective.text.indexOf(':');
                                                      final title = splitPoint != -1 ? perspective.text.substring(0, splitPoint + 1) : '';
                                                      final content = splitPoint != -1 ? perspective.text.substring(splitPoint + 1).trim() : perspective.text;

                                                      return Container(
                                                        width: 280,
                                                        height: 280,
                                                        margin: const EdgeInsets.only(right: 16.0),
                                                        padding: const EdgeInsets.all(12),
                                                        decoration: BoxDecoration(
                                                          color: Color(0xFFF5F5F5),
                                                          borderRadius: BorderRadius.circular(12),
                                                          border: Border.all(color: Color(0xFFF5F5F5)),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey.withOpacity(0),
                                                              spreadRadius: 1,
                                                              blurRadius: 5,
                                                              offset: const Offset(0, 3),
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              title,
                                                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            Text(
                                                              content,
                                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                                                            ),
                                                            const SizedBox(height: 8),
                                                            // Add other contents here...
                                                            const Spacer(), // Pushes the button to the bottom
                                                            ...?perspective.sources?.map((source) {
                                                              return Padding(
                                                                padding: const EdgeInsets.only(bottom: 8), // Adds padding at the bottom
                                                                child: Align(
                                                                  alignment: Alignment.bottomLeft,
                                                                  child: OutlinedButton.icon(
                                                                    onPressed: () {
                                                                      // Handle link opening
                                                                    },
                                                                    icon: const Icon(Icons.language, size: 16, color: Colors.blue),
                                                                    label: Text(
                                                                      source.name,
                                                                      style: const TextStyle(fontSize: 14, color: Colors.blue),
                                                                    ),
                                                                    style: OutlinedButton.styleFrom(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                      side: const BorderSide(color: Colors.blue),
                                                                      shape: RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.circular(20),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                          ],
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],

                                              const SizedBox(height: 50),
                                              if (cluster.geopoliticalContext.isNotEmpty) ...[
                                                const Text(
                                                  "Geopolitical context",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  cluster.geopoliticalContext,
                                                  style: const TextStyle(fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 50),
                                              ],

                                              if (cluster.historicalBackground.isNotEmpty) ...[
                                                const Text(
                                                  "Historical background",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  cluster.historicalBackground,
                                                  style: const TextStyle(fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 50),
                                              ],

                                              if (cluster.internationalReactions.isNotEmpty) ...[
                                                const Text(
                                                  "International Reactions",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                ),
                                                const SizedBox(height: 20),
                                                _buildExpandedSection(cluster, setState),
                                                const SizedBox(height: 50),
                                              ],

                                              if (cluster.economicImplications.isNotEmpty) ...[
                                                const Text(
                                                  "Economic implications",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  cluster.economicImplications,
                                                  style: const TextStyle(fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 50),
                                              ],

                                              if (cluster.humanitarianImpact.isNotEmpty) ...[
                                                const Text(
                                                  "Humanitarian impact",
                                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                ),
                                                const SizedBox(height: 20),
                                                Text(
                                                  cluster.humanitarianImpact,
                                                  style: const TextStyle(fontSize: 14.0),
                                                ),
                                                const SizedBox(height: 50),
                                              ],

                                              if (cluster.timeline.isNotEmpty) ...[
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Timeline of events",
                                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Column(
                                                      children: List.generate(cluster.timeline!.length, (index) {
                                                        final event = cluster.timeline![index];

                                                        final strSplitEventPoint = event.indexOf(':');
                                                        final strEventDate = strSplitEventPoint != -1 ? event.substring(0, strSplitEventPoint + 1) : '';
                                                        final strEventContent = strSplitEventPoint != -1 ? event.substring(strSplitEventPoint + 2).trim() : event;

                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 16.0),
                                                          child: Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  CircleAvatar(
                                                                    radius: 12,
                                                                    backgroundColor: Colors.blueAccent,
                                                                    child: Text(
                                                                      '${index + 1}',
                                                                      style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  if (index != cluster.timeline!.length - 1)
                                                                    Container(
                                                                      width: 2,
                                                                      height: 60,
                                                                      color: Colors.blueAccent,
                                                                      margin: const EdgeInsets.only(top: 20),
                                                                    ),
                                                                ],
                                                              ),
                                                              const SizedBox(width: 8),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      strEventDate,
                                                                      style: const TextStyle(
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 16,
                                                                        color: Colors.blueAccent,
                                                                      ),
                                                                    ),
                                                                    const SizedBox(height: 4),
                                                                    Text(
                                                                      strEventContent,
                                                                      style: const TextStyle(fontSize: 14),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                    const SizedBox(height: 50),
                                                  ],
                                                )
                                              ],

                                              if (cluster.userActionItems.isNotEmpty) ...[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFEDFCE7), // Background color
                                                    borderRadius: BorderRadius.circular(20), // Rounded corners
                                                    border: Border.all(
                                                      color: Color(0xFFEDFCE7),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Action Items",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 15),
                                                      ...List.generate(cluster.userActionItems!.length, (index) {
                                                        final actionItem = cluster.userActionItems![index];
                                                        return Padding(
                                                          padding: const EdgeInsets.only(bottom: 8.0),
                                                          child: Text(
                                                            actionItem,
                                                            style: const TextStyle(fontSize: 14.0),
                                                          ),
                                                        );
                                                      }),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 50)
                                              ],

                                              if (cluster.didYouKnow.isNotEmpty) ...[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFCAD9FC), // Background color
                                                    borderRadius: BorderRadius.circular(20), // Rounded corners
                                                    border: Border.all(
                                                      color: Color(0xFFCAD9FC),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "Did you know?",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16.0,
                                                          height: 1.5,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 15),
                                                      Text(
                                                        cluster.didYouKnow,
                                                        style: const TextStyle(fontSize: 14.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(height: 50)
                                              ],

                                              ElevatedButton(
                                                onPressed: () => setState(() => cluster.isExpanded = false),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.black, // Black background
                                                  foregroundColor: Colors.white, // White text
                                                  side: const BorderSide(color: Colors.black, width: 1), // White outlined border
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20), // Optional rounded corners
                                                  ),
                                                  padding: const EdgeInsets.symmetric(vertical: 12), // Optional padding for better button height
                                                  minimumSize: Size(double.infinity, 48), // Full width with minimum height
                                                ),
                                                child: const Text('Close Article', style: TextStyle(fontWeight: FontWeight.bold)),
                                              )
                                            ],
                                          ),
                                        ),
                                      const Divider(),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('No clusters found'));
                    }
                  },
                ),
              ),
            ]
          )
        )
    );
  }

  Widget _buildExpandedSection(Cluster cluster, void Function(void Function()) setState) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (cluster.internationalReactions != null) _buildInternationalReactions(cluster.internationalReactions),
        ],
      ),
    );
  }

  Widget _buildInternationalReactions(dynamic reactions) {
    if (reactions is List) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reactions.map<Widget>((reaction) {
          final splitReaction = reaction.indexOf(':');
          final country = splitReaction != -1 ? reaction.substring(0, splitReaction).trim() : '';
          final splitCountry = country.indexOf(' ');
          final countryFirstName = splitCountry != -1 ? country.substring(splitCountry + 1).trim() : country;
          final text = splitReaction != -1 ? reaction.substring(splitReaction + 1).trim() : reaction;
          return _buildReactionCard(countryFirstName, text);
        }).toList(),
      );
    } else if (reactions is String) {
      return _buildReactionCard("General", reactions);
    }
    return Container();
  }

  Widget _buildReactionCard(String country, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // getFlagIcon(country),
              Text(country, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  // Returns a specific color for each category.
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'politics':
        return Colors.red;
      case 'protests':
        return Colors.blue;
      case 'conflict':
        return Colors.yellow;
      case 'disaster':
        return Colors.pink;
      case 'climate':
        return Colors.grey;
      case 'diplomacy':
        return Colors.black;
      case 'elections':
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  void _showCategorySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                categories[index],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: selectedCategory == categories[index] ? Colors.blue : Colors.black,
                ),
              ),
              onTap: () {
                setState(() {
                  selectedCategory = categories[index];
                });
                Navigator.pop(context); // Close the bottom sheet
              },
            );
          },
        );
      },
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget Function(String category) childBuilder;
  final String category;

  _StickyHeaderDelegate({required this.childBuilder, required this.category});

  @override
  double get minExtent => 100.0;

  @override
  double get maxExtent => 100.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return childBuilder(category);
  }

  @override
  bool shouldRebuild(covariant _StickyHeaderDelegate oldDelegate) {
    return oldDelegate.category != category;
  }
}