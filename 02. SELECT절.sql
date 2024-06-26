-- 테이블 컬럼의 정보 조회 : SELECT
/*
    홑따옴표(') : 문자열일 때
    쌍따옴표(")  : 컬럼명일 때
    
    <SELECT> : 데이터를 조회할 때 사용하는 구문
        - RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행의 집합)
        - 표현법 : SELECT 조회하려는_컬럼명, ... FROM 테이블명;
            -> 전체 컬럼을 조회 : *
*/

-- 테이블 모든 컬럼 조회
SELECT * FROM EMPLOYEE;

SELECT * FROM DEPARTMENT;


--===========================================================================--
-- 테이블 특정 컬럼 조회
-- EMPLOYEE 테이블에서 사번, 이름, 번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- JOB 모든 컬럼 조회
SELECT * FROM JOB;

-- EMPLOYEE 테이블에서 사번, 이름, 급여, 입사일만 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE FROM EMPLOYEE;


-- 문제 --
-- JOB 테이블에서 직급명만 조회
SELECT JOB_NAME FROM JOB;

-- DEPARTMENT 테이블의 모든 컬럼 조회
SELECT * FROM DEPARTMENT;

-- DEPARTMENT 테이블의 부서코드, 부서명만 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT;

-- EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE, SALARY FROM EMPLOYEE;


--===========================================================================--
/*
    <컬럼값을 통한 산술연산>
        - SELECT절 컬럼명 작성부분에 산술연산 가능(산술연산된 결과 조회)
        - 산술연산 중 NULL이 존재하면 결과는 무조건 NULL, 별도 처리 가능
*/

-- EMPLOYEE에서 사원명, 사원의 연봉(급여 * 12) 조회
SELECT EMP_NAME, SALARY * 12 FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉((급여 + (보너스 * 급여)) * 12) 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * 12, (SALARY + (SALARY * BONUS)) * 12 FROM EMPLOYEE;

-- EMPLOYEE에서 사원명, 입사일, 근무일수(오늘날짜 - 입사일) 조회
-- DATE형 끼리도 연산 가능 : 결과값은 일 단위, 함수로 DATE 날짜처리하면 초단위로 관리할 수 있음
-- 오늘 날짜 : SYSDATE
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEE;


--===========================================================================--
/*
    <컬럼명 별칭 지정>
        - 산술연산시 산술에 들어간 수식 그대로 컴럼명이 됨, 이때 별칭을 부여하면 깔끔하게 처리
        - 표현법 : 컬럼명 별칭 /컬럼명 AS 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
        - 별칭에 띄어쓰기나 특수문자가 포함되면 반드시 쌍따옴표(")를 넣어줘야 함
*/

-- 예시 1
SELECT EMP_NAME 사원명, SALARY AS 급여, BONUS "보너스", SALARY * 12 "연봉(원)", (SALARY + (SALARY * BONUS)) * 12 "총 소득" FROM EMPLOYEE;

SELECT EMP_NAME AS 사원명, HIRE_DATE "입사일(일)", SYSDATE - HIRE_DATE AS "근무일수(일)" FROM EMPLOYEE;


--===========================================================================--
/*
    <리터럴>
        - 임의로 지정된 문자열(')
        - SELECT절에 리터럴을 제시하면 마치 테이블 상에 존재하는 데이터처럼 조회 가능
        - 조회된 RESULT SET의 모든 행에 반복적으로 출력
*/

-- EMPLOYEE에 사번, 사원명, 급여, 원 AS 단위조회
-- 숫자 정렬 기본값(오른쪽), 문자열 정렬 기본값(왼쪽)
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS 단위 FROM EMPLOYEE;


--===========================================================================--
/*
    <연결 연산자 : ||(버티컬바)>
        - 여러 컬럼값들을 마치 하나의 컬럼값인것처럼 연결하거나 컬럼값과 리터럴 연결
*/

-- EMPLOYEE에 사번, 사원명, 급여를 하나의 컬럼으로 조회
-- 띄워쓰기 하고 싶을때는 연결 연산자(||) 사이에 ' '(빈칸) 넣어줌
SELECT EMP_ID || ' ' || EMP_NAME || ' ' || SALARY FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY, SALARY || '원' FROM EMPLOYEE;

-- 홍길동의 월급은 900000원 입니다. 출력
SELECT EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' FROM EMPLOYEE;

-- 홍길동의 전화번호는 PHONE이고 이메일은 EMAIL 입니다.
SELECT EMP_NAME || '의 전화번호는 ' || PHONE || '이고 이메일은 ' || EMAIL || '입니다.' FROM EMPLOYEE;


