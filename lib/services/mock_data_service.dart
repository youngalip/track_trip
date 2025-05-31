import 'package:track_trip/models/expense.dart';
import 'package:track_trip/models/budget.dart';
import 'package:track_trip/models/schedule.dart';
import 'package:uuid/uuid.dart';

// Layanan untuk menyediakan data dummy untuk pengembangan frontend
class MockDataService {
  final uuid = const Uuid();

  // Mendapatkan daftar pengeluaran dummy
  Future<List<Expense>> getMockExpenses() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    
    return [
      Expense(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Makan Siang',
        amount: 35000,
        date: DateTime(now.year, now.month, now.day, 12, 30),
        category: 'Makanan',
        note: 'Makan di kantin kampus',
      ),
      Expense(
        id: uuid.v4(),
        title: 'Transportasi Ojek Online',
        userId: 'mock-user', // Tambahkan ini
        amount: 25000,
        date: DateTime(now.year, now.month, now.day, 8, 15),
        category: 'Transportasi',
        note: 'Perjalanan ke kampus',
      ),
      Expense(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Beli Buku',
        amount: 75000,
        date: DateTime(now.year, now.month, now.day, 15, 0),
        category: 'Pendidikan',
        note: 'Buku untuk tugas kuliah',
      ),
      Expense(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Nonton Film',
        amount: 50000,
        date: DateTime(now.year, now.month, now.day - 1, 19, 0),
        category: 'Hiburan',
        note: 'Film di bioskop',
      ),
      Expense(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Belanja Bulanan',
        amount: 150000,
        date: DateTime(now.year, now.month, now.day - 2, 10, 0),
        category: 'Belanja',
        note: 'Kebutuhan sehari-hari',
      ),
    ];
  }

  // Mendapatkan daftar anggaran dummy
  Future<List<Budget>> getMockBudgets() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    
    return [
      Budget(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Anggaran Makanan',
        amount: 1000000,
        type: BudgetType.monthly,
        category: 'Makanan',
        startDate: firstDayOfMonth,
        endDate: lastDayOfMonth,
      ),
      Budget(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Transportasi Harian',
        amount: 30000,
        type: BudgetType.daily,
        category: 'Transportasi',
        startDate: now,
      ),
      Budget(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Hiburan Mingguan',
        amount: 150000,
        type: BudgetType.weekly,
        category: 'Hiburan',
        startDate: DateTime(now.year, now.month, now.day - now.weekday + 1),
        endDate: DateTime(now.year, now.month, now.day - now.weekday + 7),
      ),
    ];
  }

  // Mendapatkan daftar jadwal dummy
  Future<List<Schedule>> getMockSchedules() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 500));
    
    final now = DateTime.now();
    
    return [
      Schedule(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Kuliah Pemrograman Mobile',
        description: 'Kelas di Gedung A Ruang 303',
        startTime: DateTime(now.year, now.month, now.day, 8, 0),
        endTime: DateTime(now.year, now.month, now.day, 10, 30),
        location: 'Gedung A Ruang 303',
      ),
      Schedule(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Rapat Kelompok Tugas',
        description: 'Diskusi proyek akhir semester',
        startTime: DateTime(now.year, now.month, now.day, 13, 0),
        endTime: DateTime(now.year, now.month, now.day, 15, 0),
        location: 'Perpustakaan Lantai 2',
      ),
      Schedule(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Seminar Teknologi',
        description: 'Seminar tentang perkembangan AI terbaru',
        startTime: DateTime(now.year, now.month, now.day + 1, 9, 0),
        endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
        location: 'Aula Utama',
        isAllDay: false,
      ),
      Schedule(
        id: uuid.v4(),
        userId: 'mock-user', // Tambahkan ini
        title: 'Liburan Akhir Semester',
        description: 'Perjalanan ke pantai bersama teman-teman',
        startTime: DateTime(now.year, now.month, now.day + 10),
        endTime: DateTime(now.year, now.month, now.day + 12),
        location: 'Pantai Kuta',
        isAllDay: true,
        relatedBudgetId: '123456', // ID anggaran terkait (dummy)
      ),
    ];
  }
}
