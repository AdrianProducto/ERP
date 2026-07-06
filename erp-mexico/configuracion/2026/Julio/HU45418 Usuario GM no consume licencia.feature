@Jaqueline @HU45418 @LicenciaUsuarios
Feature: El usuario GM no consume una licencia activa del sistema

    Yo como administrador del sistema ERP GM Transport
    requiero que el usuario "GM" no consuma una licencia del contrato
    Para que el acceso de soporte no bloquee los accesos de usuarios operativos cuando se haya alcanzado el límite

    Background: Given que la empresa "GRUPO GM TRANSPORT S.A. DE C.V." tiene contratadas 5 licencias de usuario

    Scenario: El usuario GM puede iniciar sesión aunque se haya alcanzado el límite de licencias
        Given que hay 5 sesiones activas de usuarios operativos (límite alcanzado)
        When el usuario "GM" inicia sesión con la contraseña maestra
        Then el sistema permite el acceso sin mostrar el mensaje "Se ha alcanzado el límite de licencias contratadas"
        And al consultar el listado de sesiones activas el sistema sigue reportando 5 sesiones operativas

    Scenario: El usuario GM no se contabiliza en el cálculo de licencias en uso
        Given que el usuario "GM" tiene una sesión activa
        And hay 4 usuarios operativos con sesión activa
        When un quinto usuario con tipo "Usuario" intenta iniciar sesión
        Then el sistema permite el acceso al quinto usuario operativo
        And al consultar el listado de sesiones activas el sistema reporta 5 sesiones operativas

    Scenario: Al cerrar sesión el usuario GM no afecta el conteo operativo
        Given que el usuario "GM" tiene una sesión activa
        And hay 4 usuarios operativos con sesión activa
        When el usuario "GM" cierra sesión
        Then al consultar el listado de sesiones activas el sistema sigue reportando 4 sesiones operativas

    Scenario: Un usuario operativo normal sí consume licencia y respeta el límite
        Given que hay 5 sesiones activas de usuarios operativos (límite alcanzado)
        When un sexto usuario con tipo "Usuario" intenta iniciar sesión
        Then el sistema muestra el mensaje "Se ha alcanzado el límite de licencias contratadas"
        And el sistema no permite el acceso al sexto usuario operativo
