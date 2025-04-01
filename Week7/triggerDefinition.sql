-- required: no args, returns TRIGGER, must be plpgsql
CREATE FUNCTION functionName() RETURNS TRIGGER
AS $$
BEGIN
	...
END;
$$ language plpgsql


CREATE TRIGGER TriggerName
{ BEFORE | AFTER | INSTEAD OF } Event1 [ OR Event2 ... ] 
ON TableName
FOR EACH { ROW | STATEMENT }
[ WHEN ( Condition ) ] -- Rarely used / not used in course
EXECUTE FUNCTION functionName();