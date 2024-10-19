import 'dart:io';

void main() {
  // Nullable variabel
  String? nama;
  int? umur;
  int tinggi;

  // Inisialisasi variabel
  tinggi = 175;

  print("Input nama anda: ");
  nama = stdin.readLineSync();
  print("Input umur anda: ");
  var strUmur = stdin.readLineSync();
  umur = strUmur == null ? null : int.parse(strUmur);

  print("Nama saya adalah ${nama ?? "Tidak diketahui"}");
  print("Umur saya adalah ${umur ?? "Tidak diketahui"} tahun");
  print("Tinggi badan saya adalah $tinggi cm");
}
