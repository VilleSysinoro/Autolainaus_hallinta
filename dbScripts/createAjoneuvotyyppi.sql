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