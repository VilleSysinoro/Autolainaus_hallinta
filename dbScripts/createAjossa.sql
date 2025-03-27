
CREATE OR REPLACE VIEW public.vapaana
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
   WHERE lainaus.palautus IS NULL;

ALTER TABLE public.ajossa
    OWNER TO postgres;

GRANT SELECT ON TABLE public.ajossa TO autolainaus;
GRANT ALL ON TABLE public.ajossa TO postgres;