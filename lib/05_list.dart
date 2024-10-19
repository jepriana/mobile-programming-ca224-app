void main() {
  // Deklarasi list kosong
  var list1 = [];
  print(list1);

  // Deklarasi list dengan nilai awal
  list1 = [1, 2, 3, 4, 5];
  print(list1);
  // Cetak elemen pertama
  print(list1.first);
  // Tambahkan element 7 dalam list
  list1.add(7);
  // Cetak element terakhir
  print(list1.last);
  // Hapus element dalam list
  list1.remove(3);
  // Cetak jumlah element
  print(list1.length);
  print(list1);
  print(list1[4]);
}
