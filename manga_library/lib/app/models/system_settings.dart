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
    required this.Custom Shine,
    required this.Custom Shine Value,
    required this.Custom Filter,
    required this.R,
    required this.G,
    required this.B,
    required this.Black and White filter,
    required this.Layout,
    required this.ShowLayout,
    required this.ScrollWebtoon,
    required this.Local de armazenamento,
    required this.Autenticação,
    required this.Tipo de Autenticação,
    required this.Senha de Autenticação,
    required this.Multiplas Pesquisas,
    required this.Conteudo NSFW,
    required this.Mostrar na Lista,
    required this.Limpar o Cache,
    required this.Restaurar,
  });
  late final String ordination;
  late final String frameSize;
  late final String update;
  late final bool updateTheCovers;
  late final String hiddenLibraryPassword;
  late final String theme;
  late final String interfaceColor;
  late final String language;
  late final bool rollTheBar;
  late final String readerType;
  late final String backgroundColor;
  late final String readerGuidance;
  late final String quality;
  late final bool fullScreen;
  late final bool keepScreenOn;
  late final bool showControls;
  late final bool Custom Shine;
  late final double Custom Shine Value;
  late final bool Custom Filter;
  late final int R;
  late final int G;
  late final int B;
  late final bool Black and White filter;
  late final String Layout;
  late final bool ShowLayout;
  late final int ScrollWebtoon;
  late final String Local de armazenamento;
  late final bool Autenticação;
  late final String Tipo de Autenticação;
  late final String Senha de Autenticação;
  late final bool Multiplas Pesquisas;
  late final bool Conteudo NSFW;
  late final bool Mostrar na Lista;
  late final bool Limpar o Cache;
  late final bool Restaurar;
  
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
    Custom Shine = json['Custom Shine'];
    Custom Shine Value = json['Custom Shine Value'];
    Custom Filter = json['Custom Filter'];
    R = json['R'];
    G = json['G'];
    B = json['B'];
    Black and White filter = json['Black and White filter'];
    Layout = json['Layout'];
    ShowLayout = json['ShowLayout'];
    ScrollWebtoon = json['ScrollWebtoon'];
    Local de armazenamento = json['Local de armazenamento'];
    Autenticação = json['Autenticação'];
    Tipo de Autenticação = json['Tipo de Autenticação'];
    Senha de Autenticação = json['Senha de Autenticação'];
    Multiplas Pesquisas = json['Multiplas Pesquisas'];
    Conteudo NSFW = json['Conteudo NSFW'];
    Mostrar na Lista = json['Mostrar na Lista'];
    Limpar o Cache = json['Limpar o Cache'];
    Restaurar = json['Restaurar'];
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
    data['Custom Shine'] = Custom Shine;
    data['Custom Shine Value'] = Custom Shine Value;
    data['Custom Filter'] = Custom Filter;
    data['R'] = R;
    data['G'] = G;
    data['B'] = B;
    data['Black and White filter'] = Black and White filter;
    data['Layout'] = Layout;
    data['ShowLayout'] = ShowLayout;
    data['ScrollWebtoon'] = ScrollWebtoon;
    data['Local de armazenamento'] = Local de armazenamento;
    data['Autenticação'] = Autenticação;
    data['Tipo de Autenticação'] = Tipo de Autenticação;
    data['Senha de Autenticação'] = Senha de Autenticação;
    data['Multiplas Pesquisas'] = Multiplas Pesquisas;
    data['Conteudo NSFW'] = Conteudo NSFW;
    data['Mostrar na Lista'] = Mostrar na Lista;
    data['Limpar o Cache'] = Limpar o Cache;
    data['Restaurar'] = Restaurar;
    return data;
  }
}