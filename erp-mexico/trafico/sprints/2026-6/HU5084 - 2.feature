Feature: Adecuación al proceso de Importar Autopistas para permitir más registros de la misma caseta
    Yo como usuario de Tráfico,
    Quiero poder cargar más de un gasto de autopista de la misma caseta en el mismo día al proceso de Importar Autopistas,
    Para permitir que se puedan registrar más de un gasto de autopista de la misma caseta en el mismo día.
  
  Background:
    Given que existe un nuevo parámetro llamado "Permitir cargar más registros de una misma caseta en Importar Autopistas"
      And el usuario asigna casetas a los trayectos de la ruta en la pestaña "Detalles de Autopista" dentro del catálogo de Rutas

  Scenario: Cargar archivo en el proceso de Importar Autopistas con el nuevo parámetro activo
    Given que el usuario está en el proceso de Importar Autopistas
      And el usuario tiene un archivo con gastos de autopista que contiene más de un registro de la misma caseta en el mismo día
      And los registros tienen horarios distintos
      And el usuario tiene el nuevo parámetro "Permitir cargar más registros de una misma caseta en Importar Autopistas" activo
     When el usuario cargue el archivo en el proceso de Importar Autopistas
      And el sistema valide que los registros cumplan dentro del intervalo de tiempo de un trayecto ya recorrido con sus registros de Salidas y Llegadas
      And el sistema valide que las casetas de los registros coincidan con las casetas asignadas a los trayectos de la ruta del viaje
     Then el sistema permitirá que se registren los gastos de autopista con la misma caseta dentro del mismo trayecto, validando que el horario sea distinto para no ser considerado como un registro duplicado
      And el sistema mostrará un mensaje de éxito indicando que el archivo se cargó correctamente y los gastos de autopista fueron registrados sin problemas

  Scenario: Cargar archivo en el proceso de Importar Autopistas con el nuevo parámetro activo pero con registros duplicados
    Given que el usuario está en el proceso de Importar Autopistas
      And el usuario tiene un archivo con gastos de autopista que contiene más de un registro de la misma caseta en el mismo día
      And los registros tienen horarios idénticos
      And el usuario tiene el nuevo parámetro "Permitir cargar más registros de una misma caseta en Importar Autopistas" activo
     When el usuario cargue el archivo en el proceso de Importar Autopistas
     Then el sistema no permitirá que se registren los gastos de autopista con la misma caseta dentro del mismo trayecto, ya que los horarios son idénticos y serían considerados como registros duplicados
      And el sistema mostrará un mensaje de error diciendo lo siguiente
        '''
        La fila [número de fila] generó el siguiente error: REGISTRO DUPLICADO
        '''

