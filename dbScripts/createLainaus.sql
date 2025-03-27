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
