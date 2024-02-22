class EntidadContable {
  String id;
  String descripcion;
  int cantidad;


  EntidadContable({
  required this.id, 
  required this.descripcion, 
  required this.cantidad});

  //! factory contructor es un contructor que retorna una nueva instancia de la clase
  //? es propio de dart
  factory EntidadContable.fromJson(Map<String, dynamic> obj) {
    return EntidadContable(
      id: obj['id'],
      descripcion: obj['descripcion'],
      cantidad: obj['cantidad'],
    );
  }
}
