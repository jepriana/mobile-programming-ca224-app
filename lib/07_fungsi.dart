void main() {
  var list = ["Agus", "Budi", "Citra", "Dita"];
  // Cetak element list
  list.forEach((item) {
    print("${list.indexOf(item) + 1}. $item");
  });
}
