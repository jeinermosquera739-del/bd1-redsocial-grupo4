-- =====================================================
-- PROYECTO: RED SOCIAL ESTUDIANTIL PASCUALINA
-- SISTEMA GESTOR: MYSQL
-- ENTREGABLE: SCRIPT DDL
-- DESCRIPCION: CREACION DE TABLAS, RELACIONES E INDICES
-- =====================================================

DROP DATABASE IF EXISTS Pascualina;

CREATE DATABASE Pascualina;

USE Pascualina;

CREATE TABLE estudiante (
    id_estudiante INT AUTO_INCREMENT,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    documento VARCHAR(20) NOT NULL,
    correo VARCHAR(120) NOT NULL,
    carrera VARCHAR(100) NOT NULL,

    CONSTRAINT PK_ESTUDIANTE
        PRIMARY KEY (id_estudiante),

    CONSTRAINT UK_ESTUDIANTE_DOCUMENTO
        UNIQUE (documento),

    CONSTRAINT UK_ESTUDIANTE_CORREO
        UNIQUE (correo)
);


CREATE TABLE perfil (
    id_perfil INT AUTO_INCREMENT,
    id_estudiante INT NOT NULL,
    foto VARCHAR(255) NULL,
    descripcion VARCHAR(500) NULL,

    CONSTRAINT PK_PERFIL
        PRIMARY KEY (id_perfil),

    CONSTRAINT UK_PERFIL_ESTUDIANTE
        UNIQUE (id_estudiante),

    CONSTRAINT FK_PERFIL_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE publicacion (
    id_publicacion     INT AUTO_INCREMENT,
    id_estudiante      INTEGER NOT NULL,
    titulo             VARCHAR(150) NOT NULL,
    contenido          TEXT NOT NULL,
    fecha_publicacion  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo_publicacion   VARCHAR(40) NOT NULL,
    datos_adicionales JSON NULL,

    CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),

    CONSTRAINT fk_publicacion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
	CONSTRAINT CK_PUBLICACION_JSON
    CHECK (
        datos_adicionales IS NULL
        OR ISJSON(datos_adicionales) = 1
    )
);

CREATE TABLE comentario (
    id_comentario      INT AUTO_INCREMENT,
    id_publicacion     INTEGER NOT NULL,
    id_estudiante      INTEGER NOT NULL,
    contenido          TEXT NOT NULL,
    fecha_comentario   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion)
        REFERENCES publicacion (id_publicacion)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_comentario_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE reaccion (
    id_reaccion     INT AUTO_INCREMENT,
    id_publicacion  INTEGER NOT NULL,
    id_estudiante   INTEGER NOT NULL,
    tipo_reaccion   VARCHAR(30) NOT NULL,
    CONSTRAINT pk_reaccion PRIMARY KEY (id_reaccion),
    CONSTRAINT fk_reaccion_publicacion FOREIGN KEY (id_publicacion)
        REFERENCES publicacion (id_publicacion)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reaccion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE interes (
    id_interes  INT AUTO_INCREMENT,
    nombre      VARCHAR(80) NOT NULL,
    tipo        VARCHAR(40) NOT NULL,
    CONSTRAINT pk_interes PRIMARY KEY (id_interes),
    CONSTRAINT uq_interes_nombre UNIQUE (nombre)
);

CREATE TABLE estudiante_interes (
    id_estudiante INTEGER NOT NULL,
    id_interes    INTEGER NOT NULL,
    CONSTRAINT pk_estudiante_interes PRIMARY KEY (id_estudiante, id_interes),
    CONSTRAINT fk_estudiante_interes_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estudiante_interes_interes FOREIGN KEY (id_interes)
        REFERENCES interes (id_interes)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE grupo (
    id_grupo     INT AUTO_INCREMENT,
    nombre       VARCHAR(100) NOT NULL,
    descripcion  VARCHAR(500),
    CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
    CONSTRAINT uq_grupo_nombre UNIQUE (nombre)
);

CREATE TABLE membresia (
    id_estudiante INTEGER NOT NULL,
    id_grupo      INTEGER NOT NULL,
    fecha_ingreso DATE NOT NULL DEFAULT (CURRENT_DATE),
    rol_grupo     VARCHAR(30) NOT NULL DEFAULT 'miembro',
    CONSTRAINT pk_membresia PRIMARY KEY (id_estudiante, id_grupo),
    CONSTRAINT fk_membresia_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_membresia_grupo FOREIGN KEY (id_grupo)
        REFERENCES grupo (id_grupo)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE seguimiento (
    id_seguidor       INTEGER NOT NULL,
    id_seguido        INTEGER NOT NULL,
    fecha_seguimiento DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT pk_seguimiento PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_seguimiento_seguidor FOREIGN KEY (id_seguidor)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_seguimiento_seguido FOREIGN KEY (id_seguido)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE evento (
    id_evento      INT AUTO_INCREMENT,
    id_creador     INTEGER NOT NULL,
    nombre         VARCHAR(120) NOT NULL,
    descripcion    VARCHAR(500),
    fecha          DATE NOT NULL,
    hora           TIME NOT NULL,
    lugar          VARCHAR(150) NOT NULL,
    tipo_evento    VARCHAR(50) NOT NULL,
    estado_evento  VARCHAR(30) NOT NULL DEFAULT 'programado',
    CONSTRAINT pk_evento PRIMARY KEY (id_evento),
    CONSTRAINT fk_evento_creador FOREIGN KEY (id_creador)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE inscripcion_evento (
    id_estudiante      INTEGER NOT NULL,
    id_evento          INTEGER NOT NULL,
    fecha_inscripcion DATE NOT NULL DEFAULT (CURRENT_DATE),
    estado_inscripcion VARCHAR(30) NOT NULL DEFAULT 'inscrito',
    CONSTRAINT pk_inscripcion_evento PRIMARY KEY (id_estudiante, id_evento),
    CONSTRAINT fk_inscripcion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_inscripcion_evento FOREIGN KEY (id_evento)
        REFERENCES evento (id_evento)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE chat (
    id_chat        INT AUTO_INCREMENT,
    tipo_chat      VARCHAR(20) NOT NULL,
    nombre_chat    VARCHAR(100),
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_chat PRIMARY KEY (id_chat)
);


CREATE TABLE participacion_chat (
    id_estudiante INTEGER NOT NULL,
    id_chat       INTEGER NOT NULL,
    fecha_ingreso DATE NOT NULL DEFAULT (CURRENT_DATE),
    CONSTRAINT pk_participacion_chat PRIMARY KEY (id_estudiante, id_chat),
    CONSTRAINT fk_participacion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_participacion_chat FOREIGN KEY (id_chat)
        REFERENCES chat (id_chat)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE curso_compartido (
    codigo_curso       VARCHAR(20) NOT NULL,
    nombre_curso       VARCHAR(120) NOT NULL,
    facultad           VARCHAR(100) NOT NULL,
    nivel_complejidad  VARCHAR(30) NOT NULL,
    CONSTRAINT pk_curso_compartido PRIMARY KEY (codigo_curso)
);


CREATE TABLE estudiante_curso (
    id_estudiante INTEGER NOT NULL,
    codigo_curso  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_estudiante_curso PRIMARY KEY (id_estudiante, codigo_curso),
    CONSTRAINT fk_estudiante_curso_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estudiante_curso_curso FOREIGN KEY (codigo_curso)
        REFERENCES curso_compartido (codigo_curso)
        ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE investigacion (
    id_investigacion INT AUTO_INCREMENT,
    nombre           VARCHAR(120) NOT NULL,
    titulo           VARCHAR(200) NOT NULL,
    publico_interes  VARCHAR(200),
    CONSTRAINT pk_investigacion PRIMARY KEY (id_investigacion)
);

CREATE TABLE estudiante_investigacion (
    id_estudiante    INTEGER NOT NULL,
    id_investigacion INTEGER NOT NULL,
    CONSTRAINT pk_estudiante_investigacion PRIMARY KEY (id_estudiante, id_investigacion),
    CONSTRAINT fk_estudiante_investigacion_estudiante FOREIGN KEY (id_estudiante)
        REFERENCES estudiante (id_estudiante)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_estudiante_investigacion_investigacion FOREIGN KEY (id_investigacion)
        REFERENCES investigacion (id_investigacion)
        ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE INDEX ix_publicacion_estudiante ON publicacion (id_estudiante);
CREATE INDEX ix_comentario_publicacion ON comentario (id_publicacion);
CREATE INDEX ix_comentario_estudiante ON comentario (id_estudiante);
CREATE INDEX ix_reaccion_publicacion ON reaccion (id_publicacion);
CREATE INDEX ix_reaccion_estudiante ON reaccion (id_estudiante);
CREATE INDEX ix_evento_creador ON evento (id_creador);
CREATE INDEX ix_inscripcion_evento_evento ON inscripcion_evento (id_evento);

SHOW TABLES;
DESCRIBE estudiante;
