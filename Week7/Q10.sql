CREATE TABLE Course(
    code        char(8) PRIMARY KEY, 
    lic         text, 
    quota       integer NOT NULL, 
    numStudes   integer NOT NULL DEFAULT 0
);

CREATE TABLE Enrolment(
    course char(8) REFERENCES Course(code),
    sid integer,
    mark integer,
    PRIMARY KEY (course, sid)
);

-- new
-- old
-- TG_OP

-- required: no args, returns TRIGGER, must be plpgsql
CREATE FUNCTION numStudesFunction() RETURNS TRIGGER
AS $$
BEGIN
	if TG_OP = 'INSERT' then 
        UPDATE Course SET numStudes = numStudes + 1 WHERE code = new.course;
        return new;
    elseif TG_OP = 'DELETE' then
        UPDATE Course SET numStudes = numStudes - 1 WHERE code = old.course;
        return old;
    else
        UPDATE Course SET numStudes = numStudes + 1 WHERE code = new.course;
        UPDATE Course SET numStudes = numStudes - 1 WHERE code = old.course;
        return new;
    end if;

END;
$$ language plpgsql;


CREATE TRIGGER UpdateNumberStudents
AFTER INSERT OR UPDATE OR DELETE
ON Enrolment
FOR EACH ROW
EXECUTE FUNCTION numStudesFunction();

CREATE FUNCTION quotaFunction() RETURNS TRIGGER
as $$
BEGIN
    if (select quota > numStudes from Course where code = new.course) then
        raise exception 'Class too full';
    end if;

    return new;
END;
$$ language plpgsql;

CREATE TRIGGER QuotaCheck
AFTER INSERT OR UPDATE
ON Enrolment
FOR EACH ROW
EXECUTE FUNCTION quotaFunction();