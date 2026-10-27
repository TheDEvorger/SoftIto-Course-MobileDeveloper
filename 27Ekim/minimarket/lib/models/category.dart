enum Category {
  hepsi('Tümü', 'H'),
  elektronik('Elektronik', 'E'),
  moda('Moda', 'M'),
  giyim('Giyim', 'G'),
  ayakkabi('Ayakkabı', 'A'),
  bebek('Bebek', 'B');

  final String label;
  final String icon;

  const Category(this.label, this.icon);
}