--===========================================================================--
/*
    <DISTINCT> : 컬럼의 중복된 값들을 한번씩만 표시하고자 할 때
        - 유의사항 : SELECT절에서 DISTINCT는 한번만 기술
*/
-- EMPLOYEE에서 직급코드 출력
SELECT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE에서 직급코드 중복제외하고 출력
SELECT DISTINCT JOB_CODE FROM EMPLOYEE; 

-- EMPLOYEE에서 부서코드 중복제외하고 출력
SELECT DISTINCT DEPT_CODE FROM EMPLOYEE;

-- DISTINCT는 한번만 기술할 수 있기 때문에 결과값이 제대로 출력 x
-- 두개의 컬럼에 대해 조합할 수 있는 경우의 수가 중복을 제외하고 한개씩 나옴
SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;
-- SELECT DISTINCT JOB_CODE, DISTINCT DEPT_CODE FROM EMPLOYEE; // 오류


--===========================================================================--
/*
    <WHERE절> : 조회하고자 하는 테이블에서 특정 조건에 만족하는 데이터만 조회할 때
        - WHERE절에 조건식 제시
        - 표현법 : SELECT 컬럼명, 컬럼명, ... FROM 테이블명 WHERE 조건;
        - 비교연산자(>>), 대소비교(>, <, >=, <=), 같음(=), 같지않음(!=, ^=, <>)
*/
-- EMPLOYEE에서 부서코드가 'D9'인 사원의 모든 컬럼 조회
SELECT * FROM EMPLOYEE WHERE DEPT_CODE = 'D9';

-- EMPLOYEE에서 부서코드가 'D1'인 아닌 사원의 사번, 사원명, 부서코드를 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE <> 'D1';

-- EMPLOYEE에서 급여가 400만원 이상인 사원의 사원명, 부서코드, 급여를 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE SALARY >= 4000000;

-- EMPLOYEE에서 재직 중인 사원의 사번, 사원명, 입사일을 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE ENT_YN = 'N';


-- 문제 --
-- 급여가 300만원 이상인 사원의 사원명, 급여, 입사일, 연봉 조회
SELECT EMP_NAME, SALARY, HIRE_DATE, SALARY * 12 FROM EMPLOYEE WHERE SALARY >= 3000000;

-- 연봉이 5000만원 이상인 사원의 사원명, 급여, 연봉, 부서코드 조회
SELECT EMP_NAME, SALARY, SALARY * 12, DEPT_CODE FROM EMPLOYEE WHERE SALARY * 12 >= 50000000;

-- 직급코드가 'J3'이 아닌 사원의 사번, 사원명, 직급코드, 퇴사여부 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, ENT_YN FROM EMPLOYEE WHERE JOB_CODE <> 'J3';


--===========================================================================--
/*
    <논리 연산자> : 여러개의 조건을 묶어서 제시하고자 할 때
        - AND : ~이면서, 그리고
        - OR : ~이거나, 또는
        - NOT : 부정 논리 연산자, 컬럼명 앞이나 BETWEEN 앞에 사용
*/
-- 부서코드가 'D9'이면서 급여가 500만원 이상인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D9' AND SALARY >= 5000000;

-- 부서코드가 'D6'이거나 급여가 300만원 이상인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME,  DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE = 'D6' OR SALARY >= 3000000;

-- 급여가 350만원이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE 3500000 <= SALARY AND SALARY <= 6000000;


--===========================================================================--
/*
    <BETWEEN AND> : ~이하 ~이상인 범위의 조건을 제시할 때
        - 표현법 : 비교대상컬럼명 BETWEEN 이하값 AND 이상값
            -> 해당 컬럼값이 이하값 이상이고 이상값 이하인 경우
*/
-- 급여가 350만원이상 600만원 이하인 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY BETWEEN 3500000 AND 6000000;

-- 급여가 350만원이상 600만원 이하를 제외한 사원의 사번, 사원명, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE NOT SALARY  BETWEEN 3500000 AND 6000000;

-- 입사일이 90/01/01 ~ 01/12/31 사이인 사원의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/12/31';


