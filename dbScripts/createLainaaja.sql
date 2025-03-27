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