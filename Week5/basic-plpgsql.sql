-- CREATE OR REPLACE FUNCTION
--     functionName(param integer) RETURNS integer
-- AS $$
-- BEGIN
--     return 1;
-- END;
-- $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
    sqr(n numeric) RETURNS numeric
AS $$
BEGIN
    return n*n;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION
    spread(str text) RETURNS text
AS $$
DECLARE
    result text;
    i integer;
BEGIN
    result := '';

    for i in 1..length(str) loop
        result := result || substr(str, i, 1) || ' ';
    end loop;

    return substr(result, 0, length(result));
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION
    seq(n integer) RETURNS setof integer
AS $$
DECLARE
    i integer;
BEGIN
    for i in 1..n loop
        return next i;
    end loop;

    return;
END;
$$ LANGUAGE plpgsql;


---- pseudocode for two ways to sql query in plpgsql functions
-- CREATE OR REPLACE FUNCTION
--     querying() RETURNS integer
-- AS $$
-- DECLARE
--     temp text;
-- BEGIN
--     select name into temp from Cheeses; -- works if query returns one tuple


--     for temp in (                       -- goes through each tuple one by one
--         select name from Cheeses
--     ) loop
--         do something
--     end loop

-- END;
-- $$ LANGUAGE plpgsql;
