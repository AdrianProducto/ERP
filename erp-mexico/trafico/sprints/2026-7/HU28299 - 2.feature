Feature: Agregar campo Capacidad (unidades) en el catálogo de Unidades
    Yo como usuario de Tráfico,
    Quiero que exista un nuevo campo llamado Capacidad (unidades) en el catálogo de Unidades,
    Para poder registrar la capacidad de carga de cada unidad en número de unidades.

  Scenario: Observar el nuevo campo Capacidad (unidades) al registrar una nueva unidad
    Given que el usuario se encuentra en el catálogo de Unidades del módulo de Tráfico
      And el usuario quiere registrar o modificar una unidad  
     When el usuario se encuentre en la pestaña de "Especificaciones" al registrar o modificar una nueva unidad
     Then aparecerá un nuevo campo llamado "Capacidad (unidades)" en la sección de "Dimensiones"
      And el campo "Capacidad (unidades)" se encontrará vacío por default
      And el campo permitirá ingresar solo valores numéricos enteros positivos
      And no se considerará como un campo obligatorio para guardar la unidad
