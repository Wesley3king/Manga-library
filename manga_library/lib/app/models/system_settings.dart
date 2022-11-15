class SystemSettingsModel {
  SystemSettingsModel({
    required this.ordination,
    required this.frameSize,
    required this.update,
    required this.updateTheCovers,
    required this.hiddenLibraryPassword,
    required this.theme,
    required this.interfaceColor,
    required this.language,
    required this.rollTheBar,
    required this.readerType,
    required this.backgroundColor,
    required this.readerGuidance,
    required this.quality,
    required this.fullScreen,
    required this.keepScreenOn,
    required this.showControls,
    required this.customShine,
    required this.customShineValue,
    required this.customFilter,
    required this.R,
    required this.G,
    required this.B,
    required this.blackAndWhiteFilter,
    required this.layout,
    required this.showLayout,
    required this.scrollWebtoon,
    required this.storageLocation,
    required this.authentication,
    required this.authenticationType,
    required this.authenticationPassword,
    required this.multipleSearches,
    required this.nSFWContent,
    required this.showNSFWInList,
    required this.clearCache,
    required this.restore,
  });
  late String ordination;
  late String frameSize;
  late String update;
  late bool updateTheCovers;
  late String hiddenLibraryPassword;
  late String theme;
  late String interfaceColor;
  late String language;
  late bool rollTheBar;
  late String readerType;
  late String backgroundColor;
  late String readerGuidance;
  late String quality;
  late bool fullScreen;
  late bool keepScreenOn;
  late bool showControls;
  late bool customShine;
  late double customShineValue;
  late bool customFilter;
  late int R;
  late int G;
  late int B;
  late bool blackAndWhiteFilter;
  late String layout;
  late bool showLayout;
  late int scrollWebtoon;
  late String storageLocation;
  late bool authentication;
  late String authenticationType;
  late String authenticationPassword;
  late bool multipleSearches;
  late bool nSFWContent;
  late bool showNSFWInList;
  late bool clearCache;
  late bool restore;
  
  SystemSettingsModel.fromJson(Map<String, dynamic> json){
    ordination = json['ordination'];
    frameSize = json['frameSize'];
    update = json['update'];
    updateTheCovers = json['updateTheCovers'];
    hiddenLibraryPassword = json['hiddenLibraryPassword'];
    theme = json['theme'];
    interfaceColor = json['interfaceColor'];
    language = json['language'];
    rollTheBar = json['rollTheBar'];
    readerType = json['readerType'];
    backgroundColor = json['backgroundColor'];
    readerGuidance = json['readerGuidance'];
    quality = json['quality'];
    fullScreen = json['fullScreen'];
    keepScreenOn = json['keepScreenOn'];
    showControls = json['showControls'];
    customShine = json['customShine'];
    customShineValue = json['customShineValue'];
    customFilter = json['customFilter'];
    R = json['R'];
    G = json['G'];
    B = json['B'];
    blackAndWhiteFilter = json['blackAndWhiteFilter'];
    layout = json['layout'];
    showLayout = json['showLayout'];
    scrollWebtoon = json['scrollWebtoon'];
    storageLocation = json['storageLocation'];
    authentication = json['authentication'];
    authenticationType = json['authenticationType'];
    authenticationPassword = json['authenticationPassword'];
    multipleSearches = json['multipleSearches'];
    nSFWContent = json['nSFWContent'];
    showNSFWInList = json['showNSFWInList'];
    clearCache = json['clearCache'];
    restore = json['restore'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['ordination'] = ordination;
    data['frameSize'] = frameSize;
    data['update'] = update;
    data['updateTheCovers'] = updateTheCovers;
    data['hiddenLibraryPassword'] = hiddenLibraryPassword;
    data['theme'] = theme;
    data['interfaceColor'] = interfaceColor;
    data['language'] = language;
    data['rollTheBar'] = rollTheBar;
    data['readerType'] = readerType;
    data['backgroundColor'] = backgroundColor;
    data['readerGuidance'] = readerGuidance;
    data['quality'] = quality;
    data['fullScreen'] = fullScreen;
    data['keepScreenOn'] = keepScreenOn;
    data['showControls'] = showControls;
    data['customShine'] = customShine;
    data['customShineValue'] = customShineValue;
    data['customFilter'] = customFilter;
    data['R'] = R;
    data['G'] = G;
    data['B'] = B;
    data['blackAndWhiteFilter'] = blackAndWhiteFilter;
    data['layout'] = layout;
    data['showLayout'] = showLayout;
    data['scrollWebtoon'] = scrollWebtoon;
    data['storageLocation'] = storageLocation;
    data['authentication'] = authentication;
    data['authenticationType'] = authenticationType;
    data['authenticationPassword'] = authenticationPassword;
    data['multipleSearches'] = multipleSearches;
    data['nSFWContent'] = nSFWContent;
    data['showNSFWInList'] = showNSFWInList;
    data['clearCache'] = clearCache;
    data['restore'] = restore;
    return data;
  }
}