--===========================================================================--
/*
    <LIKE> : 비교하고자 하는 컬럼값이 특정 패턴에 만족하는 경우를 조회할 때
        - 표현법 : 비교대상컬럼명 LIKE '특정 패턴'
            -> 특정 패턴은 '%' , '_' , 와일드카드를 통해 제시
        
        - % : 0글자 이상
            -> 비교대상컬럼명 LIKE '문자%' : 비교대상 컬럼값이 '문자'로 시작되는 것을 조회
            -> 비교대상컬럼명 LIKE '%문자' :  비교대상 컬럼값이 '문자'로 끝나는 것을 조회
            -> 비교대상컬럼명 LIKE '%문자%' :  비교대상 컬럼값에 '문자'가 포함된 것을 조회
        
        - _ : 1글자, 부호 갯수에 따라 해당 글자 수를 맞춰야 함
            -> 비교대상컬럼명 LIKE '_문자' : 비교대상 컬럼값의 '문자' 앞에 무조건 한글자가 있는 경우를 조회(3글자만 가능)
            -> 비교대상컬럼명 LIKE '문자_' : 비교대상 컬럼값의 '문자' 뒤에 무조건 한글자가 있는 경우를 조회(3글자만 가능)
            -> 비교대상컬럼명 LIKE '_문자_' : 비교대상 컬럼값의 '문자' 앞/뒤에 무조건 한글자가 있는 경우를 조회(4글자만 가능)
*/
-- 사원들 중에 성이 '전'씨인 사원의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '전%';

-- 사원들 중에 이름에 '하'가 포함된 사원의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '%하%';

-- 사원들 중에 이름 가운데 글자가 '하'인 사원(3글자)의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE WHERE EMP_NAME LIKE '_하_';

-- 전화번호 중 3번째 글자가 '1'인 사원의 사번, 사원명, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE WHERE PHONE LIKE '__1%';

-- 이메일 중 '_' 앞에 글자가 3글자인 사원의 사번, 사원명, 이메일 조회(언더바(_) 4개)
-- 언더바(_) 4개 : 와일드 카드로 인식됨
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '____%'; 

-- 데이터와 와일드카드를 구분지어야 함
-- 데이터값으로 취급하고자 하는 값 앞에 나만의 와일드카드(아무거나 문자, 숫자, 특수문자)를 제시하고 나만의 와일드카드 escape로 등록해야 함
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE EMAIL LIKE '___\_%' ESCAPE '\';

-- 이메일 중 '_' 앞에 글자가 3글자인 사원을 제외한 사원의 사번, 사원명, 이메일 조회
SELECT EMP_ID, EMP_NAME, EMAIL FROM EMPLOYEE WHERE NOT EMAIL LIKE '___\_%' ESCAPE '\';


-- 문제 --
-- 이름이 '연'으로 끝나는 사원의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE FROM EMPLOYEE WHERE EMP_NAME LIKE '%연';

-- 전화번호 처음 3자리가 010이 아닌 사원의 사원명, 전화번호 조회
SELECT EMP_NAME, PHONE FROM EMPLOYEE WHERE NOT PHONE LIKE '010%';

-- 이름이 '하'가 포함되어 있고, 급여가 250만원 이상인 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY FROM EMPLOYEE WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2500000;

-- DEPARTMENT 테이블에서 해외영업부인 부서들의 부서코드, 부서명 조회
SELECT DEPT_ID, DEPT_TITLE FROM DEPARTMENT WHERE DEPT_TITLE LIKE '해외영업%';


--===========================================================================--
/*
    <IS NULL / IS NOT NULL>
        - 컬럼값에 NULL이 있는 경우 NULL값 비교에 사용되는 연산자
        - IS NULL(NULL인 경우), IS NOT NULL(NULL이 아닌 경우)
*/
-- 보너스를 받지 않는 사원의 사번, 사원명, 급여, 보너스 조회
-- SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE BONUS = NULL; // 조회안됨
SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE BONUS IS NULL;

-- 보너스를 받는 사원의 사번, 사원명, 급여, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE BONUS IS NOT NULL;
SELECT EMP_ID, EMP_NAME, SALARY, BONUS FROM EMPLOYEE WHERE NOT BONUS IS NULL;

-- 사수가 없는 사원들의 사번, 사원명, 사수번호 조회
SELECT EMP_ID, EMP_NAME, MANAGER_ID FROM EMPLOYEE WHERE MANAGER_ID IS NULL;

-- 부서배치를 받지 않았지만 보너스는 받는 사원의 사원명, 보너스, 부서코드 조회
SELECT EMP_NAME, BONUS, DEPT_CODE FROM EMPLOYEE WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;


