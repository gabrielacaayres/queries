-- alterar o SQL Server para permitir um maior número máximo de caracteres exibidos em cada coluna
-- Consulta --> Opções de consulta --> Resultados --> Texto --> Número máximo de caracteres exibidos em cada coluna = 5000
-- A saída deverá estar como Resultado em texto

use GPC
go

select 'class ' + tb.name + ' {' + char(10) + left(ac.listcols,len(ac.listcols)) + '}' + char(10) as lista
from 
sys.objects tb
cross apply (
	SELECT 
		case when (select count(*) as qt
		from 
			sys.indexes as i
			inner join sys.index_columns as ic
			on 
				i.object_id = ic.object_id and
				i.index_id = ic.index_id
		where
			i.is_primary_key = 1 and
			i.object_id = t.object_id and
			ic.column_id = c.column_id) = 1 then '#' else '' end,
			
		c.name +
		' : ' + 
		y.name + 
		case
			when c.user_type_id = '106' then   -- decimal
				' (' + ltrim(str(c.precision)) + ', ' + ltrim(str(c.scale)) + ') '
			when c.user_type_id = '231' and c.max_length = '-1' then   -- nvarchar
				' (max) '
			when c.user_type_id = '231' and c.max_length <> '-1' then   -- nvarchar
				' (' + ltrim(str(c.max_length/2)) + ') '
			when c.user_type_id = '239' then   -- nchar
				' (' + ltrim(str(c.precision)) + ') '
			when c.user_type_id = '175' then   -- char
				' (' + ltrim(str(c.max_length)) + ') '
			when c.user_type_id = '173' then   -- binary
				' (' + ltrim(str(c.max_length)) + ') '
			when c.user_type_id = '108' then   -- numeric
				' (' + ltrim(str(c.precision)) + ') '
			when c.user_type_id = '167' and c.max_length = '-1' then   -- varchar
				' (max) '
			when c.user_type_id = '167' and c.max_length <> '-1' then   -- varchar
				' (' + ltrim(str(c.max_length)) + ') '
			when c.user_type_id = '42' then    -- datetime2
				' (7) '
			else
				' '
		end
		+  
		case c.is_nullable
			when 0 then
				'NOT NULL'
			when 1 then
				'NULL'
		end
		+ char(10) 
		FROM        sys.objects t
		INNER JOIN  sys.columns c ON c.object_id = t.object_id
		INNER JOIN  sys.types   y ON c.user_type_id = y.user_type_id
		INNER JOIN  sys.schemas s ON t.schema_id = s.schema_id
		WHERE t.type = 'u' AND t.name = tb.name
		ORDER BY    t.name, c.column_id for xml path ('')) as ac(listcols)
where tb.type = 'u';