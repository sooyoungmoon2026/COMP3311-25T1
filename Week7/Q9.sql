DROP TABLE IF EXISTS Emp;

CREATE TABLE Emp(
    empname     text PRIMARY KEY, 
    salary      integer NOT NULL, 
    last_date   timestamp NOT NULL, 
    last_usr    text NOT NULL
);

-- required: no args, returns TRIGGER, must be plpgsql
CREATE FUNCTION updateTimeUser() RETURNS TRIGGER
AS $$
BEGIN
    if new.empname is NULL then
        raise exception 'empname should not be null';
    end if;

    if new.salary <= 0 then
        raise exception 'salary must be positive';
    end if;

	new.last_date := now();
	new.last_usr := user;

    return new;
END;
$$ language plpgsql;


CREATE TRIGGER UpdateInfo
BEFORE INSERT OR UPDATE
ON Emp
FOR EACH ROW
EXECUTE FUNCTION updateTimeUser();