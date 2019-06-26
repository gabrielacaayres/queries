use Massificados
go

SELECT object_name(fk.parent_object_ID) + ' }-- ' + object_name(fk.referenced_object_ID) AS FKs
FROM sys.foreign_keys fk
INNER JOIN sys.objects o ON (fk.object_id = o.object_id)
INNER JOIN sys.schemas s ON (o.schema_id = s.schema_id)
WHERE s.name = 'dbo';