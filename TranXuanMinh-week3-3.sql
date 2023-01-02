-- BAI 1
-- Cau 1_1
CREATE OR REPLACE PROCEDURE dept_info
(dept_id IN DEPARTMENTS.DEPARTMENT_ID%TYPE)
AS
    p_dept_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;
    p_manag_name EMPLOYEES.FIRST_NAME%TYPE;
    p_locat_city LOCATIONS.CITY%TYPE;
BEGIN
    SELECT DEPARTMENT_NAME, (FIRST_NAME || ' ' || LAST_NAME) AS FULL_NAME, CITY
    INTO p_dept_name, p_manag_name, p_locat_city
    FROM DEPARTMENTS D
        LEFT JOIN EMPLOYEES USING(MANAGER_ID)
        LEFT JOIN LOCATIONS USING(LOCATION_ID)
    WHERE D.DEPARTMENT_ID = dept_id;
    DBMS_OUTPUT.PUT_LINE('DEPARTMENT_NAME: ' || p_dept_name);
    DBMS_OUTPUT.PUT_LINE('FULL_NAME OF THE MANAGER: ' || p_manag_name);
    DBMS_OUTPUT.PUT_LINE('CITY: ' || p_locat_city);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID ' || dept_id || ' DOES NOT EXIST');
END;

--Executing   
DECLARE 
    department_id NUMBER := 10;
BEGIN
    dept_info(department_id);
END;

    
-- Cau 1_2
CREATE OR REPLACE PROCEDURE add_job 
(
    p_job_id IN JOBS.JOB_ID%TYPE, 
    p_job_title IN JOBS.JOB_TITLE%TYPE
)
IS 
BEGIN
    INSERT INTO JOBS(JOB_ID, JOB_TITLE) VALUES(id, name);
END;   

--Executing   
BEGIN
    add_job('PHP_PGM', 'PHP programmer');
END;


-- Cau 1_3
CREATE OR REPLACE PROCEDURE update_comm
(
    p_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
)
IS BEGIN 
    UPDATE EMPLOYEES
    SET COMMISSION_PCT = COMMISSION_PCT*1.05
    WHERE EMPLOYEE_ID = p_employee_id
    AND COMMISSION_PCT IS NOT NULL;
END;
    
--Executing   
BEGIN
    update_comm(100);
    update_comm(145);
END;


-- Cau 1_4
CREATE OR REPLACE PROCEDURE add_emp
(
    p_first_name IN EMPLOYEES.FIRST_NAME%TYPE,
    p_last_name IN EMPLOYEES.LAST_NAME%TYPE,
    p_email IN EMPLOYEES.EMAIL%TYPE,
    p_phone_number IN EMPLOYEES.PHONE_NUMBER%TYPE,
    p_hire_date IN EMPLOYEES.HIRE_DATE%TYPE,
    p_job_id IN EMPLOYEES.JOB_ID%TYPE,
    p_salary IN EMPLOYEES.SALARY%TYPE,
    p_commission_pct IN EMPLOYEES.COMMISSION_PCT%TYPE DEFAULT NULL,
    p_manager_id IN EMPLOYEES.MANAGER_ID%TYPE DEFAULT NULL,
    p_department_id IN EMPLOYEES.DEPARTMENT_ID%TYPE
)
IS 
        p_employee_id EMPLOYEES.EMPLOYEE_ID%TYPE;
BEGIN
    SELECT EMPLOYEES_SEQ.NEXTVAL INTO p_employee_id FROM DUAL;
    
    INSERT INTO EMPLOYEES 
    VALUES 
    (   
        p_employee_id,
        p_first_name, 
        p_last_name, 
        p_email, 
        p_phone_number, 
        p_hire_date, 
        p_job_id, 
        p_salary, 
        p_commission_pct, 
        p_manager_id, 
        p_department_id
    );
END;

--Executing   
BEGIN
    add_emp(
        'Minh',
        'TXM',
        'hehe@gm.com',
        1234,
        TO_DATE('2-1-2023', 'dd-mm-yyyy'),
        'ST_MAN',
        150000,
        0.8,
        100,
        110
    );
END;


-- Cau 1_5
CREATE OR REPLACE PROCEDURE delete_emp
(
    p_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
)
IS
    NO_DATA_DELETE EXCEPTION;
    PRAGMA exception_init(NO_DATA_DELETE, -20001);
BEGIN
    DELETE FROM EMPLOYEES
    WHERE EMPLOYEE_ID = p_employee_id;
    IF SQL%ROWCOUNT = 0 THEN 
        RAISE NO_DATA_DELETE;
    END IF;
EXCEPTION
    WHEN NO_DATA_DELETE THEN
        DBMS_OUTPUT.PUT_LINE('No record deleted');    
END;

--Executing   
BEGIN
    delete_emp(1000);
END;


-- Cau 1_6

