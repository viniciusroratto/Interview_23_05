
--drop table if exists Matriculas;
--drop table if exists Alunos;
--drop table if exists Disciplinas;
--drop table if exists Cursos;

create table Cursos
(codc serial not null primary key,
nomec varchar(20) not null);

insert into Cursos(nomec) values ('cic');
insert into Cursos(nomec) values ('ecp');
insert into Cursos(nomec) values ('med');

create table Disciplinas
(codd serial not null primary key,
nomed varchar(20) not null unique,
 creditos INT not null,
 professor varchar(20) not null);

insert into Disciplinas(nomed, creditos, professor) values ('calculo I',6,'paulo');
insert into Disciplinas(nomed, creditos, professor) values ('calculo II',6,'paulo');
insert into Disciplinas(nomed, creditos, professor) values ('geometria', 2, 'tereza');
insert into Disciplinas(nomed, creditos, professor) values ('algebra', 4, 'tereza');
insert into Disciplinas(nomed, creditos, professor) values ('anatomia', 4, 'paula');
insert into Disciplinas(nomed, creditos, professor) values ('etica', 4, 'raquel');

create table Alunos
(coda serial not null primary key,
nomea varchar(20) not null,
idade int not null,
codc int,
foreign key(codc) references Cursos(codc));

insert into Alunos(nomea, idade, codc) values ('maria', 20, 1);
insert into Alunos(nomea, idade, codc) values ('joao', 18, 1);
insert into Alunos(nomea, idade, codc) values ('jose', 18, 1);
insert into Alunos(nomea, idade, codc) values ('raoni', 18, 3);
insert into Alunos(nomea, idade, codc) values ('anahi', 18, 3);
insert into Alunos(nomea, idade, codc) values ('raquel', 21, 2);
insert into Alunos(nomea, idade, codc) values ('augusto', 24, 2);


create table Matriculas
(coda int not null,
codd int not null,
nota int not null,
primary key (coda, codd),
foreign key (coda) references Alunos(coda),
foreign key (codd) references Disciplinas(codd));

insert into Matriculas(coda, codd, nota) values (1,1,10);
insert into Matriculas(coda, codd, nota) values (1,2,8);
insert into Matriculas(coda, codd, nota) values (1,3,7);
insert into Matriculas(coda, codd, nota) values (2,1,7);
insert into Matriculas(coda, codd, nota) values (2,2,5);
insert into Matriculas(coda, codd, nota) values (2,3,7);
insert into Matriculas(coda, codd, nota) values (3,1,8);
insert into Matriculas(coda, codd, nota) values (3,2,8);
insert into Matriculas(coda, codd, nota) values (4,5,7);
insert into Matriculas(coda, codd, nota) values (4,6,10);
insert into Matriculas(coda, codd, nota) values (5,5,10);
insert into Matriculas(coda, codd, nota) values (5,6,10);


select * from Matriculas;
select * from Alunos;
select * from Disciplinas;
select * from Cursos;

select * from Matriculas
NATURAL JOIN Alunos
NATURAL JOIN Disciplinas
NATURAL JOIN Cursos;

-- Question 1
-- Considering professor Tereza, show the number of courses (disciplinas), the total of credits on her courses,
-- and the average of credits. 


-- Considerando a professora tereza,  o número de suas disciplinas (i.e. disciplinas sob sua
--responsabilidade), o total de créditos de suas disciplinas, e a média de créditos de suas
--disciplinas

select professor, count(codd) as TotDisciplinas, sum(creditos) as TotCreditos, avg(creditos) as medCreditos from Disciplinas
group by professor
having professor = 'tereza';


-- Question 2
-- For each professor, show the professors name, the number of courses it teaches, the sum of its credits.
-- the average of credits. Order the professors by name.

-- Questão 2
-- Para cada professor, o nome do professor, o número de disciplinas que ministra, o total de
--créditos de suas disciplinas, e a média de créditos de suas disciplinas. Ordenar professores
--alfabeticamente.

select professor, count(codd) as TotDisciplinas, sum(creditos) as TotCreditos, avg(creditos) as medCreditos from Disciplinas
group by professor
order by professor;

-- Questão 3
--Para o conjunto das disciplinas de cálculo (ex: calculo I, calculo I, calculo numerico, etc), o
--número de disciplinas e de professores

-- Question 3
-- for the set of calculus courses (Cálculo in portuguese), show the number of courses and number of speakers (professores).

select count(distinct codd) as TotDisciplinas, count(distinct professor) as totprofessores from Disciplinas
where nomed like 'calculo%';
                                                   
                        



-- Question 4
-- For each professor, show its name, the total of courses under its responsability,
-- the number of enrolled students , and the total number of different students enrolled. Order it by professor's name.


SELECT professor, count(Disciplinas.codd) as NroDisciplinas, count(coda) as NroMatriculas, count(distinct coda) as Alunos FROM Disciplinas
LEFT JOIN Matriculas ON Disciplinas.codd = Matriculas.codd
GROUP BY professor
ORDER BY professor


-- questao 5

-- For each student named Maria, the number of courses enrolled, its min/max/average marks
-- and the number of different professors she is studing under.


SELECT nomea as Nome, count(codd), max(nota) as max, min(nota) min, count(distinct professor) from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
GROUP BY nomea
HAVING nomea = 'maria';

-- questao 6


-- For each student of the cic course (computer science/ Ciência da Computação), show its average marks,
-- the number of different professors it studied under, the number of courses enrolled, its average mark.


--Para cada aluno do curso cic, seu nome, o número de disciplinas na qual se matriculou, sua
-- nota média, e o número de professores que teve

SELECT nomea as Nome, count(codd), max(nota) as max, min(nota) min, count(distinct professor) from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
GROUP BY nomea, codc
HAVING codc = 1;

-- questao 7

-- Students(by name) that always had marks greater or equal to 8.

-- O nome dos alunos que sempre tiveram no mínimo nota 8 nas disciplinas nas quais se
-- matricularam;

SELECT distinct nomea as Nome from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
WHERE nota > 8

-- questao 8

-- Consider courses with for credits or more, the name of the professor, the course, but with the smaller grade being 
-- no lesser than four, and the average mark of 8,5 or higher.

--Considerando apenas disciplinas de 4 créditos ou mais, o nome do professor e da disciplina,
--desde a nota mínima dos alunos matriculados tenha 7 ou superior, e a média, 8,5 ou
--superior
SELECT professor, nomed FROM Disciplinas
NATURAL JOIN Matriculas
GROUP BY professor, nomed, creditos, nota
having creditos >= 4 and nota >= 7 and avg(nota) >= 8.5;

-- Questão 9
-- Show the courses with at least 3 students (alunos)

-- O nome das disciplinas com pelo menos 3 alunos matriculados
SELECT nomed as Disciplinas FROM disciplinas
NATURAL JOIN Matriculas
GROUP BY nomed
having count(distinct coda) >= 3;




-- Questão 10
-- Show studant's (by name) that never repetead a grade on a course and show what courses they have finished.


--  O nome dos alunos que nunca tiraram notas iguais nas disciplinas nas quais se
-- matricularam;
SELECT distinct nomea as Nome FROM alunos
NATURAL JOIN matriculas
GROUP BY nomea
having count(distinct nota) > 1
ORDER BY nomea

-- Questão 11
-- Show the name of students that graded with the same value.
-- O nome dos alunos que sempre tiram a mesma nota;
SELECT distinct nomea as Nome FROM alunos
NATURAL JOIN matriculas
GROUP BY nomea
having count(distinct nota) = 1
ORDER BY nomea
