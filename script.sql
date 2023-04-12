\prompt 'Enter table name: ' table_name
SET val.name = :'table_name';
DO $$
DECLARE
    my_table_name VARCHAR(255); 
    table_oid oid;
    column_info RECORD;
    constraint_info RECORD;
    result text;
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

    result := format('%-3s %-15s %-40s', 'No.', 'Имя столбца', 'Атрибуты');
    RAISE NOTICE '%', result;
    RAISE NOTICE '--- --------------- ------------------------------------------------------';
    FOR column_info IN 
        SELECT a.attnum, 
               a.attname,
               format_type(a.atttypid, a.atttypmod),
               a.attnotnull, 
               coalesce(array_agg(pg_get_constraintdef(con.oid)), '{}'::text[]),
               pd.description
        FROM pg_catalog.pg_attribute a LEFT JOIN pg_catalog.pg_constraint con
            ON con.conrelid = a.attrelid AND con.conkey[1] = a.attnum 
            AND con.contype = 'c'
            LEFT JOIN pg_catalog.pg_description pd
            ON pd.objoid = a.attrelid AND pd.objsubid = a.attnum
        WHERE a.attrelid = table_oid AND a.attnum > 0 
        GROUP BY a.attnum, a.attname, a.atttypid, a.atttypmod, a.attnotnull, pd.description
        ORDER BY a.attnum
    LOOP
        result := format('%-3s %-15s Type: %-8s %-8s', column_info.attnum, column_info.attname, column_info.format_type, CASE WHEN column_info.attnotnull THEN '' ELSE 'NOT NULL' END);
        RAISE NOTICE '%', result;
        IF column_info.coalesce[1] != '{}' THEN
            FOR constraint_info IN 
                SELECT unnest(column_info.coalesce) AS condef
                WHERE column_info.coalesce IS NOT NULL AND array_length(column_info.coalesce, 1) > 0
                ORDER BY 1
            LOOP
                RAISE NOTICE '                    Constr: %', constraint_info.condef;
            END LOOP;
        END IF;
        IF column_info.description IS NOT NULL THEN
            RAISE NOTICE '                    Comment: %', column_info.description;
        END IF;	
    END LOOP;
END $$;