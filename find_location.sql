\prompt 'Enter table name: ' table_name
SET val.name = :'table_name';
DO $$
DECLARE
    my_table_name VARCHAR(255);
    table_oid oid;
    items RECORD;
BEGIN
    SELECT current_setting('val.name') INTO my_table_name;
    SELECT oid INTO table_oid 
    FROM pg_catalog.pg_class c
    WHERE c.relname = my_table_name
    AND c.relkind = 'r'
    AND pg_catalog.pg_table_is_visible(c.oid);

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Table "%" does not exist.', my_table_name;
    END IF;

    FOR items IN 
        SELECT pg_relation_filepath(reltoastrelid) AS toast_file_path, pg_relation_filepath(table_oid) AS table_file_path, spcname AS tablespace
        FROM pg_class c LEFT JOIN pg_tablespace t ON table_oid=t.oid WHERE relname = my_table_name
        LOOP
            RAISE NOTICE 'toast_file_path: %, table_file_path: %, tablesapce: %', items.toast_file_path, items.table_file_path, items.tablespace;
        END LOOP;       
END $$;