-- create
CREATE TABLE rol (
  Id_rol INTEGER  PRIMARY KEY,
  Nombre_rol VARCHAR(50) NOT NULL,
  Descripcion TEXT
  );
CREATE TABLE USUARIO (
    id_usuario INTEGER PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    documento VARCHAR(30) UNIQUE NOT NULL,
    correo VARCHAR(150) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    contrasena TEXT NOT NULL,
    id_rol INTEGER,
    torre VARCHAR(20),
    apartamento VARCHAR(20),
    estado VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_rol) REFERENCES ROL(id_rol)
);
CREATE TABLE SOLICITUD (
    id_solicitud INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    tipo_solicitud VARCHAR(100) NOT NULL,
    descripcion TEXT NOT NULL,
    fecha_registro TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(30) NOT NULL,
    prioridad VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);
CREATE TABLE COMUNICADO (
    id_comunicado INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(50),
    estado VARCHAR(30) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);
CREATE TABLE ZONA_COMUN (
    id_zona INTEGER PRIMARY KEY,
    nombre_zona VARCHAR(100) NOT NULL,
    descripcion TEXT,
    capacidad INTEGER,
    horario_disponible TEXT,
    estado VARCHAR(30) NOT NULL
);
CREATE TABLE RESERVA (
    id_reserva INTEGER PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_zona INTEGER NOT NULL,
    fecha_reserva DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fin TIME NOT NULL,
    estado VARCHAR(30) NOT NULL,
    observacion TEXT,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    FOREIGN KEY (id_zona) REFERENCES ZONA_COMUN(id_zona),
    CHECK (hora_fin > hora_inicio)
);
CREATE TABLE HISTORIAL_SOLICITUD (
    id_historial INTEGER PRIMARY KEY,
    id_solicitud INTEGER NOT NULL,
    estado_anterior VARCHAR(30),
    estado_nuevo VARCHAR(30) NOT NULL,
    fecha_cambio TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    observacion TEXT,
    id_usuario INTEGER NOT NULL,
    FOREIGN KEY (id_solicitud) REFERENCES SOLICITUD(id_solicitud),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);
CREATE TABLE PREGUNTA_FRECUENTE (
    id_pregunta INTEGER PRIMARY KEY,
    pregunta TEXT NOT NULL,
    respuesta TEXT NOT NULL,
    categoria VARCHAR(100),
    estado VARCHAR(30) NOT NULL,
    id_usuario INTEGER,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

-- insert
INSERT INTO ROL VALUES
(1, 'Administrador', 'Gestion general del conjunto'),
(2, 'Residente', 'Habitante del conjunto residencial'),
(3, 'Vigilante', 'Apoyo en seguridad y control de acceso');

INSERT INTO USUARIO VALUES
(1, 'Maria', 'Vega', '10001', 'mafe.vega1225@gmail.com',
 '3136512383', 'hash_prueba_1', 1, 'Torre 8', '10403', 'Activo'),
(2, 'Carlos', 'Perez', '10002', 'carlosp20@gmail.com',
 '3005506848', 'hash_prueba_2', 2, 'Torre 2', '202', 'Activo'),
(3, 'Laura', 'Gomez', '10003', 'lauragomez89@gmail.com',
 '3115830963', 'hash_prueba_3', 2, 'Torre 1', '103', 'Activo');

 INSERT INTO SOLICITUD
(id_solicitud, id_usuario, tipo_solicitud, descripcion,
 fecha_registro, estado, prioridad)
VALUES
(1, 2, 'Mantenimiento', 'Reparar una lampara de la zona comun',
 '2026-10-10 09:00:00', 'Pendiente', 'Alta'),
(2, 3, 'Convivencia', 'Reporte de ruido excesivo',
 '2026-10-11 15:30:00', 'En proceso', 'Media'),
(3, 2, 'Administrativa', 'Consulta sobre cuota de administracion',
 '2026-10-12 10:00:00', 'Resuelta', 'Baja');

 INSERT INTO COMUNICADO
(id_comunicado, id_usuario, titulo, contenido,
 fecha_publicacion, tipo, estado)
VALUES
(1, 1, 'Mantenimiento del ascensor',
 'El ascensor estara en mantenimiento el viernes.',
 '2026-10-10 08:00:00', 'Mantenimiento', 'Publicado'),
(2, 1, 'Reunion de residentes',
 'La reunion se realizara en el salon comunal.',
 '2026-10-11 12:00:00', 'Reunion', 'Publicado');

 INSERT INTO ZONA_COMUN VALUES
(1, 'Salon comunal', 'Espacio para reuniones y eventos',
 50, 'Lunes a domingo de 08:00 a 22:00', 'Disponible'),
(2, 'Cancha deportiva', 'Zona para actividades deportivas',
 20, 'Lunes a domingo de 06:00 a 20:00', 'Disponible'),
(3, 'Zona BBQ', 'Espacio para reuniones al aire libre',
 15, 'Sabados y domingos de 09:00 a 19:00', 'Disponible');

 INSERT INTO RESERVA VALUES
(1, 2, 1, '2026-10-20', '10:00', '12:00',
 'Confirmada', 'Reunion familiar'),
(2, 3, 2, '2026-10-21', '16:00', '17:00',
 'Pendiente', 'Actividad deportiva');

 INSERT INTO HISTORIAL_SOLICITUD
(id_historial, id_solicitud, estado_anterior, estado_nuevo,
 fecha_cambio, observacion, id_usuario)
VALUES
(1, 1, NULL, 'Pendiente',
 '2026-10-10 09:00:00', 'Solicitud creada', 2),
(2, 2, 'Pendiente', 'En proceso',
 '2026-10-12 08:00:00', 'Se asigno para revision', 1),
(3, 3, 'Pendiente', 'Resuelta',
 '2026-10-13 14:00:00', 'Consulta respondida', 1);

 INSERT INTO PREGUNTA_FRECUENTE VALUES
(1, 'Como reservar el salon comunal?',
 'Debe ingresar al sistema y seleccionar la fecha disponible.',
 'Reservas', 'Activa', 1),
(2, 'Como reportar un dano?',
 'Debe registrar una solicitud de mantenimiento.',
 'Solicitudes', 'Activa', 1),
(3, 'Donde consultar los comunicados?',
 'En el modulo de comunicados del sistema.',
 'Informacion', 'Activa', 1);

-- fetch 
SELECT * FROM ROL;

SELECT * FROM USUARIO;

SELECT * FROM SOLICITUD;

SELECT * FROM COMUNICADO;

SELECT * FROM ZONA_COMUN;

SELECT * FROM RESERVA;

SELECT * FROM HISTORIAL_SOLICITUD;

SELECT * FROM PREGUNTA_FRECUENTE;

