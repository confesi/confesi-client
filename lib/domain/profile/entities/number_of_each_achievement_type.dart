/// Defines how many of each rarity of achievement there are.
class NumberOfEachAchievementType {
  int _commons = 0;
  int _rares = 0;
  int _epics = 0;
  int _legendaries = 0;

  int get commons => _commons;
  int get rares => _rares;
  int get epics => _epics;
  int get legendaries => _legendaries;

  void addCommmon(int n) => _commons += n;
  void addRare(int n) => _rares += n;
  void addEpic(int n) => _epics += n;
  void addLegendary(int n) => _legendaries += n;
}
