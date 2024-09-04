class RoleUtils {
  static const String admin = 'Admin';
  static const String teacher = 'Guru';
  static const String student = 'Siswa';
  static const String psychologist = 'Psikolog';

  static const List<Map<int, String>> roles = [
    {1: admin},
    {2: teacher},
    {3: student},
    {4: psychologist},
  ];

  static String getRole(int role) {
    if (role < 1 || role > 4) {
      return 'Unknown';
    }

    return roles
        .firstWhere((element) => element.keys.first == role)
        .values
        .first;
  }

  static int getRoleIndex(String role) {
    return roles.indexWhere((element) => element.values.first == role) + 1;
  }

  static List<String> getRoles() {
    return roles.map((e) => e.values.first).toList();
  }
}
