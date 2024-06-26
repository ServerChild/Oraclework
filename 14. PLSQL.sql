/*
    [ PL/SQL(PROCEDURAL LANGUAGE EXTENSTION TO SQL) ]
        - 오라클 자체에 내장되어 있는 절차적 언어
        
        - SQL문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE) 등을 지원하여 SQL 단점 보완
        
        - 다수의 SQL문을 한번에 실행 가능(BLOCK 구조)
        
    
    * PL/SQL 구조
        - [선언부(DECLARE SECTION)] : DECLARE로 시작, 변수나 상수를 선언 및 초기화하는 부분
        
        - 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, SQL문 또는 제어문(조건문, 반복문) 등의 로직을 기술하는 부분
        
        - [예외처리부(EXCEPTION SECTIONI)] : EXCEPTION으로 시작, 예외 발생시 해결하기 위한 구문을 미리 기술하는 부분
*/
--===========================================================================--
-- * 화면에 오라클을 출력(ON ↔ OFF시 반드시 실행해야 함) * --
SET SERVEROUTPUT ON;

-- HELLO ORACLE 출력
-- END + / : BEGIN문을 끝내려면 'END;' 과 '/'를 함께 써줘야 끝냄으로 인식함
BEGIN 
    -- System.out.println("hello oracle"); // 자바 출력
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/


--------------------------------------------------------------------------------
/*
    < DECLATE(선언부) >
        - 변수 및 상수 선언하는 공간(선언과 동시에 초기화 가능)
        - 일반 타입 변수, 레퍼런스타입 변수, ROW타입의 변수
*/
--== 일반타입 변수 선언 및 초기화 ==--
-- 표현식 : 변수명 [CONSTANT] 자료형 [:= 값];
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14; -- 상수
BEGIN
    EID := 500;
    ENAME := '장남일';
    
    -- System.out.println("EID : " + EID); // 자바 출력
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/

-- 사용자 입력 받아서 출력
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER := 3.14;
BEGIN
    EID := &번호;
    ENAME := '&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/


--== 레퍼런스타입 선언 및 초기화 ==--
-- 레퍼런스타입 : 어떤 테이블의 어떤 컬럼의 데이터타입을 참조해서 그 타입으로 지정
-- 표현식 : 변수명 테이블명.컬럼명%TYPE;
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := '300';
    ENAME := '가나다';
    SAL := 1000000;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
