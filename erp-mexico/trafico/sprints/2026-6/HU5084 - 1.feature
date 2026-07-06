Feature: Nuevo parámetro para permitir más de un registro de gasto de autopista de la misma caseta en Importar Autopistas
    Yo como usuario de Tráfico,
    Quiero que se agregue un nuevo parámetro en el proceso de Importar Autopistas,
    Para permitir que se puedan registrar más de un gasto de autopista de la misma caseta en el mismo día.

  Background: 
    Given que existe un proceso en el módulo de Tráfico llamado "Importar Autopistas"
      And el proceso consiste de cargar datos de gastos hechos a casetas dentro de un trayecto recorrido en los viajes documentados en el sistema
  
  Scenario: Encontrar el nuevo parámetro en el módulo de Tráfico
    Given que el usuario está en el sistema
      And el usuario se encuentra en el catálogo de parámetros del módulo de Tráfico
     When el usuario encuentre el nuevo parámetro llamado "Permitir cargar más registros de una misma caseta en Importar Autopistas"
      And el usuario quiera consultar la descripción del nuevo parámetro
     Then el usuario verá el nuevo parámetro inactivo por default
      And el usuario verá que el parámetro se ubica en la pestaña "General" del catálogo de parámetros
      And la descripción del nuevo parámetro dirá lo siguiente
        '''
        Al activar el parámetro, permitirá el registro de gastos de autopistas con la misma caseta dentro del mismo trayecto, validando que el horario sea distinto para no ser considerado como un registro duplicado.
        '''

