-- ForgeRoster — Modèle Physique de Données
-- SGBD cible : PostgreSQL 18
-- Ce script crée la structure complète de la base. Il est rejouable :
-- il supprime les tables existantes avant de les recréer.

BEGIN;

DROP TABLE IF EXISTS warband_special_rule, recruit_equipment, warrior_equipment,
                     share_link, recruit, warband,
                     special_rule, equipment, warrior, faction, account
                     CASCADE;

-- ---------------------------------------------------------------------------
-- Comptes
-- ---------------------------------------------------------------------------

CREATE TABLE account (
    id            UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    email         VARCHAR(255) NOT NULL,
    username      VARCHAR(50)  NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role          VARCHAR(20)  NOT NULL DEFAULT 'PLAYER',
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    CONSTRAINT account_email_unique UNIQUE (email),
    CONSTRAINT account_username_unique UNIQUE (username),
    CONSTRAINT account_role_valid CHECK (role IN ('PLAYER', 'ADMIN'))
);

-- ---------------------------------------------------------------------------
-- Catalogue (données de référence, gérées par l'administrateur)
-- ---------------------------------------------------------------------------

CREATE TABLE faction (
    id          INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    description TEXT,
    CONSTRAINT faction_name_unique UNIQUE (name)
);

CREATE TABLE warrior (
    id               INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             VARCHAR(100) NOT NULL,
    description      TEXT,
    category         VARCHAR(20)  NOT NULL DEFAULT 'INFANTRY',
    min_availability SMALLINT     NOT NULL DEFAULT 0,
    max_availability SMALLINT,
    movement         SMALLINT     NOT NULL DEFAULT 0,
    melee            SMALLINT     NOT NULL DEFAULT 0,
    ranged           SMALLINT     NOT NULL DEFAULT 0,
    armor            SMALLINT     NOT NULL DEFAULT 0,
    ducat_cost       INTEGER      NOT NULL,
    faction_id       INTEGER      NOT NULL,
    CONSTRAINT warrior_faction_fk FOREIGN KEY (faction_id) REFERENCES faction (id) ON DELETE RESTRICT,
    CONSTRAINT warrior_name_unique UNIQUE (faction_id, name),
    CONSTRAINT warrior_cost_positive CHECK (ducat_cost >= 0),
    CONSTRAINT warrior_category_valid CHECK (category IN ('LEADER', 'ELITE', 'INFANTRY')),
    CONSTRAINT warrior_min_availability_positive CHECK (min_availability >= 0),
    CONSTRAINT warrior_max_availability_positive CHECK (max_availability >= 1),
    CONSTRAINT warrior_availability_range CHECK (max_availability >= min_availability)
);

CREATE TABLE equipment (
    id              INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    type            VARCHAR(20)  NOT NULL,
    description     TEXT,
    ducat_cost      INTEGER      NOT NULL,
    movement_mod    SMALLINT     NOT NULL DEFAULT 0,
    melee_mod       SMALLINT     NOT NULL DEFAULT 0,
    ranged_mod      SMALLINT     NOT NULL DEFAULT 0,
    armor_mod       SMALLINT     NOT NULL DEFAULT 0,
    injury_dice_mod SMALLINT     NOT NULL DEFAULT 0,
    injury_mod      SMALLINT     NOT NULL DEFAULT 0,
    CONSTRAINT equipment_name_unique UNIQUE (name),
    CONSTRAINT equipment_type_valid CHECK (type IN ('MELEE', 'RANGED', 'ARMOR', 'ACCESSORY')),
    CONSTRAINT equipment_cost_positive CHECK (ducat_cost >= 0)
);

CREATE TABLE special_rule (
    id              INTEGER      GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    description     TEXT,
    movement_mod    SMALLINT     NOT NULL DEFAULT 0,
    melee_mod       SMALLINT     NOT NULL DEFAULT 0,
    ranged_mod      SMALLINT     NOT NULL DEFAULT 0,
    armor_mod       SMALLINT     NOT NULL DEFAULT 0,
    injury_dice_mod SMALLINT     NOT NULL DEFAULT 0,
    injury_mod      SMALLINT     NOT NULL DEFAULT 0,
    faction_id      INTEGER,
    CONSTRAINT special_rule_name_unique UNIQUE (name),
    CONSTRAINT special_rule_faction_fk FOREIGN KEY (faction_id) REFERENCES faction (id) ON DELETE RESTRICT
);

-- Équipements qu'un combattant du catalogue a le droit de porter (association ALLOWS)
CREATE TABLE warrior_equipment (
    warrior_id   INTEGER NOT NULL,
    equipment_id INTEGER NOT NULL,
    CONSTRAINT warrior_equipment_pk PRIMARY KEY (warrior_id, equipment_id),
    CONSTRAINT warrior_equipment_warrior_fk FOREIGN KEY (warrior_id) REFERENCES warrior (id) ON DELETE CASCADE,
    CONSTRAINT warrior_equipment_equipment_fk FOREIGN KEY (equipment_id) REFERENCES equipment (id) ON DELETE CASCADE
);

-- ---------------------------------------------------------------------------
-- Données des joueurs
-- ---------------------------------------------------------------------------

CREATE TABLE warband (
    id           UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    name         VARCHAR(100) NOT NULL,
    ducat_budget INTEGER      NOT NULL,
    created_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at   TIMESTAMPTZ  NOT NULL DEFAULT now(),
    account_id   UUID         NOT NULL,
    faction_id   INTEGER      NOT NULL,
    CONSTRAINT warband_account_fk FOREIGN KEY (account_id) REFERENCES account (id) ON DELETE CASCADE,
    CONSTRAINT warband_faction_fk FOREIGN KEY (faction_id) REFERENCES faction (id) ON DELETE RESTRICT,
    CONSTRAINT warband_budget_positive CHECK (ducat_budget > 0)
);

CREATE TABLE recruit (
    id         UUID         PRIMARY KEY DEFAULT gen_random_uuid(),
    quantity   SMALLINT     NOT NULL DEFAULT 1,
    nickname   VARCHAR(100),
    warband_id UUID         NOT NULL,
    warrior_id INTEGER      NOT NULL,
    CONSTRAINT recruit_warband_fk FOREIGN KEY (warband_id) REFERENCES warband (id) ON DELETE CASCADE,
    CONSTRAINT recruit_warrior_fk FOREIGN KEY (warrior_id) REFERENCES warrior (id) ON DELETE RESTRICT,
    CONSTRAINT recruit_quantity_positive CHECK (quantity >= 1)
);

-- Équipements réellement portés par une recrue (association CARRIES)
CREATE TABLE recruit_equipment (
    recruit_id   UUID    NOT NULL,
    equipment_id INTEGER NOT NULL,
    CONSTRAINT recruit_equipment_pk PRIMARY KEY (recruit_id, equipment_id),
    CONSTRAINT recruit_equipment_recruit_fk FOREIGN KEY (recruit_id) REFERENCES recruit (id) ON DELETE CASCADE,
    CONSTRAINT recruit_equipment_equipment_fk FOREIGN KEY (equipment_id) REFERENCES equipment (id) ON DELETE RESTRICT
);

-- Règles spéciales appliquées à un warband (association APPLIES)
CREATE TABLE warband_special_rule (
    warband_id      UUID    NOT NULL,
    special_rule_id INTEGER NOT NULL,
    CONSTRAINT warband_special_rule_pk PRIMARY KEY (warband_id, special_rule_id),
    CONSTRAINT warband_special_rule_warband_fk FOREIGN KEY (warband_id) REFERENCES warband (id) ON DELETE CASCADE,
    CONSTRAINT warband_special_rule_rule_fk FOREIGN KEY (special_rule_id) REFERENCES special_rule (id) ON DELETE RESTRICT
);

CREATE TABLE share_link (
    id         INTEGER     GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    token      VARCHAR(64) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at TIMESTAMPTZ NOT NULL,
    is_active  BOOLEAN     NOT NULL DEFAULT TRUE,
    warband_id UUID        NOT NULL,
    CONSTRAINT share_link_warband_fk FOREIGN KEY (warband_id) REFERENCES warband (id) ON DELETE CASCADE,
    CONSTRAINT share_link_token_unique UNIQUE (token),
    CONSTRAINT share_link_expiration_valid CHECK (expires_at > created_at)
);

-- ---------------------------------------------------------------------------
-- Index
-- PostgreSQL indexe automatiquement les clés primaires et les contraintes
-- UNIQUE, mais pas les clés étrangères. On les indexe là où une requête
-- fréquente filtre dessus.
-- ---------------------------------------------------------------------------

CREATE INDEX warband_account_idx ON warband (account_id);
CREATE INDEX recruit_warband_idx ON recruit (warband_id);
CREATE INDEX warrior_faction_idx ON warrior (faction_id);
CREATE INDEX share_link_warband_idx ON share_link (warband_id);
CREATE INDEX recruit_equipment_equip_idx ON recruit_equipment (equipment_id);
CREATE INDEX warrior_equipment_equip_idx ON warrior_equipment (equipment_id);
CREATE INDEX special_rule_faction_idx ON special_rule (faction_id);

COMMIT;