--===========================================================================--
/*
    <IN / NOT IN>
        - IN : 컬럼값이 내가 제시한 목록 중에 일치하는 값이 있는것만 조회
        - NOT IN : 컬럼값이 내가 제시한 목록 중에 일치하는 값을 제외한 것만 조회
        - 표현법 : 비교대상컬럼명 IN('값1', '값2', '값3', ...)
*/
-- 부서코드가 ' D5, D6, D8 ' 인 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE IN('D5', 'D6', 'D8');

-- 부서코드가 ' D5, D6, D8 ' 이 아닌 사원의 사원명, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY FROM EMPLOYEE WHERE DEPT_CODE NOT IN('D5', 'D6', 'D8');


--===========================================================================--
/*
    <연산자 우선순위> : () -> 산술연산자 -> 연결연산자 -> 비교연산자
        -> IS NULL / LIKE '패턴' / IN -> BETWEEN AND -> NOT(논리연산자)
        -> AND(논리연산자) -> OR(논리연산자)
*/
-- 직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회
SELECT EMP_NAME, JOB_CODE, SALARY FROM EMPLOYEE
WHERE (JOB_CODE = 'J7' OR JOB_CODE = 'J2') AND SALARY >= 2000000;


-- 문제 --
-- 사수가 없고 부서배치도 받지 않은 사원의 사원명, 사수사번, 부서코드 조회
SELECT EMP_NAME, MANAGER_ID, DEPT_CODE FROM EMPLOYEE 
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

-- 연봉(보너스 포함x)이 3000만원 이상이고 보너스를 받지 않은 사원의 사번, 사원명, 보너스, 연봉 조회
SELECT EMP_ID, EMP_NAME, BONUS, SALARY * 12 FROM EMPLOYEE 
WHERE SALARY * 12 >= 30000000 AND BONUS IS NULL;

-- 입사일이 95/01/01 이상이고 부서배치를 받은 사원의 사번, 사원명, 입사일, 부서코드 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE, DEPT_CODE FROM EMPLOYEE 
WHERE HIRE_DATE >= '95/01/01' AND DEPT_CODE IS NOT NULL;

-- 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01 이상이고 보너스를 받지 않는 사원의
--      사번, 사원명, 급여, 입사일, 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS FROM EMPLOYEE
WHERE SALARY BETWEEN 2000000 AND 5000000 AND HIRE_DATE >= '01/01/01' AND BONUS IS NULL;

-- 보너스포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 사번, 사원명, 급여,
--      보너스포함 연봉 조회(별칭부여)
-- 연봉(보너스 포함) 계산법 = 급여 * (1 + 보너스) * 12
SELECT EMP_ID "사번", EMP_NAME "사원명", SALARY "급여", (SALARY + (SALARY * BONUS)) * 12 "연봉(보너스포함)" 
FROM EMPLOYEE 
WHERE (SALARY + (SALARY * BONUS)) * 12 IS NOT NULL AND EMP_NAME LIKE '%하%';


--===========================================================================--
/*
    <ORDER BY절> : 정렬할 때
        - SELECT문 가장 마지막 줄에 작성, 실행순서도 마지막 실행
        - 표현법 : SELECT 컬럼명 FROM 테이블명 WHERE 조건식 
                    ORDER BY 정렬기준인 컬럼명 |별칭| 컬럼순번[ASC | DESC] | [NULLS FIRST | NULLS LAST];
        - ASC(오름차순 정렬, 생략 시 기본값) / DESC(내림차순 정렬)
        - NULLS FIRST : 정렬하고자하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 앞에 배치(생략시 DESC일때의 기본값)
            -> 내림차순일 때는 NULL 값이 맨 앞에 정렬
        - NULLS LAST : 정렬하고자하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 뒤에 배치(생략시 ASC일때의 기본값)
            -> 오름차순일 때는 NULL 값이 맨 뒤에 정렬
*/
-- 보너스로 정렬
SELECT EMP_NAME, BONUS, SALARY FROM EMPLOYEE 
-- ORDER BY BONUS; // 오름차순(기본값), NULLL값이 맨 뒤에 정렬
-- ORDER BY BONUS NULLS FIRST; // 오름차순 + NULL값 맨 앞에 정렬
-- ORDER BY BONUS DESC; // 내림차순은 DESC 반드시 기술, NULLL값이 맨 앞에 정렬
ORDER BY BONUS DESC, SALARY ASC; -- BONUS 기준으로 내림차순 하다가 BONUS값이 같으면 SALARY 값 기준 오름차순 정렬(기준 여러개 가능)

-- 전 사원의 사원명, 연봉 조회(연봉 내림차순 정렬 조회)
SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC;