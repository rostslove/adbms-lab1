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
        SELECT pg_relation_filepath(quote_ident(tablename)) AS table_file_path, tablespace
        FROM pg_tables WHERE tablename = my_table_name
        LOOP
            RAISE NOTICE 'table_file_path: %, tablespace: %', items.table_file_path, items.tablespace;
        END LOOP;       
END $$;