/*
    <함수> : 전달된 컬럼값을 읽어들여 함수를 실행한 결과를 반환
        - 단일행 함수 : N개의 값을 읽어들여 N개의 결과값을 반환(행마다 함수 실행)
        - 그룹 함수 : N개의 값을 읽어들여 1개의 결과값을 반환(그룹별로 함수 실행)
        
        - SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음
        - 함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVING절
*/
-- [ 단일행 함수 ] --

-- 문자처리 함수
/*
    - LENGTH / LENGIHB -> NUMBER로 반환
        -> LENGTH(컬럼 | '문자열') : 해당 문자열의 글자 수 반환
        -> LENGIHB(컬럼 | '문자열') : 해당 문자열의 바이트(byte) 수 반환
    
    - 한글 : XE버전일 때 -> 1글자당 3byte(ㄱㄷㅏ 등도 1글자에 해당)
             EE버전일 때 -> 1글자당 2byte
    - 그외 : 1글자당 1byte
*/
-- DUAL : 오라클에서 제공하는 가상 테이블
SELECT LENGTH('오라클'), LENGTHB('오라클') FROM DUAL;

SELECT LENGTH('oracle'), LENGTHB('oracle') FROM DUAL;

SELECT LENGTH('ㅇㅗㄹㅏ') ||'글자', LENGTHB('ㅇㅗㄹㅏ') || 'byte' FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME) ||'글자', LENGTHB(EMP_NAME) || 'byte', 
       EMAIL, LENGTH(EMAIL) ||'글자', LENGTHB(EMAIL) || 'byte'
FROM EMPLOYEE;


--===========================================================================--
/*
    - INSTR : 문자열로부터 특정 문자의 시작 위치(INDEX)를 찾아서 반환(반환형 : NUMBER)
        -> ORACLE에서 INDEX 번호는 1부터 시작. 찾는 문자가 없으면 0 반환
        -> INSTR(컬럼 | '문자열', '찾을 문자열', [찾을 위치의 시작값, [순번]])
            + 찾을 위치의 시작값 : 1(앞에서부터 찾기(기본값)), -1(뒤에서부터 찾기)
*/
-- 앞에서부터 찾음
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A') FROM DUAL; -- 결과 : 2
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1) FROM DUAL; -- 결과 : 2

-- 뒤에서부터 찾음
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1) FROM DUAL; -- 결과 : 17

-- 찾을 위치의 시작값 지정(앞에서부터)
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', 1, 3) FROM DUAL; -- 결과 : 12

-- 찾을 위치의 시작값 지정(뒤에서부터)
SELECT INSTR('JAVASCRIPTJAVAORACLE', 'A', -1, 2) FROM DUAL; -- 결과 : 14

-- 예시. 이메일에서 '_'과 '@'의 위치 찾음
SELECT EMAIL, INSTR(EMAIL, '_') "_위치", INSTR(EMAIL, '@') "@위치" FROM EMPLOYEE;

