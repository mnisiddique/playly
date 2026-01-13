extension IndexedMap<E> on List<E> {
   List<T> mapIndexed<T>(T Function(int index, E element) toElement) {
     final List<T> result = [];
     for (var i = 0; i < length; i++) {
       result.add(toElement(i, this[i]));
     }
     return result;
   }
}