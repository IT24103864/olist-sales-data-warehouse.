USE OlistDW;
GO

SELECT
    parent_table.name AS fact_table,
    fk.name AS foreign_key,
    parent_column.name AS fact_column,
    referenced_table.name AS dimension_table,
    referenced_column.name AS dimension_column
FROM sys.foreign_keys AS fk
JOIN sys.foreign_key_columns AS fkc
    ON fkc.constraint_object_id = fk.object_id
JOIN sys.tables AS parent_table
    ON parent_table.object_id = fk.parent_object_id
JOIN sys.columns AS parent_column
    ON parent_column.object_id = fkc.parent_object_id
   AND parent_column.column_id = fkc.parent_column_id
JOIN sys.tables AS referenced_table
    ON referenced_table.object_id = fk.referenced_object_id
JOIN sys.columns AS referenced_column
    ON referenced_column.object_id = fkc.referenced_object_id
   AND referenced_column.column_id = fkc.referenced_column_id
WHERE SCHEMA_NAME(parent_table.schema_id) = 'dw'
ORDER BY parent_table.name, fk.name;