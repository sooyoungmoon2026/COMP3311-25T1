-- S - State
-- S = sfunc(S, V1)
-- S = sfunc(S, V2)
-- S = sfunc(S, V3)
-- S = sfunc(S, V4)
-- S = sfunc(S, V5)

--- PRODUCT EXAMPLE ---

CREATE OR REPLACE FUNCTION mult(state Numeric, newValue Numeric) returns Numeric
as $$
BEGIN
    return state * newValue;
END;
$$ language plpgsql;

CREATE OR REPLACE AGGREGATE product(Numeric) (
    stype     = Numeric,
    sfunc     = mult,
    initcond  = 1
);