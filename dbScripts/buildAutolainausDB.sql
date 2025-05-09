-- KÄYTTÄJÄ TUNNUKSET

-- Role: autolainaus
-- DROP ROLE IF EXISTS autolainaus;

CREATE ROLE autolainaus WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:0JY39AHn8pwXaXnPhxVUbA==$qBn13pM483HGKj0BrnPkF30GFXxQ0zrMLqv5I5kNtLo=:TtsBWtolGCLajBPMxh528jXpBHGt73MyPnajf0dXFUY=';

COMMENT ON ROLE autolainaus IS 'Autolainaus-sovellusten käyttäjätunnus autolainaus-tietokantaan.';


-- TIETOKANNAN LUOMINEN

-- Database: autolainaus
-- DROP DATABASE IF EXISTS autolainaus;

CREATE DATABASE autolainaus
    WITH
    OWNER = postgres
    TEMPLATE =template0
    ENCODING = 'WIN1252'
    LC_COLLATE = 'Finnish_Finland.1252'
    LC_CTYPE = 'Finnish_Finland.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

COMMENT ON DATABASE autolainaus
    IS 'Rasekon auto-osaston ajopäiväkirjasovellus';


-- LAINAAJA-TAULU

-- Table: public.lainaaja
-- DROP TABLE IF EXISTS public.lainaaja;

CREATE TABLE IF NOT EXISTS public.lainaaja
(
    hetu character(11) PRIMARY KEY NOT NULL,
    etunimi character varying(50) NOT NULL,
    sukunimi character varying(50) NOT NULL,
    ajokorttiluokka character varying(6) NOT NULL,
    automaatti boolean NOT NULL,
    sahkoposti character varying(30)
    );


ALTER TABLE IF EXISTS public.lainaaja
    OWNER to postgres;

REVOKE ALL ON TABLE public.lainaaja FROM autolainaus;

GRANT INSERT, DELETE, UPDATE, SELECT ON TABLE public.lainaaja TO autolainaus;


GRANT ALL ON TABLE public.lainaaja TO postgres;

COMMENT ON TABLE public.lainaaja
    IS 'Lainaajan (opiskelija tai ope) perustiedot';

COMMENT ON COLUMN public.lainaaja.hetu
    IS 'Kansallinen henkilötunnus';

COMMENT ON COLUMN public.lainaaja.sahkoposti
    IS 'Rasekon sähköpostiosoite';

COMMENT ON COLUMN public.lainaaja.ajokorttiluokka
    IS 'Esim. AB tai ABCE';


-- AJONEUVOTYYPPI-TAULU

-- Table: public.ajoneuvotyyppi
-- DROP TABLE IF EXISTS public.ajoneuvotyyppi;

CREATE TABLE IF NOT EXISTS public.ajoneuvotyyppi
(
    tyyppi character varying(30) PRIMARY KEY NOT NULL
);

ALTER TABLE IF EXISTS public.ajoneuvotyyppi
    OWNER to postgres;

REVOKE ALL ON TABLE public.ajoneuvotyyppi FROM autolainaus;

GRANT SELECT ON TABLE public.ajoneuvotyyppi TO autolainaus;

GRANT ALL ON TABLE public.ajoneuvotyyppi TO postgres;


-- AUTO-TAULU

-- Table: public.auto
-- DROP TABLE IF EXISTS public.auto;

CREATE TABLE IF NOT EXISTS public.auto
(
    rekisterinumero character varying(7) PRIMARY KEY NOT NULL,
    kaytettavissa boolean NOT NULL DEFAULT true
    merkki character varying(30) NOT NULL,
    malli character varying(20) NOT NULL,
    vuosimalli character(4) NOT NULL,
    henkilomaara integer,
    tyyppi character varying,
    automaatti boolean NOT NULL,
    vastuuhenkilo character varying(30),
    kuva bytea,
    CONSTRAINT ajoneuvotyyppi_fk FOREIGN KEY (tyyppi)
        REFERENCES public.ajoneuvotyyppi (tyyppi) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);