END;
/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    -- 사번이 200번인 사원의 사번, 사원명, 급여 조회해 변수 저장
--    SELECT EMP_ID, EMP_NAME, SALARY INTO EID, ENAME, SAL
--    FROM EMPLOYEE WHERE EMP_ID = 200;
    
    -- 입력받아 검색해 변수 저장
    SELECT EMP_ID, EMP_NAME, SALARY INTO EID, ENAME, SAL
    FROM EMPLOYEE WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('EID : ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || SAL);
END;
/

-- 문제 --
/*
    레퍼런스타입변수로 EID, ENAME, JCODE, SAL, DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY), 
    DEPARTMENT (DEPT_TITLE)들을 참조하도록
    
    사용자가 입력한 사번의 사원의 사번, 사원명, 직급코드, 급여, 부서명 조회 한 후 각 변수에 담아 출력
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
BEGIN
-- NULL 값 제외하고 JOIN 하기 때문에 DEPT_CODE가 NULL값인 사원은 조회x
--    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE,
--      INTO EID, ENAME, JCODE, SAL, DTITLE
--      FROM EMPLOYEE
--      JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
--      WHERE EMP_ID = &사번;
    
-- FULL JOIN으로 NULL 포함 JOIN를 해서 DEPT_CODE가 NULL값인 사원도 조회o
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY, DEPT_TITLE
      INTO EID, ENAME, JCODE, SAL, DTITLE
      FROM EMPLOYEE 
      FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
      WHERE EMP_ID = &사번;

    DBMS_OUTPUT.PUT_LINE('사번(EID) : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명(ENAME) : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('직급코드(JCODE) : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('급여(SAL) : ' || SAL);
    DBMS_OUTPUT.PUT_LINE('부서명(DTITLE) : ' || DTITLE);
END;
/


--== ROW타입 변수 선언 ==--
-- 테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수
-- 표현식 : 변수명 테이블명%ROWTYPE;

-- ROW타입 변수로 모든 값 출력
DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
        INTO EMP 
        FROM EMPLOYEE 
        WHERE EMP_ID = &사번; 
        
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || EMP.SALARY);
    
    -- NULL값이 빈값으로 출력
    -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || EMP.BONUS);
    
    -- 오류 : 타입이 맞지 않아서
    -- DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(EMP.BONUS, '없음'));
    
    -- NULL값은 0으로 출력
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(EMP.BONUS, 0));
END;
/

-- SELECT문에서 지정한 컬럼값만 출력(오류)
DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT EMP_NAME, SALARY, BONUS -- 무조건 *을 사용해야 함
        INTO EMP 
        FROM EMPLOYEE 
        WHERE EMP_ID = &사번; 
        
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || EMP.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(EMP.BONUS, 0));
END;
/


--------------------------------------------------------------------------------
/*
    < BEGIN(실행부) >
        - 조건문 : IF 조건식 THEN 실행내용 END IF; // 단일일 경우(단일구문)
*/
-- 사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스율(%) 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원임' 출력
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번(EID) : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명(ENAME) : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여(SAL) : ' || SAL);

    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원임');
        END IF;
        
    DBMS_OUTPUT.PUT_LINE('보너스율(%) : ' || BONUS * 100 || '%');
END;
/


--== IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; // IF-ELSE문 ==--
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO EID, ENAME, SAL, BONUS
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번(EID) : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명(ENAME) : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여(SAL) : ' || SAL);

    IF BONUS = 0 
        THEN DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원임');
    ELSE
        DBMS_OUTPUT.PUT_LINE('보너스율(%) : ' || BONUS * 100 || '%');
        END IF;

END;
/


/*
    - 레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
    - 참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    - 일반 변수 : TEAM(소속)
    
    - 실행 : 사용자가 입력한 사번의 사번, 이름, 부서명, 근무국가코드를 변수에 대입
        단, NCODE값이 KO일 경우 -> TEAM변수에 '국내팀'
        단, NCODE값이 KO가 아닐 경우 -> TEAM변수에 '해외팀'
        
    - 출력 : 사번, 이름, 부서명, 소속 출력
*/
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO EID, ENAME, DTITLE, NCODE
    FROM EMPLOYEE
    FULL JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = &사번;
    
    DBMS_OUTPUT.PUT_LINE('사번(EID) : ' || EID);
    DBMS_OUTPUT.PUT_LINE('사원명(ENAME) : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명(DTITLE) : ' || DTITLE);
    
    IF NCODE = 'KO'
        THEN TEAM := '국내팀';
    ELSE
       TEAM := '해외팀'; 
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('소속(TEAM) : ' || TEAM);
    
END;
/


--== IF-ELSE IF문 ==--
-- IF 조건식1 THEN 실행내용1 ELSIF 조건식2 THEN 실행내용2 ... ELSE 실행내용4 END IF;

-- 사용자로부터 점수를 입력받아 점수, 학점 출력
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := &점수;
    
    IF SCORE >= 90
        THEN GRADE := 'A';
    ELSIF SCORE >= 80
        THEN GRADE := 'B';
    ELSIF SCORE >= 70
        THEN GRADE := 'C';
    ELSIF SCORE >= 60
        THEN GRADE := 'D';
    ELSE
        GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(SCORE || '점에 대한 ' || '학점은 ' || GRADE || ' 입니다.');
END;
/

-- 문제 --
/*
    - 사용자에게 입력받은 사번의 사원 급여를 조회해서 SAL 변수에 대입
    
    - 조건 
      500만 이상이면 '고급'
      500미만 ~ 300만 이상이면 '중급'
      300만 미만이면 '초급'
      
    - 출력 : '해당 사원의 급여 등급은 XX 입니다.'
*/
DECLARE
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(10);
BEGIN
    SELECT SALARY INTO SAL 
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >= 5000000
        THEN GRADE := '고급';
    ELSIF 5000000 > SAL AND SAL >= 3000000
        THEN GRADE := '중급';
    ELSIF SAL < 3000000
        THEN GRADE := '초급';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
END;
/


--== CASE ==--
/*
    - 표현법 : CASE 비교대상자
                  WHEN 비교할값1 THEN 실행내용1
                  WHEN 비교할값2 THEN 실행내용2
                  WHEN 비교할값3 THEN 실행내용3
                  ELSE 실행내용 4
               END;
        
    - SWITCH문과 비슷함
        SWITCH(변수) {  -> CASE
            CASE ?:  -> WHEN
                실행내용  -> THEN
            DEFAULT:  -> ELSE
*/
DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(30);
BEGIN
    SELECT * INTO EMP 
    FROM EMPLOYEE WHERE EMP_ID = &사번;
    
    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사관리부'
                WHEN 'D2' THEN '회계관리부'
                WHEN 'D3' THEN '마케팅부'
                WHEN 'D4' THEN '국내영업부'
                WHEN 'D8' THEN '기술지원부'
                WHEN 'D9' THEN '총무부'
                ELSE '해외영업부'
             END;
             
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '의 부서는 ' || DNAME || ' 입니다.');
END;
/


