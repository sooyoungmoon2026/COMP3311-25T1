-- Q7
create or replace function
    hotelsIn(_addr text) returns text
as $$
declare
    r   record;
    out text := '';
begin
    for r in select * from bars where addr = _addr
    loop
        out := out || r.name || e'\n';
    end loop;
    return out;
end;
$$ language plpgsql;

-- Q8
create or replace function
    hotelsIn (_addr text) returns text
as $$
declare 
    howmany integer;
    pubnames text;
    p record;
begin
    select count(*) into howmany from Bars where addr = _addr;
    if (howmany = 0) then 
        return 'There are no hotels in '|| _addr || e'\n'; 
    end if;
    pubnames:= 'Hotels in ' || _addr || ':';
    for p in select * from Bars where addr = _addr
    loop
        pubnames := pubnames||'  '||p.name;
    end loop;
    pubnames := pubnames||e'\n';
    return pubnames;
end;
$$ language plpgsql;
