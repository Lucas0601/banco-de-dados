-- ---------------------------------------------------------------------------
-- Buscar o nome dos funcionários que terminam com a letra “a”
SELECT nome
FROM funcionarios
WHERE nome LIKE '%o';


-- ---------------------------------------------------------------------------
-- Buscar o nome e a especialidade dos médicos cuja 
-- segunda e a última letra de seus nomes seja a letra “o”
SELECT 
	nome,
	especialidade
FROM medicos
WHERE nome LIKE '_o%o';


-- ---------------------------------------------------------------------------
-- Buscar os códigos e nomes dos pacientes com mais de 
-- 25 anos que estão com tendinite, fratura,gripe ou sarampo
SELECT 
	cod_p, 
	nome,
	idade,
	doenca
FROM pacientes
WHERE 
  idade > 25
  AND (
    	doenca = 'tendinite'
    	OR doenca = 'fratura'
    	OR doenca = 'gripe'
    	OR doenca = 'sarampo'
  );


-- ---------------------------------------------------------------------------
-- Buscar os CPFs, nomes e idades de todas as pessoas
-- (médicos, pacientes ou funcionários) que residem em Florianópolis 
SELECT 
	cpf,
	nome,
	idade,
	cidade
FROM 
	(
		SELECT 
			cpf,
		    nome,
		  	idade,
		  	cidade
		FROM pacientes
        
		UNION
		
		SELECT 
		  	cpf,
		  	nome,
		  	idade,
		  	cidade
		FROM funcionarios
        
		UNION
	
		SELECT 
		  	cpf,
		  	nome,
		  	idade,
		  	cidade
		FROM medicos
	) AS todas_pessoas
WHERE cidade = 'florianopolis';


-- ---------------------------------------------------------------------------
--JOIN!
-- Buscar o número e o andar dos ambulatórios utilizados por médicos ortopedistas
SELECT 
	ambulatorios.nroa,
	ambulatorios.andar
FROM 
  ambulatorios JOIN medicos ON ambulatorios.nroa = medicos.nroa
WHERE medicos.nroa=1;


-- ---------------------------------------------------------------------------
-- Retornar pares (código, nome) de funcionários e
-- de médicos que residem na mesma cidade (tabela resultado
-- deve ter 4 atributos)
SELECT 
	funcionarios.cod_f,
	funcionarios.nome,
	medicos.cod_m,
	medicos.nome
FROM 
  	funcionarios JOIN medicos ON funcionarios.cidade = medicos.cidade;


-- ---------------------------------------------------------------------------
-- Buscar o código e nome dos médicos que possuem consultas 
-- marcadas para antes das 12 horas e possuem idade inferior à idade do médico Pedro

-- parte 01: código e nome dos médicos que possuem consultas marcadas para antes das 12 horas
SELECT 
	medicos.cod_m,
	medicos.nome
FROM
	medicos JOIN consultas ON medicos.cod_m = consultas.cod_m
WHERE 
  hora < '1200';


-- parte 02: idade do médico Pedro
SELECT idade 
FROM medicos 
WHERE nome = 'pedro';

-- parte 03: tudo
SELECT 
	medicos.cod_m,
	medicos.nome
FROM 
	medicos JOIN consultas ON medicos.cod_m = consultas.cod_m
WHERE 
	hora < '1200'
	AND idade < (
		SELECT idade 
        FROM medicos 
        WHERE nome = 'pedro'
	);


-- ---------------------------------------------------------------------------
-- Buscar o nome e o salário dos funcionários que moram na mesma 
-- cidade do funcionário caio e possuem salário superior ao dele

-- parte 01: nome e o salário dos funcionários que moram na mesma cidade do funcionário Caio
SELECT 
	nome,
	salario
FROM funcionarios
WHERE cidade = (
	SELECT cidade 
    FROM funcionarios 
    WHERE nome='caio'
);

-- parte 02: tudo
SELECT 
	nome,
	salario
FROM funcionarios
WHERE 
  cidade = (
	  SELECT cidade 
      FROM funcionarios 
      WHERE nome='caio'
  ) AND salario > (
	  SELECT salario
      FROM funcionarios 
      WHERE nome = 'caio'
  );


-- ---------------------------------------------------------------------------
-- Buscar o código, nome e data dos pacientes com consulta marcada para horários após às 14 horas
SELECT 
	pacientes.cod_p,
	pacientes.nome,
	consultas.data
FROM 
	pacientes JOIN consultas ON pacientes.cod_p=consultas.cod_p
WHERE hora > '1400';


-- ---------------------------------------------------------------------------
-- Buscar o número e o andar dos ambulatórios cujos 
-- médicos possuem consultas marcadas para o dia 12/10/2016
SELECT 
	ambulatorios.nroa,
	ambulatorios.andar
FROM 
	ambulatorios NATURAL JOIN consultas
WHERE data='2016-10-12';


-- ---------------------------------------------------------------------------
-- Buscar o nome, CPF e especialidade dos médicos que 
-- possuem consultas marcadas com pacientes que estão com tendinite
SELECT 
	medicos.nome,
	medicos.cpf,
	especialidade
FROM 
	medicos JOIN consultas ON medicos.codm=consultas.codm
	     	JOIN pacientes ON consultas.codp=pacientes.codp
WHERE doenca='tendinite';


-- ---------------------------------------------------------------------------
-- Buscar os dados de todos os ambulatórios e para aqueles 
-- ambulatórios onde médicos dão atendimento, exibir também os seus códigos e nomes
SELECT 
	ambulatorios.nroa,
 	ambulatorios.andar,
  	ambulatorios.capacidade,
  	medicos.cod_m AS codigo_medico,
  	medicos.nome AS nome_medico
FROM 
  	ambulatorios JOIN medicos ON ambulatorios.nroa=medicos.nroa;


-- ---------------------------------------------------------------------------
-- Buscar o CPF e o nome de todos os médicos e, para aqueles médicos com
-- consultas marcadas, exibir os CPFs e nomes dos seus pacientes e as datas das consultas
SELECT 
  	medicos.cpf,
  	medicos.nome,
  	pacientes.cpf,
  	pacientes.nome,
  	consultas.data
FROM 
  medicos JOIN consultas ON medicos.cod_m=consultas.cod_m 
  		  FULL JOIN pacientes ON consultas.cod_p=pacientes.cod_p;
