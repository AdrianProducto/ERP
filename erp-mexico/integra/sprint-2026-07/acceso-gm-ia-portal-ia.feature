# language: es

Feature: Control de acceso a GM IA según registro en Portal IA
  Como usuario administrador del ERP
  Quiero poder iniciar sesión en la aplicación GM IA
  Para que el acceso esté controlado según mi registro y rol en el Portal IA

  Background:
    Dado que la aplicación GM IA está en funcionamiento
    Y el endpoint de autenticación POST /api/auth/login está disponible
    Y el servicio de ServiciosGM está disponible

  # ─── HAPPY PATH ────────────────────────────────────────────────────────────

  Escenario: Admin ERP sin registro en Portal IA accede exitosamente a GM IA
    Dado que el usuario "juanAdmin" es de tipo administrador en el ERP
    Y el usuario "juanAdmin" no tiene registro en la colección "clientes" del Portal IA
    Cuando envía una petición de login con usuario "juanAdmin", contraseña válida y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 200
    Y la respuesta contiene "accessToken" y "refreshToken"
    Y el usuario puede operar dentro de GM IA

  Escenario: Admin ERP con registro en Portal IA y rol ADMINISTRADOR accede a GM IA
    Dado que el usuario "mariaAdmin" es de tipo administrador en el ERP
    Y el usuario "mariaAdmin" tiene registro en el Portal IA con RFC "IIA040805DZ4"
    Y su campo "esAdministrador" en Portal IA es verdadero
    Cuando envía una petición de login con usuario "mariaAdmin", contraseña válida y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 200
    Y la respuesta contiene "accessToken" y "refreshToken"
    Y el usuario puede operar dentro de GM IA

  Escenario: Admin ERP con registro en Portal IA y rol SOPORTE accede a GM IA
    Dado que el usuario "carlosAdmin" es de tipo administrador en el ERP
    Y el usuario "carlosAdmin" tiene registro en el Portal IA con RFC "IIA040805DZ4"
    Y su campo "esAdministrador" en Portal IA es verdadero
    Cuando envía una petición de login con usuario "carlosAdmin", contraseña válida y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 200
    Y la respuesta contiene "accessToken" y "refreshToken"

  # ─── FLUJO NORMAL (USUARIO ERP NO ADMIN) ──────────────────────────────────

  Escenario: Usuario ERP no administrador accede con permisos de CLIENTE sin verificación Portal IA
    Dado que el usuario "operadorERP" NO es de tipo administrador en el ERP
    Y el usuario "operadorERP" tiene o no registro en Portal IA
    Cuando envía una petición de login con usuario "operadorERP", contraseña válida y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 200
    Y la respuesta contiene "accessToken" y "refreshToken"
    Y el sistema NO realiza la verificación de registro en Portal IA

  # ─── ACCESO DENEGADO ───────────────────────────────────────────────────────

  Escenario: Admin ERP con registro en Portal IA y rol CLIENTE es rechazado en GM IA
    Dado que el usuario "pedroAdmin" es de tipo administrador en el ERP
    Y el usuario "pedroAdmin" tiene registro en el Portal IA con RFC "IIA040805DZ4"
    Y su campo "esAdministrador" en Portal IA es falso
    Cuando envía una petición de login con usuario "pedroAdmin", contraseña válida y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 403
    Y el cuerpo de la respuesta contiene el código de error "PORTAL_IA_ACCESS_DENIED"
    Y el mensaje de error indica "Tu acceso a GM IA ha sido restringido desde el Portal IA. Contacta al administrador."
    Y el usuario no recibe tokens de acceso

  Escenario: Login con credenciales incorrectas es rechazado
    Dado que el usuario "adminERP" es de tipo administrador en el ERP
    Cuando envía una petición de login con usuario "adminERP", contraseña incorrecta y RFC "IIA040805DZ4"
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 401
    Y el usuario no recibe tokens de acceso

  Escenario: Login sin header RFC es rechazado
    Dado que el usuario "adminERP" intenta iniciar sesión en GM IA
    Cuando envía una petición de login con usuario "adminERP" y contraseña válida
    Y el header "RFC" no está presente en la petición
    Y el header "X-Login-Method" tiene el valor "ERP"
    Entonces el sistema responde con código HTTP 401
    Y el mensaje de error indica que el método ERP requiere el header RFC

  # ─── ESQUEMA DEL ESCENARIO ────────────────────────────────────────────────

  Esquema del escenario: Acceso a GM IA según tipo de usuario ERP y registro en Portal IA
    Dado que el usuario "<usuario>" tiene esAdministradorERP "<esAdminERP>" en ServiciosGM
    Y el usuario "<usuario>" tiene registro en Portal IA con esAdministradorPortal "<esAdminPortal>" y registrado "<tieneRegistro>"
    Cuando envía una petición de login con RFC "IIA040805DZ4" y método "ERP"
    Entonces el sistema responde con código HTTP "<codigoHttp>"
    Y el resultado de acceso es "<resultado>"

    Ejemplos:
      | usuario      | esAdminERP | tieneRegistro | esAdminPortal | codigoHttp | resultado                        |
      | adminSinReg  | true       | false         | N/A           | 200        | acceso permitido                 |
      | adminConPerm | true       | true          | true          | 200        | acceso permitido                 |
      | adminSinPerm | true       | true          | false         | 403        | acceso denegado por Portal IA    |
      | noAdmin      | false      | true          | false         | 200        | acceso permitido como CLIENTE    |
      | noAdminSinReg| false      | false         | N/A           | 200        | acceso permitido como CLIENTE    |
