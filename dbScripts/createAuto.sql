-- Table: public.auto

-- DROP TABLE IF EXISTS public.auto;

CREATE TABLE IF NOT EXISTS public.auto
(
    rekisterinumero character varying(7) PRIMARY KEY NOT NULL,
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