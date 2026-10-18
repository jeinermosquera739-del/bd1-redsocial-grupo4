CREATE TABLE estudiante (
    id_estudiante SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    apellido VARCHAR(60) NOT NULL,
    documento VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(120) NOT NULL UNIQUE,
    carrera VARCHAR(100) NOT NULL
);

CREATE TABLE perfil (
    id_perfil SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL UNIQUE REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    foto VARCHAR(255),
    descripcion VARCHAR(500)
);

-- 2. MÓDULO DE INTERESES Y HABILIDADES
CREATE TABLE interes (
    id_interes SERIAL PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL UNIQUE,
    tipo VARCHAR(40) NOT NULL
);

CREATE TABLE estudiante_interes (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_interes INT REFERENCES interes(id_interes) ON DELETE CASCADE,
    PRIMARY KEY (id_estudiante, id_interes)
);

-- 3. MÓDULO DE INTERACCIÓN Y CONTENIDO
CREATE TABLE publicacion (
    id_publicacion SERIAL PRIMARY KEY,
    id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    titulo VARCHAR(150) NOT NULL,
    contenido TEXT NOT NULL,
    fecha_publicacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_publicacion VARCHAR(40) NOT NULL
);

CREATE TABLE comentario (
    id_comentario SERIAL PRIMARY KEY,
    id_publicacion INT NOT NULL REFERENCES publicacion(id_publicacion) ON DELETE CASCADE,
    id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    contenido TEXT NOT NULL,
    fecha_comentario TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reaccion (
    id_reaccion SERIAL PRIMARY KEY,
    id_publicacion INT NOT NULL REFERENCES publicacion(id_publicacion) ON DELETE CASCADE,
    id_estudiante INT NOT NULL REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    tipo_reaccion VARCHAR(30) NOT NULL,
    CONSTRAINT uk_reaccion_estudiante_pub UNIQUE (id_estudiante, id_publicacion)
);

-- 4. MÓDULO DE COMUNIDAD Y RED SOCIAL
CREATE TABLE grupo (
    id_grupo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion VARCHAR(500)
);

CREATE TABLE membresia (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_grupo INT REFERENCES grupo(id_grupo) ON DELETE CASCADE,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    rol_grupo VARCHAR(30) DEFAULT 'Miembro' CHECK (rol_grupo IN ('Miembro', 'Moderador', 'Líder')),
    PRIMARY KEY (id_estudiante, id_grupo)
);

CREATE TABLE seguimiento (
    id_seguidor INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_seguido INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    fecha_seguimiento DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT chk_no_autoseguimiento CHECK (id_seguidor <> id_seguido)
);

-- 5. MÓDULO DE ACTIVIDADES Y EVENTOS
CREATE TABLE evento (
    id_evento SERIAL PRIMARY KEY,
    id_creador INT NOT NULL REFERENCES estudiante(id_estudiante) ON DELETE RESTRICT,
    nombre VARCHAR(120) NOT NULL,
    descripcion VARCHAR(500),
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    lugar VARCHAR(150) NOT NULL,
    tipo_evento VARCHAR(50) NOT NULL,
    estado_evento VARCHAR(30) DEFAULT 'Planeado' CHECK (estado_evento IN ('Planeado', 'Activo', 'Finalizado', 'Cancelado'))
);

CREATE TABLE inscripcion_evento (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_evento INT REFERENCES evento(id_evento) ON DELETE CASCADE,
    fecha_inscripcion DATE DEFAULT CURRENT_DATE,
    estado_inscripcion VARCHAR(30) DEFAULT 'Inscrito',
    PRIMARY KEY (id_estudiante, id_evento)
);

-- 6. MÓDULO DE COMUNICACIÓN
CREATE TABLE chat (
    id_chat SERIAL PRIMARY KEY,
    tipo_chat VARCHAR(20) NOT NULL CHECK (tipo_chat IN ('Individual', 'Grupal')),
    nombre_chat VARCHAR(100),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE participacion_chat (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_chat INT REFERENCES chat(id_chat) ON DELETE CASCADE,
    fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_estudiante, id_chat)
);

-- 7. MÓDULO DE VIDA ACADÉMICA E INVESTIGACIÓN
CREATE TABLE curso_compartido (
    codigo_curso VARCHAR(20) PRIMARY KEY,
    nombre_curso VARCHAR(120) NOT NULL,
    facultad VARCHAR(100) NOT NULL,
    nivel_complejidad VARCHAR(30)
);

CREATE TABLE estudiante_curso (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    codigo_curso VARCHAR(20) REFERENCES curso_compartido(codigo_curso) ON DELETE CASCADE,
    PRIMARY KEY (id_estudiante, codigo_curso)
);

CREATE TABLE investigacion (
    id_investigacion SERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    titulo VARCHAR(200) NOT NULL,
    publico_interes VARCHAR(200)
);

CREATE TABLE estudiante_investigacion (
    id_estudiante INT REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    id_investigacion INT REFERENCES investigacion(id_investigacion) ON DELETE CASCADE,
    PRIMARY KEY (id_estudiante, id_investigacion)
);

-- ÍNDICES RECOMENDADOS PARA EL RENDIMIENTO DE LA RED SOCIAL
CREATE INDEX idx_estudiante_correo ON estudiante(correo);
CREATE INDEX idx_publicacion_estudiante ON publicacion(id_estudiante);
CREATE INDEX idx_comentario_publicacion ON comentario(id_publicacion);
CREATE INDEX idx_evento_creador ON evento(id_creador);