class Validators {
  // Validasi untuk field yang wajib diisi
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    return null;
  }

  // Validasi untuk field jumlah uang
    static String? amount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field ini wajib diisi';
    }
    
    if (double.tryParse(value) == null) {
      return 'Masukkan jumlah yang valid';
    }
    
    if (double.parse(value) <= 0) {
      return 'Jumlah harus lebih dari 0';
    }
    
    return null;
  }
  
  // Validasi untuk email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Masukkan email yang valid';
    }
    
    return null;
  }
  
  // Validasi untuk tanggal
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal wajib diisi';
    }
    
    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid';
    }
  }
}
