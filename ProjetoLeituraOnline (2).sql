-- Ativar extensão de UUID no PostgreSQL (Remoto)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE livros (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    url_capa VARCHAR(255),
    total_paginas INT NOT NULL,
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE livros_usuario (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
    livro_id UUID REFERENCES livros(id) ON DELETE CASCADE,
    ultima_pagina_lida INT DEFAULT 0,
    status VARCHAR(20) DEFAULT 'LENDO', -- Valores: LENDO, CONCLUIDO, ABANDONADO
    sincronizado BOOLEAN DEFAULT FALSE,  -- Essencial para o banco LOCAL (App)
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(usuario_id, livro_id)
);

CREATE TABLE marcadores (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
    livro_id UUID REFERENCES livros(id) ON DELETE CASCADE,
    numero_pagina INT NOT NULL,
    texto_nota TEXT,
    excluido BOOLEAN DEFAULT FALSE,      -- Soft delete para sincronização offline
    atualizado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);