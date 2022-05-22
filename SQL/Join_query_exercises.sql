-- VINICIUS RORATTO CARVALH0 -- 160094
-- EX16

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

-- Questão 1
-- Considerando a professora tereza, o número de suas disciplinas (i.e. disciplinas sob sua
--responsabilidade), o total de créditos de suas disciplinas, e a média de créditos de suas
--disciplinas

select professor, count(codd) as TotDisciplinas, sum(creditos) as TotCreditos, avg(creditos) as medCreditos from Disciplinas
group by professor
having professor = 'tereza';

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

select count(distinct codd) as TotDisciplinas, count(distinct professor) as totprofessores from Disciplinas
where nomed like 'calculo%';
                                                   
                        
-- questao 4
--Para cada professor, mostrar seu nome, o número de disciplinas sob sua responsabilidade
--(mesmo que não existam alunos matriculados nelas), número total de matriculas nestas
--disciplinas, e número total alunos (distintos) envolvidos (ordenar por nome de professor)

SELECT professor, count(Disciplinas.codd) as NroDisciplinas, count(coda) as NroMatriculas, count(distinct coda) as Alunos FROM Disciplinas
LEFT JOIN Matriculas ON Disciplinas.codd = Matriculas.codd
GROUP BY professor
ORDER BY professor


-- questao 5
--Para a aluna de nome maria, o numero de matriculas, notas mínima/máxima/média, e
--número de distintos professores que tem.

SELECT nomea as Nome, count(codd), max(nota) as max, min(nota) min, count(distinct professor) from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
GROUP BY nomea
HAVING nomea = 'maria';

-- questao 6
--Para cada aluno do curso cic, seu nome, o número de disciplinas na qual se matriculou, sua
-- nota média, e o número de professores que teve

SELECT nomea as Nome, count(codd), max(nota) as max, min(nota) min, count(distinct professor) from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
GROUP BY nomea, codc
HAVING codc = 1;

-- questao 7
-- O nome dos alunos que sempre tiveram no mínimo nota 8 nas disciplinas nas quais se
-- matricularam ;
SELECT distinct nomea as Nome from Alunos
NATURAL JOIN Matriculas
NATURAL JOIN Disciplinas
WHERE nota > 8

-- questao 8
--Considerando apenas disciplinas de 4 créditos ou mais, o nome do professor e da disciplina,
--desde a nota mínima dos alunos matriculados tenha 7 ou superior, e a média, 8,5 ou
--superior
SELECT professor, nomed FROM Disciplinas
NATURAL JOIN Matriculas
GROUP BY professor, nomed, creditos, nota
having creditos >= 4 and nota >= 7 and avg(nota) >= 8.5;

-- Questão 9
-- O nome das disciplinas com pelo menos 3 alunos matriculados
SELECT nomed as Disciplinas FROM disciplinas
NATURAL JOIN Matriculas
GROUP BY nomed
having count(distinct coda) >= 3;




-- Questão 10
--  O nome dos alunos que nunca tiraram notas iguais nas disciplinas nas quais se
-- matricularam;
SELECT distinct nomea as Nome FROM alunos
NATURAL JOIN matriculas
GROUP BY nomea
having count(distinct nota) > 1
ORDER BY nomea

-- Questão 11
-- O nome dos alunos que sempre tiram a mesma nota;
SELECT distinct nomea as Nome FROM alunos
NATURAL JOIN matriculas
GROUP BY nomea
having count(distinct nota) = 1
ORDER BY nomea
