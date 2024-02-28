class EntidadContable {
  String id;
  String descripcion;
  int cantidad;

  EntidadContable(
      {required this.id, required this.descripcion, required this.cantidad});

  //! factory contructor es un contructor que retorna una nueva instancia de la clase
  //? es propio de dart
  factory EntidadContable.fromJson(Map<String, dynamic> obj) {
    return EntidadContable(
      //validaciones obj.containsKey('id') ? obj['id'] : ''
      id: obj.containsKey('id') ? obj['id'] : 'no-id',
      descripcion: obj.containsKey('descripcion')
          ? obj['descripcion']
          : 'no-descripcion',
      cantidad: obj.containsKey('cantidad') ? obj['cantidad'] : 'no-cantidad',
    );
  }
}
