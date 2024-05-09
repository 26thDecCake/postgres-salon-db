--psql --username=freecodecamp --dbname=postgres
--psql --username=freecodecamp --dbname=salon
--\c salon

create database salon
create table customers();
create table appointments();
create table services();

alter table customers add column customer_id serial primary key;
alter table appointments add column appointment_id serial primary key;
alter table services add column service_id serial primary key;

alter table appointments add column customer_id int;
alter table appointments add column service_id int;

alter table appointments add foreign key(customer_id) references customers(customer_id);
alter table appointments add foreign key(service_id) references services(service_id);

alter table customers add column name varchar(30) not null;
alter table services add column name varchar(30) not null;
alter table customers add column phone varchar(25) unique;
alter table appointments add column time varchar(30) not null;

insert into services (name) values ('cut'), ('color'), ('perm'), ('style'), ('trim');

