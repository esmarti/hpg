# Hive Pass Guard - HPG
Hive Pass Guard (HPG) es un almacén de contraseñas seguro diseñado para equipos de trabajo colaborativo. Su objetivo es evitar el desorden y las malas prácticas al almacenar credenciales compartidas en un equipo de trabajo.

## Características Principales
- Infraestructura PKI: Utiliza Pretty Good Privacy (PGP) para la seguridad.
- Tecnología: Implementación con GpgME en el backend y OpenGPG.js en el frontend.
- Par de Llaves: Cada usuario obtiene un par de llaves pública-privada único al registrarse.
- Seguridad de llave privada: Algorimo "Curve25519" de 256 bits (32bytes).
	- Curve25519 está optimizada para ser rápida y segura tanto en hardware como en software. Se diseñó para evitar errores de implementación comunes y para tener un alto rendimiento en una variedad de plataformas.
	- Curve25519 se utiliza ampliamente en diversas aplicaciones, incluyendo:
		- Protocolo de intercambio de claves Diffie-Hellman.
		- Algoritmos de firma digital (como Ed25519).
		- Protocolos de cifrado modernos como TLS, Signal, y otros.
- Generación de Claves: Las claves privadas se generan en el navegador del usuario, no en el backend.
- Encriptación de Credenciales: Todas las credenciales almacenadas en la base de datos están encriptadas con la llave privada de cada usuario.
- Proyectos y Equipos: Cada usuario puede pertenecer a uno o varios proyectos y equipos, compartiendo credenciales dentro de estos.
- Acceso a Credenciales: Los miembros del equipo tienen acceso a las mismas credenciales, desencriptadas en su navegador con su llave privada.
- Gestión de Miembros
	- Las credenciales se eliminan para un miembro dado de baja pero siguen disponibles para el resto del equipo.
	- Menu de administración de usuarios (solo role Administrador).
- Gestion de sesiones: Cada usuario tiene una sesión activa en el navegador. Las sesiones se administran con la gema Devise, dando las siguientes funcionalidades:
	- Creacion de cuenta por el usuario.
	- Creación de cuenta por el administrador.
	- Login.
	- Cierre de sesión.
	- Modificación de contraseñas.
	- Recuperación de contraseñas.
	- Bloqueo de cuenta por intentos fallidos.

## Funcionamiento
- Registro de Usuario: Al registrarse, cada usuario obtiene un par de llaves pública-privada.
- Generación de Claves: Las claves privadas se generan en el navegador del usuario.
- Encriptación de Credenciales: Todas las credenciales se encriptan con la llave privada del usuario antes de almacenarse en la base de datos.
- Compartición de Credenciales: Los miembros de un equipo pueden compartir credenciales, que se almacenan de manera segura y encriptada.
- Acceso a Credenciales: Para acceder a una credencial, el usuario debe ingresar su llave privada, y la credencial se desencripta en su navegador.

## Mejora Pendiente
Actualmente, no está implementada la funcionalidad para que cada usuario pueda traer una llave pública de su propiedad en lugar de generar una nueva. Esto se hace para evitar problemas de compatibilidad de las librerías. En el futuro, podría implementarse la opción de elegir el tipo de llaves que se pueden generar.

## Contribución
Contribuciones y sugerencias son bienvenidas. Puedes abrir un issue o enviar un pull request.