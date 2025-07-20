class SkillItem {
  final String name;
  final int years;
  final bool isCurrentlyUsing;
  final bool hasSubTechnologies;
  final Map<String, List<String>>? subTechnologies;

  SkillItem(
    this.name,
    this.years, {
    this.isCurrentlyUsing = false,
    this.hasSubTechnologies = false,
    this.subTechnologies,
  });
}
