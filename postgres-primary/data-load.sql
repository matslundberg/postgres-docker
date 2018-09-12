CREATE TABLE IF NOT EXISTS scale_data (
   section NUMERIC NOT NULL,
   id1     NUMERIC NOT NULL,
   id2     NUMERIC NOT NULL
);

/*
INSERT INTO scale_data
SELECT sections.*, gen.*
     , CEIL(RANDOM()*100) 
  FROM GENERATE_SERIES(1, 300)     sections,
       GENERATE_SERIES(1, 9000) gen
--  FROM GENERATE_SERIES(1, 300)     sections,
--       GENERATE_SERIES(1, 900000) gen
 WHERE gen <= sections * 3000;
*/

BEGIN;
SELECT 'BEGIN; INSERT INTO scale_data values(' || id || ', CEIL(RANDOM()*100), CEIL(RANDOM()*100)); COMMIT; ' 
    FROM generate_series(1, 99999) AS id;
\gexec
COMMIT;