import 'package:flutter/material.dart';
import 'package:cintli_montessori/core/theme/app_icons.dart';
import 'package:firebase_database/firebase_database.dart';
import '../core/widgets/custom_drawer.dart';
import '../core/theme/colors.dart';

/// Muestra categorías del directorio de personal almacenado en RTDB.
///
/// Este módulo es heredado y permanece aislado hasta su futura migración a
/// modelos tipados y Cloud Firestore.
class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _staffCategories = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadStaffCategories();
  }

  Future<void> _loadStaffCategories() async {
    try {
      final snapshot = await _dbRef.child('staff').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};

      if (!mounted) return;
      setState(() {
        _staffCategories =
            data.entries.map((entry) {
              return {
                'id': entry.key,
                'name': _getCategoryName(entry.key),
                'memberCount': entry.value['count'],
                'icon': _getCategoryIcon(entry.key),
                'color': _getCategoryColor(entry.key),
              };
            }).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No fue posible cargar el directorio de personal.';
      });
    }
  }

  String _getCategoryName(String categoryId) {
    final Map<String, String> names = {
      'mantenimiento': 'Mantenimiento',
      'gimnasia': 'Educación Física',
      'oficina': 'Oficina',
      'coordinacion': 'Coordinación',
      'musica': 'Música',
      'danza': 'Danza',
      'direccion': 'Dirección',
    };
    return names[categoryId] ?? categoryId;
  }

  IconData _getCategoryIcon(String categoryId) {
    final Map<String, IconData> icons = {
      'mantenimiento': AppIcons.handyman,
      'gimnasia': AppIcons.sportsGymnastics,
      'oficina': AppIcons.workOutline,
      'coordinacion': AppIcons.supervisorAccount,
      'musica': AppIcons.musicNote,
      'danza': AppIcons.peopleOutline,
      'direccion': AppIcons.school,
    };
    return icons[categoryId] ?? AppIcons.personOutline;
  }

  Color _getCategoryColor(String categoryId) {
    final Map<String, Color> colors = {
      'mantenimiento': Colors.brown,
      'gimnasia': Colors.orange,
      'oficina': Colors.blueGrey,
      'coordinacion': Colors.purple,
      'musica': Colors.indigo,
      'danza': Colors.pink,
      'direccion': Colors.red,
    };
    return colors[categoryId] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Escolar'),
        backgroundColor: isDarkMode ? Colors.grey[900] : AppColors.primaryBlue,
        foregroundColor: Colors.white,
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: const Icon(AppIcons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
        ),
      ),
      drawer: const CustomDrawer(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                itemCount: _staffCategories.length,
                itemBuilder: (context, index) {
                  final category = _staffCategories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: (category['color'] as Color).withValues(alpha: 0.2),
          child: Icon(category['icon'], color: category['color']),
        ),
        title: Text(
          category['name'],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('${category['memberCount']} miembros'),
        trailing: const Icon(AppIcons.chevronRight),
        onTap:
            () => _navigateToCategoryMembers(
              context,
              category['id'],
              category['name'],
            ),
      ),
    );
  }

  void _navigateToCategoryMembers(
    BuildContext context,
    String categoryId,
    String categoryName,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CategoryMembersScreen(
              categoryId: categoryId,
              categoryName: categoryName,
            ),
      ),
    );
  }
}

/// Muestra integrantes de una categoría del módulo heredado de personal.
class CategoryMembersScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryMembersScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryMembersScreen> createState() => _CategoryMembersScreenState();
}

class _CategoryMembersScreenState extends State<CategoryMembersScreen> {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    try {
      final snapshot =
          await _dbRef.child('staff/${widget.categoryId}/members').once();
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};

      List<Map<String, dynamic>> members =
          data.entries.map((entry) {
            return {
              'id': entry.key,
              'name': entry.value['name'],
              'position': _getPosition(widget.categoryId),
              'schedule': _getSchedule(widget.categoryId),
            };
          }).toList();

      members.sort(
        (a, b) => a['name'].toString().compareTo(b['name'].toString()),
      );

      if (!mounted) return;
      setState(() {
        _members = members;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'No fue posible cargar los integrantes del personal.';
      });
    }
  }

  String _getPosition(String categoryId) {
    final positions = {
      'mantenimiento': 'Personal de mantenimiento',
      'gimnasia': 'Instructor de educación física',
      'oficina': 'Personal administrativo',
      'coordinacion': 'Coordinador académico',
      'musica': 'Profesor de música',
      'danza': 'Instructor de danza',
      'direccion': 'Directivo escolar',
    };
    return positions[categoryId] ?? 'Miembro del personal';
  }

  String _getSchedule(String categoryId) {
    final schedules = {
      'mantenimiento': 'L-V 7:00 - 16:00',
      'gimnasia': 'L-J 9:00 - 14:00',
      'oficina': 'L-V 8:00 - 15:00',
      'coordinacion': 'L-V 8:00 - 16:00',
      'musica': 'Ma-J 10:00 - 13:00',
      'danza': 'Mi-V 11:00 - 14:00',
      'direccion': 'L-V 8:00 - 17:00',
    };
    return schedules[categoryId] ?? 'L-V 8:00 - 15:00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: _getCategoryColor(widget.categoryId),
        foregroundColor: Colors.white,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                itemCount: _members.length,
                itemBuilder: (context, index) {
                  return _buildMemberCard(_members[index]);
                },
              ),
    );
  }

  Widget _buildMemberCard(Map<String, dynamic> member) {
    final categoryColor = _getCategoryColor(widget.categoryId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: categoryColor.withValues(alpha: 0.2),
          child: Icon(AppIcons.person, color: categoryColor),
        ),
        title: Text(
          member['name'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member['position']),
            Text('Horario: ${member['schedule']}'),
          ],
        ),
        trailing: const Icon(AppIcons.chevronRight),
      ),
    );
  }

  Color _getCategoryColor(String categoryId) {
    final Map<String, Color> colors = {
      'mantenimiento': Colors.brown,
      'gimnasia': Colors.orange,
      'oficina': Colors.blueGrey,
      'coordinacion': Colors.purple,
      'musica': Colors.indigo,
      'danza': Colors.pink,
      'direccion': Colors.red,
    };
    return colors[categoryId] ?? Colors.grey;
  }
}
