#HU42023 - Permiso general
Feature: Control de acceso a IA GM mediante Portal IA
  Como usuario tipo admin del ERP
  Quiero poder ingresar a IA GM
  Para utilizar las funcionalidades de inteligencia artificial según mis permisos

  Background:
    Dado que la aplicación IA GM está en funcionamiento
    Y que el Portal IA está disponible para consulta de permisos y roles

  Escenario: Usuario admin del ERP sin registro en Portal IA accede a IA GM
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el usuario no tiene registro en Portal IA
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema verifica en Portal IA que no existe registro del usuario
    Y el sistema permite el acceso a IA GM

  Escenario: Usuario con registro en Portal IA con acceso habilitado a IA GM ingresa correctamente
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el usuario tiene registro en Portal IA con acceso a IA GM habilitado
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema verifica en Portal IA que el usuario tiene acceso habilitado
    Y el sistema valida el rol asignado en Portal IA
    Y el sistema permite el acceso a IA GM

  Escenario: Usuario con registro en Portal IA sin acceso a IA GM es denegado
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el usuario tiene registro en Portal IA con acceso a IA GM deshabilitado
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema verifica en Portal IA que el usuario no tiene acceso habilitado
    Y el sistema deniega el acceso a IA GM
    Y el sistema muestra el mensaje de "Sin permisos para acceder a IA GM"

  Esquema del escenario: Acceso a IA GM según rol asignado en Portal IA
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el usuario tiene registro en Portal IA con acceso a IA GM habilitado
    Y que el usuario tiene el rol "<rol_portal>" en Portal IA
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema "<resultado>" el acceso a IA GM

    Ejemplos:
      | rol_portal     | resultado |
      | General        | permite   |
      | Operativo      | permite   |
      | Administrativo | permite   |

  Escenario: Usuario sin rol admin en ERP pero con acceso habilitado en Portal IA ingresa a IA GM
    Dado que el usuario tiene un rol diferente a "admin" en el ERP
    Y que el usuario tiene registro en Portal IA con acceso a IA GM habilitado
    Y que el usuario tiene el rol "<rol_portal>" en Portal IA
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema verifica en Portal IA que el usuario tiene acceso habilitado
    Y el sistema valida el rol asignado en Portal IA
    Y el sistema permite el acceso a IA GM

  Escenario: Usuario sin rol admin en ERP y sin registro en Portal IA no puede acceder a IA GM
    Dado que el usuario tiene un rol diferente a "admin" en el ERP
    Y que el usuario no tiene registro en Portal IA
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema deniega el acceso a IA GM
    Y el sistema muestra el mensaje de "Sin permisos para acceder a IA GM"

  Escenario: Portal IA no responde al momento de validar acceso
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el Portal IA no está disponible al momento de la consulta
    Cuando el usuario intenta ingresar a IA GM
    Entonces el sistema muestra un mensaje de error de validación
    Y el sistema deniega el acceso a IA GM por precaución

  Escenario: Usuario con acceso habilitado en Portal IA ve funcionalidades según su rol
    Dado que el usuario tiene rol "admin" en el ERP
    Y que el usuario tiene registro en Portal IA con acceso a IA GM habilitado
    Y que el usuario tiene el rol "Operativo" en Portal IA
    Cuando el usuario ingresa a IA GM
    Entonces el sistema carga la interfaz de IA GM con las funcionalidades correspondientes al rol "Operativo"
