-- insert into Suppliers Values
-- (1, 'Best Keyboard Suppliers', 'Hurstville'),
-- (2, 'Worst Keyboard Suppliers', 'Bankstown'),
-- (3, 'Better Keyboard Suppliers', 'Surry Hills'),
-- (4, 'Mid Keyboard Suppliers', 'Marrickville');

-- insert into Parts Values
-- (1, 'Key A', 'Blue'),
-- (2, 'Key B', 'Green'),
-- (3, 'Key C', 'Red'),
-- (4, 'Key D', 'Red');

-- insert into Catalog Values
-- (1, 1, 1),
-- (1, 2, 2),
-- (1, 3, 3),
-- (2, 4, 4),
-- (2, 2, 3),
-- (3, 3, 5),
-- (3, 4, 2),
-- (4, 1, 5),
-- (4, 2, 3);

-- create table Suppliers (
--       sid     integer primary key,
--       sname   text,
--       address text
-- );
-- create table Parts (
--       pid     integer primary key,
--       pname   text,
--       colour  text
-- );
-- create table Catalog (
--       sid     integer references Suppliers(sid),
--       pid     integer references Parts(pid),
--       cost    real,
--       primary key (sid,pid)
-- );

--- Q12: Find the names of suppliers who supply some red part.
select distinct S.sname from Suppliers S
join Catalog C on (S.sid = C.sid)
join Parts P on (C.pid = P.pid)
where P.colour ILIKE 'red';

--- Q13: Find the sids of suppliers who supply some red or green part.
select distinct S.sid from Suppliers S
join Catalog C on (S.sid = C.sid)
join Parts P on (C.pid = P.pid)
where P.colour ILIKE 'red' or P.colour ILIKE 'green';

--- Q14: Find the sids of suppliers who supply some red part or whose address is Marrickville.
select distinct S.sid from Suppliers S
join Catalog C on (S.sid = C.sid)
join Parts P on (C.pid = P.pid)
where P.colour ILIKE 'red' or S.address = 'Marrickville';

--- Q15: Find the sids of suppliers who supply some red part and some green part.
select distinct S.sid from Suppliers S
join Catalog C on (S.sid = C.sid)
join Parts P on (C.pid = P.pid)
where P.colour ILIKE 'red' and exists (
      select * from Suppliers S1
      join Catalog C1 on (S1.sid = C1.sid)
      join Parts P1 on (C1.pid = P1.pid)
      where P1.colour ILIKE 'green' and S1.sid = S.sid
)

--- Q16: Find the sids of suppliers who supply every part.
select * from Suppliers S
where not exists (
      (
            select P.pid from Parts P
      )
      except
      (
            select C.pid from Catalog C where C.sid = S.sid
      )
)

--- P1, P2, P3, P4

-- S1 -> P1, P2, P3
-- S2 -> P1, P2, P3, P4