CREATE OR REPLACE PROCEDURE find_emp
IS    
    CURSOR c_employees
    IS
        SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, SALARY
        FROM EMPLOYEES 
        JOIN JOBS USING (JOB_ID)
        WHERE
            SALARY > MIN_SALARY AND SALARY < MAX_SALARY
        ORDER BY 6;
    
    r_employees c_employees%ROWTYPE;
BEGIN
    OPEN c_employees;
    LOOP
        FETCH c_employees INTO r_employees;
        EXIT WHEN c_employees%NOTFOUND; 
        DBMS_OUTPUT.PUT_LINE(
            'EMPLOYEE_ID: ' || r_employees.EMPLOYEE_ID ||
            ' FIRST_NAME: ' || r_employees.FIRST_NAME ||
            ' LAST_NAME: ' || r_employees.LAST_NAME ||
            ' EMAIL: ' || r_employees.EMAIL ||
            ' PHONE_NUMBER: ' || r_employees.PHONE_NUMBER ||
            ' SALARY: ' || r_employees.SALARY
        );
    END LOOP;
    CLOSE c_employees;    
END;

-- Executing
BEGIN
    find_emp;
END;


-- Cau 1_7
CREATE OR REPLACE PROCEDURE update_comm    
IS
    update_employees VARCHAR2(500);
BEGIN    
    update_employees := '
        UPDATE EMPLOYEES 
        SET SALARY = CASE
                        WHEN MONTHS_BETWEEN(sysdate, HIRE_DATE) > 2*12 THEN SALARY + 200
                        WHEN MONTHS_BETWEEN(sysdate, HIRE_DATE) < 2*12  AND MONTHS_BETWEEN(sysdate, HIRE_DATE) > 12 THEN SALARY + 100
                        WHEN MONTHS_BETWEEN(sysdate, HIRE_DATE) = 12 THEN SALARY + 50
                     END';
    
    EXECUTE IMMEDIATE update_employees;
END;

-- Executing
BEGIN
    update_comm;
END;


-- Cau 1_8
CREATE OR REPLACE PROCEDURE job_his
(
    p_employee_id IN JOB_HISTORY.EMPLOYEE_ID%TYPE
)
IS
    p_start_date JOB_HISTORY.START_DATE%TYPE;
    p_end_date JOB_HISTORY.END_DATE%TYPE;
    p_job_title JOBS.JOB_TITLE%TYPE;
    P_department_name DEPARTMENTS.DEPARTMENT_NAME%TYPE;   
BEGIN
    SELECT START_DATE, END_DATE, JOB_TITLE, DEPARTMENT_NAME
    INTO p_start_date, p_end_date, p_job_title, P_department_name
    FROM JOB_HISTORY 
    LEFT JOIN JOBS USING (JOB_ID)
    LEFT JOIN DEPARTMENTS USING (DEPARTMENT_ID)
    WHERE EMPLOYEE_ID = p_employee_id;
    
    DBMS_OUTPUT.PUT_LINE('START_DATE: ' || p_start_date);
    DBMS_OUTPUT.PUT_LINE('END_DATE: ' || p_end_date);
    DBMS_OUTPUT.PUT_LINE('JOB_TITLE: ' || p_job_title);
    DBMS_OUTPUT.PUT_LINE('DEPARTMENT_NAME: ' || p_department_name);
EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('DEPARTMENT_ID: ' || p_employee_id || 'DOES NOT EXIST');
END;

-- Executing
BEGIN 
    job_his(102);
    job_his(1000);
END;

-- BAI 2
-- Cau 2_1
CREATE OR REPLACE FUNCTION sum_salary
(
    f_department_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
)
RETURN NUMBER
IS
    f_sum_money EMPLOYEES.SALARY%TYPE;
BEGIN 
    SELECT SUM(SALARY)
    INTO f_sum_money
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = f_department_id;
RETURN f_sum_money;
END;

-- Executing

SELECT DEPARTMENT_NAME, sum_salary(110) AS SUM_SALARY
FROM DEPARTMENTS
WHERE DEPARTMENT_ID = 110;

-- Cau 2_2

CREATE OR REPLACE FUNCTION name_con
(
    f_country_id IN COUNTRIES.COUNTRY_ID%TYPE
)
RETURN COUNTRIES.COUNTRY_NAME%TYPE
IS
    f_country_name COUNTRIES.COUNTRY_NAME%TYPE;
BEGIN
    SELECT COUNTRY_NAME 
    INTO f_country_name
    FROM COUNTRIES
    WHERE COUNTRY_ID = f_country_id;
RETURN f_country_name;
END;

-- Executing
SELECT name_con('US')
FROM DUAL;


