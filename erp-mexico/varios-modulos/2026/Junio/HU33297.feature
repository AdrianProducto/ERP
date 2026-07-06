Feature: Agregar leyenda en la pestaña de Pagos del ERP cuando se pague en un fin de semana
    Yo como usuario del ERP,
    Quiero que se muestre una leyenda en la pestaña de Pagos cuando se registre un pago en un fin de semana,
    Para tener claridad sobre la fecha en la que se realizó el pago.

  Background:
    Given que existe un portal de pagos que se accede desde el ERP donde muestra el saldo pendiente por pagar

  Scenario: El usuario entra al portal para consultar su saldo pendiente y las facturas
    Given que el usuario está en el portal de pagos
     When quiera consultar el saldo pendiente por pagar
     Then se muestra una leyenda en la parte inferior del portal que diga lo siguiente:
        '''
            "Se le activarán 3 días más a su sistema si hace el pago en un fin de semana y sube su comprobante."
        '''
