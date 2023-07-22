class Features {
  bool featureOneEnabled;
  bool featureTwoEnabled;

  Features({
    this.featureOneEnabled = false,
    this.featureTwoEnabled = true,
  });

  factory Features.fromJson(Map<String, dynamic> json) {
    return Features(
      featureOneEnabled: json['feature_one_enabled'] ?? false,
      featureTwoEnabled: json['feature_two_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['feature_one_enabled'] = featureOneEnabled;
    data['feature_two_enabled'] = featureTwoEnabled;
    return data;
  }
}

class Welcome {
  String welcomeMessage;
  String otherMessage;

  Welcome({
    this.welcomeMessage = 'Welcome',
    this.otherMessage = 'Hello, there!',
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      welcomeMessage: json['welcome_message'] ?? 'Welcome',
      otherMessage: json['other_message'] ?? 'Hello, there!',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['welcome_message'] = welcomeMessage;
    data['other_message'] = otherMessage;
    return data;
  }
}

class RemoteConfig {
  Welcome messages;
  Features appFeatures;

  RemoteConfig({
    Welcome? messages,
    Features? appFeatures,
  })  : messages = messages ?? Welcome(),
        appFeatures = appFeatures ?? Features();

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    return RemoteConfig(
      messages: json['messages'] != null ? Welcome.fromJson(json['messages']) : Welcome(),
      appFeatures: json['app_features'] != null ? Features.fromJson(json['app_features']) : Features(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['messages'] = messages.toJson();
    data['app_features'] = appFeatures.toJson();
    return data;
  }
}
