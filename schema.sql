use petition;
create table signatures (
	id int NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ts timestamp,
	first_name varchar(25),
	last_name varchar(30),
	email varchar(100),
	city varchar(50),
	state char(2),
    country varchar(50),
	address varchar(100),
	comments text
);