--=== LOOP ===--
/* 
    -= BASIC LOOP 문 =-
        -> 표현식 : LOOP 반복적으로 실행할 구문;
                    * 반복적으로 빠져나갈 수 있는 구문;
                    END LOOP;
        
    - 반복문을 빠져나갈 수 있는 조건문 2가지
        -> IF조건식 이용 : IF 조건식 THEN EXIT; END IF;
        
        -> EXIT : EXIT WHEN 조건식;
*/  
-- 1 ~ 5까지 5번 반복하는 반복문
--= IF 조건식 =--
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP 
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        IF I = 6 THEN EXIT; 
        END IF;
    END LOOP;
END;
/


--= EXIT =--
DECLARE
    I NUMBER := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I + 1;
        
        EXIT WHEN I = 6;
    END LOOP;
END;
/


/*
    -= FOR LOOP문 =-
    
    - 표현식 : FOR 변수 IN [REVERSE] 초기값..최종값
                LOOP
                    반복적으로 실행할 구문;
                END LOOP;
*/
BEGIN
    FOR I IN 1..5
        LOOP
            DBMS_OUTPUT.PUT_LINE(I);
        END LOOP;
END;
/

-- REVERSE : 거꾸로 출력
BEGIN
    FOR I IN REVERSE 1..5
        LOOP
            DBMS_OUTPUT.PUT_LINE(I);
        END LOOP;
END;
/

CREATE TABLE TEST (
    TNO NUMBER PRIMARY KEY,
    TDATE DATE
);

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2;

BEGIN
    FOR I IN 1..100
        LOOP
            INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL, SYSDATE);
        END LOOP;
END;
/

SELECT * FROM TEST;


/*
    -= WHILE LOOP문 =-
    
    - 표현식 : WHILE 반복문이 수행될 조건
                LOOP
                    반복적으로 실행할 구문;
                END LOOP;
*/
DECLARE
    I NUMBER := 1;
BEGIN
    WHILE I < 6
        LOOP
            DBMS_OUTPUT.PUT_LINE(I);
            I := I + 1;
        END LOOP;
END;
/


