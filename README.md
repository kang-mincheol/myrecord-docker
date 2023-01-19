# 마이레코드 플랫폼 개발 환경 Docker

마이레코드 플랫폼 개발 환경을 Docker로 구축합니다.

## 요구 사항

- git
- Docker
- docker-compose

## 디렉토리 및 파일 구조

- apache2 : apache 관련 설정 파일이 있는 디렉토리
- data : 로컬에서 구동할 MySQL 데이터베이스 파일이 저장될 디렉토리
- docker-compose.yml : 웹 서버 (Apache + PHP)와 MySQL 서비스를 실행, 중단할 수 있는 파일
- html : 웹 서버에서 사용할 소스코드 및 리소스를 저장할 디렉토리
- Dockerfile : Apache와 PHP 이미지를 빌드할 파일

## 사용 시 주의 사항 ⚠️

- **실행하고자 하는 환경에 이미 80, 5000, 8000 포트를 사용하고 있는 경우** 정상 실행되지 않음
    - Docker를 이용해서 로컬 데이터베이스도 구동시킬 경우, 3306 포트를 사용 중일 경우에도 정상 실행되지 않음
    - 실행 중인 Apache 서비스를 중단하거나 (권장), docker-compose.yml 파일에서 위의 포트를 변경
    - macOS 12 (Monterey) 이상부터 AirPlay 공유가 활성화되어 있을 경우, 5000번 포트를 사용할 수 없으므로 조치 필요
- container를 실행시킬 경우 로컬 환경에서만 80, 5000, 8000 포트에 접근이 가능하며, 외부에서는 접근이 불가능함
    - 외부에서도 접근 가능하게 하려면, docker-compose.yml 파일의 ports 설정에서 '127.0.0.1:'을 제거해야함
- session 디렉토리 위치는 운영, 테스트 서버와 동일하게 data 디렉토리 하위에 session 디렉토리를 사용함
    - html/data/session 디렉토리가 존재하지 않으면 생성해야함

## 사용 가이드

### 사전 작업

1. Github의 Settings - Developer settings에서 Personal access tokens에 들어갑니다.

2. Select scopes에서 `read:packages` 권한에 체크하고, 하단의 Generate token을 눌러서 토큰을 발급받습니다.
    - 만약 기존에 발급받은 토큰이 위의 권한을 가지고 있다면 기존 토큰을 그대로 사용해도 됩니다.

3. 발급 받은 토큰을 이용해서 docker에 아래와 같이 명령어를 입력하여 로그인을 합니다.

    ```
    docker login ghcr.io
    ```

    1. username은 Github 계정 아이디를 입력합니다.
    2. password는 위에서 발급 받은 토큰을 입력합니다. (또는 붙여넣기)
    3. `Login Succeeded`가 떠야 성공입니다.

4. Apache 환경변수를 이용해서 개인 Slack 알림을 설정하는 경우(SLACK_URL_PRIVATE), apache2/apache2.conf 파일 하단에 Slack Hook 주소를 아래와 같이 추가합니다.

    ```
    SetEnv SLACK_URL_PRIVATE <input_slack_hook_url>
    ```
    - <input_slack_hook_url> 부분에 개인 Slack 전송 URL을 입력합니다. 
    - 주의 : **VSCode와 같은 에디터로 편집을 권장**합니다. 메모장의 경우 Line Ending이 변경(LF -> CRLF)되어 Apache 실행 시 오류가 발생할 수 있습니다.

### 공용 테스트 DB 서버에 접속해서 사용하는 경우

1. 본 repository를 clone 합니다. 여기서는 clone한 디렉토리 이름을 repo라고 가정합니다.

2. clone한 repository 디렉토리의 html 디렉토리 밑에 아래와 같은 이름의 디렉토리로 각각 소스코드와 리소스를 다운받습니다.
    
    - repo/html/`myrecord` : 마이레코드 플랫폼 소스코드 (80 포트)

3. repo/html/data 디렉토리에 `session` 디렉토리 생성

4. repo 디렉토리에서 아래의 명령어를 입력합니다. (Apache 웹 서버만 실행)

    ```
    docker-compose up -d webserver
    ```

### 로컬 환경에 DB를 띄워서 사용하는 경우

1. 위의 1~3번 과정을 진행합니다.

2. repo 디렉토리에서 아래의 명령어를 입력합니다. (Apache 웹 서버와 MySQL 로컬 데이터베이스 실행)

    ```
    docker-compose up -d
    ```

## 빌드 가이드

repo 디렉토리에서 아래의 명렁어 입력

```
docker build -t myrecord:[version] .
```
