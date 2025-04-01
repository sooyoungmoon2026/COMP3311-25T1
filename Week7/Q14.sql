
CREATE TYPE Pair as (sum Numeric, count Numeric);

CREATE FUNCTION update_pair(state Pair, newValue Numeric) returns Pair
as $$
BEGIN
    if newValue is not null then
        state.sum := state.sum + newValue;
        state.count := state.count + 1;
    end if;

    return state;
END;
$$ language plpgsql;


CREATE FUNCTION finalise(p Pair) returns Numeric
as $$
BEGIN
    if p.count = 0 then 
        return NULL;
    end if;

    return p.sum / p.count;
END;
$$ language plpgsql;

CREATE AGGREGATE my_avg(Numeric) (
    stype     = Pair,
    sfunc     = update_pair,
    initcond  = '(0,0)',
    finalfunc = finalise
);

