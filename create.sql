CREATE TABLE H_PEOPLE (
    ID            INT PRIMARY KEY,
    LAST_NAME     VARCHAR(25) NOT NULL,
    FIRST_NAME    VARCHAR(2000) NOT NULL,
    MIDDLE_NAME   VARCHAR(20),
    BIRTH_DATE    DATE NOT NULL,
    GENDER        CHAR(1) NOT NULL
                      CONSTRAINT "AVCON_378561_GENDER_000" CHECK (GENDER IN ('M', 'F'))
                      CONSTRAINT "AVCON_388176_GENDER_000" CHECK (GENDER IN ('M', 'F')),
    FOREIGNER     VARCHAR(3) NOT NULL,
    CREATED_BY    VARCHAR(40) NOT NULL,
    CREATED_DATE  DATE NOT NULL,
    UPDATED_BY    VARCHAR(40) NOT NULL,
    UPDATED_DATE  DATE NOT NULL,
    DEATH_DATE    DATE,
    PIN           VARCHAR(20),
    INN           VARCHAR(20)
);
COMMENT ON TABLE H_PEOPLE IS 'Table with information about people';
COMMENT ON COLUMN H_PEOPLE.ID IS 'Unique person identifier';
COMMENT ON COLUMN H_PEOPLE.LAST_NAME IS 'Last name of the person';
COMMENT ON COLUMN H_PEOPLE.FIRST_NAME IS 'First name of the person';
COMMENT ON COLUMN H_PEOPLE.MIDDLE_NAME IS 'Middle name of the person';
COMMENT ON COLUMN H_PEOPLE.BIRTH_DATE IS 'Birth date of the person';
COMMENT ON COLUMN H_PEOPLE.GENDER IS 'Gender of the person (M/F)';
COMMENT ON COLUMN H_PEOPLE.FOREIGNER IS 'Foreigner (Yes/No)';
COMMENT ON COLUMN H_PEOPLE.CREATED_BY IS 'Person who created the record';
COMMENT ON COLUMN H_PEOPLE.CREATED_DATE IS 'Date when the record was created';
COMMENT ON COLUMN H_PEOPLE.UPDATED_BY IS 'Person who updated the record';
COMMENT ON COLUMN H_PEOPLE.UPDATED_DATE IS 'Date when the record was updated';
COMMENT ON COLUMN H_PEOPLE.DEATH_DATE IS 'Death date of the person (if applicable)';
COMMENT ON COLUMN H_PEOPLE.PIN IS 'Personal identification number of the person';
COMMENT ON COLUMN H_PEOPLE.INN IS 'Taxpayer identification number of the person';