--------------------------------------------------------------------------------
/*
    < EXCEPTION(예외처리부) >
        - 예외(EXCEPTION) : 실행 중 발생하는 오류
        
        - 표현식 : EXCEPTION
                    WHEN 예외명1 THEN 예외처리구문1;
                    WHEN 예외명2 THEN 예외처리구문2;
                    ...
                    WHEN OTHERS THEN 예외처리구문;
               
        * 시스템예외(오라클에서 미리 정의해둔 예외)
            - NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
            - TO_MANY_ROWS : SELECT한 결과가 여러 행일 경우
            - ZERO_DIVIDE : 0으로 나누었을 경우
            - DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
            ...
*/
-- 사용자가 입력한 수로 나눗셈 연산
-- ZERO_DIVIDE : 0으로 나누었을 경우
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10 / &숫자;
    
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);
EXCEPTION
    -- 예외처리의 종류를 알 경우 지정해서 예외처리
    -- WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
    
    -- 예외처리의 종류를 모를 경우 예외처리가 발생할 때 예외처리
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
END;
/


-- DUP_VAL_ON_INDEX : UNIQUE 제약조건에 위배되었을 경우
BEGIN
    UPDATE EMPLOYEE 
        SET EMP_ID = &변경할사번
    WHERE EMP_NAME = '김정보';
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/


-- 사수 200번은 5명, 202 하나도 없고, 222 N명, ...
-- NO_DATA_FOUND : SELECT한 결과가 한 행도 없을 경우
-- TO_MANY_ROWS : SELECT한 결과가 여러 행일 경우
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
        INTO EID, ENAME
        FROM EMPLOYEE
    WHERE MANAGER_ID = &사수번호;
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('조회된 행이 너무 많습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('조회된 결과가 없습니다.');
    -- WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('조회된 결과가 너무 많거나 없습니다.');
END;
/


-- 문제 --
-- 사원의 연봉을 구하는 PL/SQL 블럭 작성, 보너스가 있는 사원은 보너스도 포함하여 계산
-- 풀이 1
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, SALARY INTO EID, SAL
    FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF BONUS IS NOT NULL
        THEN SAL := (SAL + (SAL * BONUS)) * 12;
    ELSIF BONUS IS NULL
        THEN SAL := (SAL + (SAL * NVL(BONUS, 1))) * 12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번 ' || EID || '의 연봉은 ' || SAL || '원입니다.');
END;
/
    
-- 풀이 2
DECLARE
    E EMPLOYEE%ROWTYPE;
    YSAL NUMBER;
BEGIN
    SELECT * INTO E
    FROM EMPLOYEE
    WHERE EMP_ID = &EMP_ID;
    
    IF E.BONUS IS NULL
        THEN YSAL := E.SALARY * 12;
    ELSE
        YSAL := E.SALARY * (1 + E.BONUS) * 12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(E.EMP_NAME || '사원의 연봉은 ' || TO_CHAR(YSAL, 'L999,999,999') || '입니다.');
END;
/


-- 구구단 짝수단 출력(FOR LOOP, WHILE LOOP 문)
-- FOR LOOP
BEGIN
    FOR I IN 2..9
        LOOP
            IF MOD(I, 2) = 0
                THEN
                  FOR J IN 1..9
                    LOOP
                      DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I * J);
                    END LOOP;
                    DBMS_OUTPUT.PUT_LINE('');
            END IF;
        END LOOP;
END;
/

-- WHILE LOOP
-- 풀이 1
DECLARE
    I NUMBER := 2;
    J NUMBER;
BEGIN
    WHILE I <= 9
        LOOP
        J := 1;
    
        IF MOD(I, 2) = 0
            THEN 
                WHILE J <= 9
                LOOP
                    DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I * J);
                    J := J + 1;
                END LOOP;
                    DBMS_OUTPUT.PUT_LINE('');
        END IF;
        I := I + 1;
    END LOOP;
END;
/

-- 풀이 2
DECLARE
    I NUMBER := 2;
    J NUMBER;
BEGIN
    WHILE I <= 9
      LOOP
        J := 1;
        WHILE J <= 9
            LOOP
                DBMS_OUTPUT.PUT_LINE(I || ' * ' || J || ' = ' || I * J);
                J := J + 1;
            END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
        I := I + 2;
      END LOOP;
END;
/