ALTER TABLE IF EXISTS public.auto
    OWNER to postgres;

REVOKE ALL ON TABLE public.auto FROM autolainaus;

GRANT INSERT, DELETE, UPDATE, SELECT ON TABLE public.auto TO autolainaus;

GRANT ALL ON TABLE public.auto TO postgres;

COMMENT ON TABLE public.auto
    IS 'Ajoneuvon perustiedot';


-- TARKOITUS-TAULU

-- Table: public.tarkoitus
-- DROP TABLE IF EXISTS public.tarkoitus;

CREATE TABLE IF NOT EXISTS public.tarkoitus
(
    tarkoitus character varying(30) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT tarkoitus_pk PRIMARY KEY (tarkoitus)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.tarkoitus
    OWNER to postgres;

REVOKE ALL ON TABLE public.tarkoitus FROM autolainaus;

GRANT DELETE, INSERT, REFERENCES, SELECT, TRIGGER, UPDATE ON TABLE public.tarkoitus TO autolainaus;

GRANT ALL ON TABLE public.tarkoitus TO postgres;


-- LAINAUS-TAULU

-- Table: public.lainaus
-- DROP TABLE IF EXISTS public.lainaus;

CREATE TABLE IF NOT EXISTS public.lainaus
(
    lainausnumero serial PRIMARY KEY NOT NULL,
    hetu character(11) NOT NULL,
    rekisterinumero character varying(7) NOT NULL,
    palautus timestamp without time zone,
    lainausaika timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT auto_lainaus_fk FOREIGN KEY (rekisterinumero)
        REFERENCES public.auto (rekisterinumero) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT lainaaja_lainaus_fk FOREIGN KEY (hetu)
        REFERENCES public.lainaaja (hetu) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

ALTER TABLE IF EXISTS public.lainaus
    OWNER to postgres;

REVOKE ALL ON TABLE public.lainaus FROM autolainaus;

GRANT INSERT, DELETE, UPDATE, SELECT ON TABLE public.lainaus TO autolainaus;

GRANT ALL ON TABLE public.lainaus TO postgres;

COMMENT ON TABLE public.lainaus
    IS 'Lainaustapahtuman tiedot';

COMMENT ON COLUMN public.lainaus.lainausnumero
    IS 'Lainaustapahtumalle automaattisesti annettava juokseva numero';

COMMENT ON COLUMN public.lainaus.hetu
    IS 'Kansallinen henkilötunnus';

COMMENT ON COLUMN public.lainaus.palautus
    IS 'Palautuksen päivä ja kellonaika';

-- Rights to use and update lainausnumero serial and the sequence
GRANT ALL ON SEQUENCE public.lainaus_lainausnumero_seq TO postgres;
GRANT ALL ON SEQUENCE public.lainaus_lainausnumero_seq TO autolainaus;


-- AJOSSA-NÄKYMÄ

CREATE OR REPLACE VIEW public.ajossa
 AS
   SELECT lainaus.rekisterinumero,
 	merkki,
	malli,
	auto.automaatti,
	henkilomaara,
        (lainaaja.etunimi::text || ' '::text) || lainaaja.sukunimi::text AS kuljettaja
   FROM lainaaja
     INNER JOIN lainaus ON lainaaja.hetu = lainaus.hetu
     INNER JOIN auto ON lainaus.rekisterinumero = auto.rekisterinumero
   WHERE lainaus.palautusaika IS NULL AND auto.kaytettavissa = TRUE;

ALTER TABLE public.ajossa
    OWNER TO postgres;

GRANT SELECT ON TABLE public.ajossa TO autolainaus;
GRANT ALL ON TABLE public.ajossa TO postgres;


-- VAPAANA-NÄKYMÄ

-- View: public.vapaana
-- DROP VIEW public.vapaana;

CREATE VIEW public.vapaana
AS
   SELECT rekisterinumero,
    merkki,
    malli,
    automaatti,
    henkilomaara
   FROM auto
   WHERE auto.kaytettavissa = TRUE AND NOT (rekisterinumero::text IN ( SELECT ajossa.rekisterinumero
           FROM ajossa))
   ORDER BY rekisterinumero;

ALTER TABLE public.vapaana
    OWNER TO postgres;

GRANT SELECT ON TABLE public.vapaana TO autolainaus;
GRANT ALL ON TABLE public.vapaana TO postgres;


-- AJOPÄIVÄKIRJA

-- View: public.ajopaivakirja
-- DROP VIEW public.ajopaivakirja;

CREATE OR REPLACE VIEW public.ajopaivakirja
 AS
 SELECT lainaus.rekisterinumero,
    auto.merkki,
    lainaus.tarkoitus,
    lainaus.hetu,
    lainaaja.sukunimi,
    lainaaja.etunimi,
    date_trunc('minute'::text, lainaus.lainausaika) AS otto,
    date_trunc('minute'::text, lainaus.palautusaika) AS palautus
   FROM auto
     JOIN lainaus ON auto.rekisterinumero::text = lainaus.rekisterinumero::text
     JOIN lainaaja ON lainaus.hetu = lainaaja.hetu
  ORDER BY lainaus.lainausaika DESC;

ALTER TABLE public.ajopaivakirja
    OWNER TO postgres;
COMMENT ON VIEW public.ajopaivakirja
    IS 'Ajopäiväkirja kaikista autoista ja ajoista';

GRANT SELECT ON TABLE public.ajopaivakirja TO autolainaus;
GRANT ALL ON TABLE public.ajopaivakirja TO postgres;


-- AJOPÄIVÄKIRJA AUTOITTAIN

-- View: public.autoittain
-- DROP VIEW public.autoittain;

CREATE OR REPLACE VIEW public.autoittain
 AS
 SELECT auto.rekisterinumero,
    auto.merkki,
    auto.malli,
    lainaus.tarkoitus,
    lainaaja.hetu,
    lainaaja.sukunimi,
    lainaaja.etunimi,
    date_trunc('minute'::text, lainaus.lainausaika) AS otto,
    date_trunc('minute'::text, lainaus.palautusaika) AS palautus
   FROM auto
     JOIN lainaus ON auto.rekisterinumero::text = lainaus.rekisterinumero::text
     JOIN lainaaja ON lainaus.hetu = lainaaja.hetu
  ORDER BY auto.rekisterinumero, lainaus.lainausaika DESC;

ALTER TABLE public.autoittain
    OWNER TO postgres;
COMMENT ON VIEW public.autoittain
    IS 'Ajopäiväkirja autokohtaisesti käänteisessä aikajärjestyksessä eli uusimmat lainaukset ensin.';

GRANT SELECT ON TABLE public.autoittain TO autolainaus;
GRANT ALL ON TABLE public.autoittain TO postgres;


-- TIETOJEN SIIRTO JA TALTEENOTTO

-- Table: public.siirto
-- DROP TABLE IF EXISTS public.siirto;

CREATE TABLE IF NOT EXISTS public.siirto
(
    rekisterinumero character varying(7),
    merkki character varying(30),
    malli character varying(30),
    tarkoitus character varying(30),
    hetu character varying(11),
    etunimi character varying(50),
    sukunimi character varying(50),
    otto timestamp without time zone,
    palautus timestamp without time zone
)

ALTER TABLE IF EXISTS public.siirto
    OWNER to postgres;


-- AJOPÄIVÄKIRJA-NÄKYMÄN TIETOJEN TUONTI SIIRTO TALUUN

INSERT INTO public.siirto (SELECT * FROM public.ajopaivakirja)