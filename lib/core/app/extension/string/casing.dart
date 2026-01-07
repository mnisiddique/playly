extension Casing on String {
  String toTitleCase() {
    if (isEmpty) return this;

    return 
        toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
