class Cluster {
  final int clusterNumber;
  final String category;
  final String title;
  final String shortSummary;
  final int numberOfTitles;
  final String didYouKnow;
  final dynamic talkingPoints;
  final String quote;
  final String quoteAuthor;
  final String quoteSourceUrl;
  final String quoteSourceDomain;
  final String location;
  final List<Perspective>? perspectives;
  final String geopoliticalContext;
  final String historicalBackground;
  final dynamic internationalReactions;
  final String humanitarianImpact;
  final String economicImplications;
  final dynamic timeline;
  final dynamic futureOutlook;
  final dynamic userActionItems;
  final String? emoji;
  bool isExpanded;

  Cluster({
    required this.clusterNumber,
    required this.category,
    required this.title,
    required this.shortSummary,
    required this.numberOfTitles,
    required this.didYouKnow,
    this.talkingPoints,
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSourceUrl,
    required this.quoteSourceDomain,
    required this.location,
    this.perspectives,
    required this.geopoliticalContext,
    required this.historicalBackground,
    this.internationalReactions,
    required this.humanitarianImpact,
    required this.economicImplications,
    required this.timeline,
    required this.futureOutlook,
    this.userActionItems,
    this.emoji,
    this.isExpanded = false,
  });

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(
      clusterNumber: json['cluster_number'],
      category: json['category'],
      title: json['title'],
      shortSummary: json['short_summary'],
      didYouKnow: json['did_you_know'],
      numberOfTitles: json['number_of_titles'],
      // Handle talking points as List<String> or String
      talkingPoints: _parseStringOrList(json['talking_points']),

      quote: json['quote'],
      quoteAuthor: json['quote_author'],
      quoteSourceUrl: json['quote_source_url'],
      quoteSourceDomain: json['quote_source_domain'],
      location: json['location'],

      perspectives: json['perspectives'] != null
          ? (json['perspectives'] as List)
          .map((p) => Perspective.fromJson(p))
          .toList()
          : null,

      geopoliticalContext: json['geopolitical_context'],
      historicalBackground: json['historical_background'],

      internationalReactions: _parseStringOrList(json['international_reactions']),

      humanitarianImpact: json['humanitarian_impact'],
      economicImplications: json['economic_implications'],

      timeline: _parseStringOrList(json['timeline']),

      futureOutlook: _parseStringOrList(json['future_outlook']),

      userActionItems: _parseStringOrList(json['user_action_items']),

      emoji: json['emoji'],
    );
  }

  static List<String>? _parseListOfStrings(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is List) {
      return List<String>.from(value);
    } else if (value is String) {
      return [value];
    } else {
      throw Exception("Unexpected type: $value");
    }
  }

  static dynamic _parseStringOrList(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is List) {
      return List<String>.from(value);
    } else if (value is String) {
      return value;  // Return as String
    } else {
      throw Exception("Unexpected type for international_reactions: $value");
    }
  }
}

class Perspective {
  final String text;
  final List<Source>? sources;

  Perspective({required this.text, this.sources});

  factory Perspective.fromJson(Map<String, dynamic> json) {
    return Perspective(
      text: json['text'],
      sources: json['sources'] != null
          ? (json['sources'] as List).map((s) => Source.fromJson(s)).toList()
          : null,
    );
  }
}

class Source {
  final String name;
  final String url;

  Source({required this.name, required this.url});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'],
      url: json['url'],
    );
  }
}
