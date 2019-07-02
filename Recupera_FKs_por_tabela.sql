use Agricola
go

DECLARE @object_ID INT
SELECT @object_ID=object_id('pedido')

SELECT object_name(fk.parent_object_ID) + ' }-- ' + object_name(fk.referenced_object_ID) AS FKs
FROM sys.foreign_keys fk
INNER JOIN sys.objects o ON fk.object_id = o.object_id
WHERE fk.parent_object_ID = @object_ID or fk.referenced_object_ID = @object_ID;