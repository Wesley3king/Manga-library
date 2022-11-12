import 'package:hive/hive.dart';
import 'package:manga_library/app/models/system_settings.dart';

class SystemSettingsModelHiveAdapter extends TypeAdapter<SystemSettingsModel> {
  @override
  int get typeId => 1;

  @override
  SystemSettingsModel read(BinaryReader reader) {
    return SystemSettingsModel(
        ordination: reader.readString(),
        frameSize: reader.readString(),
        update: reader.readString(),
        updateTheCovers: reader.readBool(),
        hiddenLibraryPassword: reader.readString(),
        theme: reader.readString(),
        interfaceColor: reader.readString(),
        language: reader.readString(),
        rollTheBar: reader.readBool(),
        readerType: reader.readString(),
        backgroundColor: reader.readString(),
        readerGuidance: reader.readString(),
        quality: reader.readString(),
        fullScreen: reader.readBool(),
        keepScreenOn: reader.readBool(),
        showControls: reader.readBool(),
        customShine: reader.readBool(),
        customShineValue: reader.readDouble(),
        customFilter: reader.readBool(),
        R: reader.readInt(),
        G: reader.readInt(),
        B: reader.readInt(),
        blackAndWhiteFilter: reader.readBool(),
        layout: reader.readString(),
        showLayout: reader.readBool(),
        scrollWebtoon: reader.readInt(),
        storageLocation: reader.readString(),
        authentication: reader.readBool(),
        authenticationType: reader.readString(),
        authenticationPassword: reader.readString(),
        multipleSearches: reader.readBool(),
        nSFWContent: reader.readBool(),
        showNSFWInList: reader.readBool(),
        clearCache: reader.readBool(),
        restore: reader.readBool());
  }

  @override
  void write(BinaryWriter writer, SystemSettingsModel obj) {
    writer.writeString(obj.ordination);
    writer.writeString(obj.frameSize);
    writer.writeString(obj.update);
    writer.writeBool(obj.updateTheCovers);
    writer.writeString(obj.hiddenLibraryPassword);
    writer.writeString(obj.theme);
    writer.writeString(obj.interfaceColor);
    writer.writeString(obj.language);
    writer.writeBool(obj.rollTheBar);
    writer.writeString(obj.readerType);
    writer.writeString(obj.backgroundColor);
    writer.writeString(obj.readerGuidance);
    writer.writeString(obj.quality);
    writer.writeBool(obj.fullScreen);
    writer.writeBool(obj.keepScreenOn);
    writer.writeBool(obj.showControls);
    writer.writeBool(obj.customShine);
    writer.writeDouble(obj.customShineValue);
    writer.writeBool(obj.customFilter);
    writer.writeInt(obj.R);
    writer.writeInt(obj.G);
    writer.writeInt(obj.B);
    writer.writeBool(obj.blackAndWhiteFilter);
    writer.writeString(obj.layout);
    writer.writeBool(obj.showLayout);
    writer.writeInt(obj.scrollWebtoon);
    writer.writeString(obj.storageLocation);
    writer.writeBool(obj.authentication);
    writer.writeString(obj.authenticationType);
    writer.writeString(obj.authenticationPassword);
    writer.writeBool(obj.multipleSearches);
    writer.writeBool(obj.nSFWContent);
    writer.writeBool(obj.showNSFWInList);
    writer.writeBool(obj.clearCache);
    writer.writeBool(obj.restore);
  }
}
