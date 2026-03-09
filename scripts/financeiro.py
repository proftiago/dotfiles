#!/usr/bin/env python3
# ╔══════════════════════════════════════════════════╗
# ║           Fast HR — Gestão de Cursos              ║
# ║      by Tiago · SQLite · GTK3 · Local             ║
# ╚══════════════════════════════════════════════════╝

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GLib, Pango
import sqlite3, os, hashlib
from datetime import datetime, date

DB_PATH = os.path.expanduser("~/local/share/curso-financeiro/financeiro.db")
os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)

MESES = ["Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"]
MESES_FULL = ["Janeiro","Fevereiro","Março","Abril","Maio","Junho",
              "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"]

# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#  DATABASE
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

def get_db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    conn = get_db()
    conn.executescript("""
        -- Tabela usuários (NOVA)
        CREATE TABLE IF NOT EXISTS usuarios (
            id       INTEGER PRIMARY KEY AUTOINCREMENT,
            usuario  TEXT UNIQUE NOT NULL,
            senha    TEXT NOT NULL,
            nome     TEXT NOT NULL,
            funcao   TEXT DEFAULT 'Funcionário',
            role     TEXT DEFAULT 'user', -- admin, financeiro, professor, atendimento
            ativo    INTEGER DEFAULT 1
        );
        -- Suas tabelas originais
        CREATE TABLE IF NOT EXISTS alunos (
            id            INTEGER PRIMARY KEY AUTOINCREMENT,
            nome          TEXT NOT NULL,
            telefone      TEXT DEFAULT '',
            email         TEXT DEFAULT '',
            idioma        TEXT DEFAULT '',
            nivel         TEXT DEFAULT 'Iniciante',
            horario       TEXT DEFAULT '',
            data_inicio   TEXT DEFAULT '',
            tipo          TEXT DEFAULT 'mensal',
            valor         REAL DEFAULT 0,
            vencimento    INTEGER DEFAULT 10,
            forma_pagamento TEXT DEFAULT 'PIX',
            obs           TEXT DEFAULT '',
            ativo         INTEGER DEFAULT 1,
            criado_em     TEXT DEFAULT CURRENT_TIMESTAMP
        );
        -- Tabela turmas (NOVA)
        CREATE TABLE IF NOT EXISTS turmas (
            id          INTEGER PRIMARY KEY AUTOINCREMENT,
            nome        TEXT NOT NULL,
            horario     TEXT NOT NULL,
            dia_semana  TEXT DEFAULT '',
            professor   TEXT DEFAULT '',
            nivel       TEXT DEFAULT 'Iniciante',
            max_alunos  INTEGER DEFAULT 10,
            ativa       INTEGER DEFAULT 1,
            criado_em   TEXT DEFAULT CURRENT_TIMESTAMP
        );
        -- Alunos nas turmas (NOVA)
        CREATE TABLE IF NOT EXISTS turma_alunos (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            turma_id   INTEGER,
            aluno_id   INTEGER,
            data_entrada TEXT DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY(turma_id) REFERENCES turmas(id),
            FOREIGN KEY(aluno_id) REFERENCES alunos(id)
        );
        -- Conteúdo das aulas (NOVA)
        CREATE TABLE IF NOT EXISTS aulas (
            id         INTEGER PRIMARY KEY AUTOINCREMENT,
            turma_id   INTEGER,
            data_aula  TEXT NOT NULL,
            conteudo   TEXT NOT NULL,
            professor  TEXT,
            obs        TEXT,
            FOREIGN KEY(turma_id) REFERENCES turmas(id)
        );
        -- Tabelas originais
        CREATE TABLE IF NOT EXISTS pagamentos (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            aluno_id  INTEGER,
            descricao TEXT NOT NULL,
            valor     REAL NOT NULL,
            forma     TEXT DEFAULT 'PIX',
            data      TEXT NOT NULL,
            mes       INTEGER NOT NULL,
            ano       INTEGER NOT NULL,
            FOREIGN KEY (aluno_id) REFERENCES alunos(id)
        );
        CREATE TABLE IF NOT EXISTS despesas (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            descricao TEXT NOT NULL,
            valor     REAL NOT NULL,
            categoria TEXT DEFAULT 'Geral',
            data      TEXT NOT NULL,
            mes       INTEGER NOT NULL,
            ano       INTEGER NOT NULL
        );
        CREATE TABLE IF NOT EXISTS follow

