Feature: Corrección a proceso almacenado de concurrencia al modificar factura 
    Yo como usuario de Facturación,
    Quiero poder modificar una factura sin que el sistema me arroje un error de concurrencia,
    Para una mejor usabilidad del sistema y poder modificar mis facturas sin problemas.
  
  Background: 
    Given el sistema almacena la fecha y hora en la base de datos al momento de modificar registros
      And los datos que se toman para la captura de la fecha y hora de la acción son "ModificadoEl" y "UltimaModificacion"
      And el dato "ModificadoEl" almacena hasta los milisegundos mientras que "UltimaModificacion" sólo almacena hasta los segundos
  
  Scenario: Dos o más usuarios intentan modificar una factura
    Given que el usuario tiene un registro de factura
     When el usuario entra a modificar la factura
      And hay otro usuario que intenta modificar la misma factura al mismo tiempo
      And intenta guardar la factura al mismo tiempo
     Then el sistema guardará el registro de tiempo en ambas variables "ModificadoEl" y "UltimaModificacion" en base a la fecha y hora hasta los milisegundos
      And el registro de tiempos en ambas variables "ModificadoEl" y "UltimaModificacion" se compararán en base a la fecha y hora hasta los milisegundos
      And el sistema validará que aunque las fechas y horas de ambos registros sean iguales hasta los segundos, al comparar los milisegundos se permitirá guardar la factura sin arrojar un error de concurrencia