-- Cau 2_3
CREATE OR REPLACE FUNCTION annual_comp
(
    f_salary IN EMPLOYEES.SALARY%TYPE,
    f_comp IN EMPLOYEES.COMMISSION_PCT%TYPE
)
RETURN EMPLOYEES.SALARY%TYPE
IS
    f_annual_comp EMPLOYEES.SALARY%TYPE;
BEGIN
    IF f_comp IS NOT NULL THEN
        f_annual_comp := f_salary*12 + (f_comp*f_salary*12);
    ELSE 
        f_annual_comp := f_salary*12;
    END IF;    
RETURN f_annual_comp;
END;

-- Executing
SELECT (FIRST_NAME || ' ' || LAST_NAME) AS FULL_NAME, annual_comp(SALARY, COMMISSION_PCT)
FROM EMPLOYEES;


-- Cau 2_4
CREATE OR REPLACE FUNCTION avg_salary
(
    f_department_id IN DEPARTMENTS.DEPARTMENT_ID%TYPE
)
RETURN EMPLOYEES.SALARY%TYPE
IS 
    f_avg_salary EMPLOYEES.SALARY%TYPE;
BEGIN
    SELECT AVG(SALARY)
    INTO f_avg_salary
    FROM DEPARTMENTS
    JOIN EMPLOYEES USING (DEPARTMENT_ID)
    WHERE DEPARTMENT_ID = f_department_id;
RETURN f_avg_salary;
END;

-- Executing
SELECT DEPARTMENT_NAME, avg_salary(DEPARTMENT_ID)
FROM DEPARTMENTS;

-- Cau 2_5
CREATE OR REPLACE FUNCTION time_work
(
    f_employee_id IN EMPLOYEES.EMPLOYEE_ID%TYPE
)
RETURN NUMBER
IS 
    f_month NUMBER;
BEGIN
    SELECT CEIL(MONTHS_BETWEEN(sysdate, HIRE_DATE))
    INTO f_month
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = f_employee_id;
RETURN f_month;
END;

-- Execting
SELECT (FIRST_NAME || ' ' || LAST_NAME) AS FULL_NAME, time_work(EMPLOYEE_ID) AS TIME_WORK
FROM EMPLOYEES;


-- BAI 3
-- Cau 3_1
CREATE OR REPLACE TRIGGER EMPLOYEES_BEFORE_INSERT_UPDATE
    BEFORE INSERT OR UPDATE OF HIRE_DATE
    ON EMPLOYEES
    FOR EACH ROW
    WHEN (NEW.HIRE_DATE > SYSDATE)
BEGIN
    RAISE_APPLICATION_ERROR(-20001, 'HIRE DATE MUST BE LESS THAN OR EQUAL TO CURRENT DATE!');
END;

-- Executing
INSERT INTO EMPLOYEES(FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE)
VALUES ('Minh', 'Txm', 'hihi123@gm.com', '0344', TO_DATE('1/6/2023', 'dd/mm/yyyy'));


-- Cau 3_2
CREATE OR REPLACE TRIGGER SALARY_BEFORE_INSERT_UPDATE
    BEFORE UPDATE OR INSERT
    ON JOBS
    FOR EACH ROW
    WHEN (NEW.MIN_SALARY > NEW.MAX_SALARY)
BEGIN
    RAISE_APPLICATION_ERROR(-20002, 'MIN SALARY MUST BE LESS THAN MAX SALARY!');
END;

-- Executing
INSERT INTO JOBS
VALUES (23, 'JAVA Backend', 10000, 2000);


-- Cau 3_3
CREATE OR REPLACE TRIGGER JOB_HIS_BEFORE_INSERT_UPDATE
    BEFORE INSERT OR UPDATE
    ON JOB_HISTORY
    FOR EACH ROW
    WHEN (NEW.START_DATE > NEW.END_DATE)
BEGIN
    RAISE_APPLICATION_ERROR(-20003, 'START DATE MUST BE LESS THAN OR EQUAL TO END DATE!');
END;

-- Executing
UPDATE JOB_HISTORY
SET START_DATE = TO_DATE('1/6/2023', 'dd/mm/yyyy'),
    END_DATE = TO_DATE('12/12/2022', 'dd/mm/yyyy')
WHERE EMPLOYEE_ID = 102;


-- Cau 3-4
CREATE OR REPLACE TRIGGER SALARY_COMMPCT_BEFORE_UPDATE
    BEFORE UPDATE 
    ON EMPLOYEES
    FOR EACH ROW
    WHEN (NEW.SALARY < OLD.SALARY OR NEW.COMMISSION_PCT < OLD.COMMISSION_PCT)
BEGIN
    RAISE_APPLICATION_ERROR(-20004, 'SALARY AND COMMISSION PERCENT MUST INCREASE WHEN UPDATING!');
END;

-- Executing
UPDATE EMPLOYEES
SET SALARY = 10000, COMMISSION_PCT = 0.5
WHERE EMPLOYEE_ID = 102;
