class Position {
  String id;
  String name;
  String description;
  double hourlyRate; // Mức lương theo giờ
  double averageSalary; // Mức lương trung bình

  Position({
    required this.id,
    required this.name,
    required this.description,
    required this.hourlyRate,
    required this.averageSalary,
  });
}
