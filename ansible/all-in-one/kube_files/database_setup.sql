--
-- Create main database
--
-- create database kube;
-- This will be created by an environment property to the kube.

--
-- Use main database
--
use kube;

--
-- Table for images that are stored
--
create table images(
    id int not null auto_increment primary key,
    path varchar(255) not null,
    person int,
    status int
);

--
-- Person table which stores known people
--
create table person(
    id int not null auto_increment primary key,
    name varchar(255) not null
);

--
-- Person images are images associated with known people
--
create table person_images(
    id int not null auto_increment primary key,
    image_name varchar(255),
    person_id int
);

--
-- Priming the known people table with some data
--
insert into person (name) values('Damian');
insert into person (name) values('Barack');
insert into person (name) values('Duda');
insert into person (name) values('Lewy');

--
-- Priming known people images table with some data
--
insert into person_images (image_name, person_id) values ('damian_01.PNG', 1);
insert into person_images (image_name, person_id) values ('damian_02.PNG', 1);
insert into person_images (image_name, person_id) values ('barack_01.jpg', 2);
insert into person_images (image_name, person_id) values ('barack_02.PNG', 2);
insert into person_images (image_name, person_id) values ('duda_01.PNG', 3);
insert into person_images (image_name, person_id) values ('duda_02.PNG', 3);
insert into person_images (image_name, person_id) values ('lewy_01.PNG', 4);
insert into person_images (image_name, person_id) values ('lewy_02.PNG', 4);
