-- [ JOIN 문제 ] --
-- 1. 부서가 인사관리부인 사원의 사번, 이름, 부서명, 보너스 조회
--== 오라클 전용 구문 ==--
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS FROM EMPLOYEE E, DEPARTMENT D
WHERE E.DEPT_CODE = D.DEPT_ID AND DEPT_TITLE = '인사관리부';

--== ANSI 구문 ==--
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, BONUS FROM EMPLOYEE E
JOIN DEPARTMENT D ON E.DEPT_CODE = D.DEPT_ID WHERE DEPT_TITLE = '인사관리부';


-- 2. DEPARTMENT와 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회
--== 오라클 전용 구문 ==--
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME FROM DEPARTMENT, LOCATION;

--== ANSI 구문 ==--
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE, LOCAL_NAME FROM DEPARTMENT JOIN LOCATION;

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
--== 오라클 전용 구문 ==--


--== ANSI 구문 ==--



-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
--== 오라클 전용 구문 ==--


--== ANSI 구문 ==--

