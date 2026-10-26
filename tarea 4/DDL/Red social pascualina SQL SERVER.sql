-- =====================================================
-- PROYECTO: RED SOCIAL ESTUDIANTIL PASCUALINA
-- SISTEMA GESTOR: SQL SERVER
-- ENTREGABLE: SCRIPT DDL CON REINICIO Y RELACIONES CORREGIDAS
-- =====================================================

-- Forzar la desconexión de otros procesos y borrar la BD existente para limpiarla
USE master;
GO
IF DB_ID('Pascualina') IS NOT NULL
BEGIN
    ALTER DATABASE Pascualina SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Pascualina;
END;
GO

-- Crear la base de datos limpia desde cero
CREATE DATABASE Pascualina;
GO

USE Pascualina;
GO

CREATE TABLE estudiante (
    id_estudiante INT IDENTITY(1,1) NOT NULL,
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
GO


CREATE TABLE perfil (
    id_perfil INT IDENTITY(1,1) NOT NULL,
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
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE publicacion (
    id_publicacion INT IDENTITY(1,1) NOT NULL,
    id_estudiante INT NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    contenido VARCHAR(MAX) NOT NULL,
    fecha_publicacion DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    tipo_publicacion VARCHAR(40) NOT NULL,
    datos_adicionales NVARCHAR(MAX) NULL,

    CONSTRAINT PK_PUBLICACION
        PRIMARY KEY (id_publicacion),

    CONSTRAINT FK_PUBLICACION_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE comentario (
    id_comentario INT IDENTITY(1,1) NOT NULL,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    contenido VARCHAR(MAX) NOT NULL,
    fecha_comentario DATETIME2 NOT NULL DEFAULT SYSDATETIME(),

    CONSTRAINT PK_COMENTARIO
        PRIMARY KEY (id_comentario),

    CONSTRAINT FK_COMENTARIO_PUBLICACION
        FOREIGN KEY (id_publicacion)
        REFERENCES publicacion(id_publicacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_COMENTARIO_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION
);
GO

CREATE TABLE reaccion (
    id_reaccion INT IDENTITY(1,1) NOT NULL,
    id_publicacion INT NOT NULL,
    id_estudiante INT NOT NULL,
    tipo_reaccion VARCHAR(30) NOT NULL,

    CONSTRAINT PK_REACCION
        PRIMARY KEY (id_reaccion),

    CONSTRAINT FK_REACCION_PUBLICACION
        FOREIGN KEY (id_publicacion)
        REFERENCES publicacion(id_publicacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_REACCION_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION,
    
);
GO


CREATE TABLE interes (
    id_interes INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    tipo VARCHAR(40) NOT NULL,

    CONSTRAINT PK_INTERES
        PRIMARY KEY (id_interes),

    CONSTRAINT UQ_INTERES_NOMBRE
        UNIQUE (nombre)
);
GO

CREATE TABLE estudiante_interes (
    id_estudiante INT NOT NULL,
    id_interes INT NOT NULL,

    CONSTRAINT PK_ESTUDIANTE_INTERES
        PRIMARY KEY (id_estudiante, id_interes),

    CONSTRAINT FK_ESTUDIANTE_INTERES_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_ESTUDIANTE_INTERES_INTERES
        FOREIGN KEY (id_interes)
        REFERENCES interes(id_interes)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE grupo (
    id_grupo INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(500) NULL,

    CONSTRAINT PK_GRUPO
        PRIMARY KEY (id_grupo),

    CONSTRAINT UQ_GRUPO_NOMBRE
        UNIQUE (nombre)
);
GO

CREATE TABLE membresia (
    id_estudiante INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_ingreso DATE NOT NULL
        DEFAULT CAST(GETDATE() AS DATE),
    rol_grupo VARCHAR(30) NOT NULL
        DEFAULT 'miembro',

    CONSTRAINT PK_MEMBRESIA
        PRIMARY KEY (id_estudiante, id_grupo),

    CONSTRAINT FK_MEMBRESIA_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_MEMBRESIA_GRUPO
        FOREIGN KEY (id_grupo)
        REFERENCES grupo(id_grupo)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE seguimiento (
    id_seguidor INT NOT NULL,
    id_seguido INT NOT NULL,
    fecha_seguimiento DATE NOT NULL
        DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT PK_SEGUIMIENTO
        PRIMARY KEY (id_seguidor, id_seguido),

    CONSTRAINT CK_SEGUIMIENTO_NO_AUTOSEGUIMIENTO
        CHECK (id_seguidor <> id_seguido),

    CONSTRAINT FK_SEGUIMIENTO_SEGUIDOR
        FOREIGN KEY (id_seguidor)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_SEGUIMIENTO_SEGUIDO
        FOREIGN KEY (id_seguido)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION
);
GO

CREATE TABLE evento (
    id_evento INT IDENTITY(1,1) NOT NULL,
    id_creador INT NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500) NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,
    estado_evento VARCHAR(30) NOT NULL
        DEFAULT 'programado',

    CONSTRAINT PK_EVENTO
        PRIMARY KEY (id_evento),

    CONSTRAINT FK_EVENTO_CREADOR
        FOREIGN KEY (id_creador)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE inscripcion_evento (
    id_estudiante INT NOT NULL,
    id_evento INT NOT NULL,
    fecha_inscripcion DATE NOT NULL
        DEFAULT CAST(GETDATE() AS DATE),
    estado_inscripcion VARCHAR(30) NOT NULL
        DEFAULT 'inscrito',

    CONSTRAINT PK_INSCRIPCION_EVENTO
        PRIMARY KEY (id_estudiante, id_evento),

    CONSTRAINT FK_INSCRIPCION_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_INSCRIPCION_EVENTO
        FOREIGN KEY (id_evento)
        REFERENCES evento(id_evento)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION
);
GO

CREATE TABLE chat (
    id_chat INT IDENTITY(1,1) NOT NULL,
    tipo_chat VARCHAR(20) NOT NULL,
    nombre_chat VARCHAR(100) NULL,
    fecha_creacion DATETIME2 NOT NULL
        DEFAULT SYSDATETIME(),

    CONSTRAINT PK_CHAT
        PRIMARY KEY (id_chat)
);
GO

CREATE TABLE participacion_chat (
    id_estudiante INT NOT NULL,
    id_chat INT NOT NULL,
    fecha_ingreso DATE NOT NULL
        DEFAULT CAST(GETDATE() AS DATE),

    CONSTRAINT PK_PARTICIPACION_CHAT
        PRIMARY KEY (id_estudiante, id_chat),

    CONSTRAINT FK_PARTICIPACION_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_PARTICIPACION_CHAT
        FOREIGN KEY (id_chat)
        REFERENCES chat(id_chat)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE TABLE curso_compartido (
    codigo_curso VARCHAR(20) NOT NULL,
    nombre_curso VARCHAR(120) NOT NULL,
    facultad VARCHAR(100) NOT NULL,
    nivel_complejidad VARCHAR(30) NOT NULL,

    CONSTRAINT PK_CURSO_COMPARTIDO
        PRIMARY KEY (codigo_curso)
);
GO

CREATE TABLE estudiante_curso (
    id_estudiante INT NOT NULL,
    codigo_curso VARCHAR(20) NOT NULL,

    CONSTRAINT PK_ESTUDIANTE_CURSO
        PRIMARY KEY (id_estudiante, codigo_curso),

    CONSTRAINT FK_ESTUDIANTE_CURSO_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_ESTUDIANTE_CURSO_CURSO
        FOREIGN KEY (codigo_curso)
        REFERENCES curso_compartido(codigo_curso)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO


CREATE TABLE investigacion (
    id_investigacion INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(120) NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    publico_interes VARCHAR(200) NULL,

    CONSTRAINT PK_INVESTIGACION
        PRIMARY KEY (id_investigacion)
);
GO

CREATE TABLE estudiante_investigacion (
    id_estudiante INT NOT NULL,
    id_investigacion INT NOT NULL,

    CONSTRAINT PK_ESTUDIANTE_INVESTIGACION
        PRIMARY KEY (id_estudiante, id_investigacion),

    CONSTRAINT FK_ESTUDIANTE_INVESTIGACION_ESTUDIANTE
        FOREIGN KEY (id_estudiante)
        REFERENCES estudiante(id_estudiante)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_ESTUDIANTE_INVESTIGACION_INVESTIGACION
        FOREIGN KEY (id_investigacion)
        REFERENCES investigacion(id_investigacion)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
GO

CREATE INDEX ix_publicacion_estudiante ON publicacion (id_estudiante);
CREATE INDEX ix_comentario_publicacion ON comentario (id_publicacion);
CREATE INDEX ix_comentario_estudiante ON comentario (id_estudiante);
CREATE INDEX ix_reaccion_publicacion ON reaccion (id_publicacion);
CREATE INDEX ix_reaccion_estudiante ON reaccion (id_estudiante);
