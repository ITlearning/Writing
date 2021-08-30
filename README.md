![라이팅 배너](https://user-images.githubusercontent.com/11778058/130311032-65dcc437-1f12-4e0c-a77b-7db556a2a4a2.png)

**회고글** : **['Writing' 앱 제작기](https://velog.io/@kirri1124/Writing-%EC%95%B1-%EC%A0%9C%EC%9E%91%EA%B8%B0-yk15rpte)**

## 개요
첫 개인 프로젝트인 '라이팅' 이라는 앱의 이름은, "쓰다, 글쓰기"라는 뜻의 명사인 **Writing** 과, "빛,조명"이라는 뜻의 명사인 **Lighting** 의 두가지 뜻을 가진 이름입니다.

이 앱을 통해 **꾸준히 작성하는 습관**을 길러, 이 꾸준함이 자신의 인생에 도움이 되어 **세상에 밝게 빛날 수 있는 사람**이 되기를 바라는 의미에서 이름을 정하였습니다. 

## 앱 소개
이 앱은 하루하루 일어난 일들에 대해 적어보는 앱입니다. 일기앱이죠.

하지만, 꾸준함을 만들기 위해 **챌린지** 라는 시스템을 도입해 자신의 꾸준함을 평가해 볼 수 있는 기회를 마련하였고, 깃허브의 잔디처럼 작성시 잔디가 쌓이는 UI또한 존재합니다.

또한 **서버와 연동**을 하여 어떤 기기에서나 이 앱을 다운받고 로그인만 한다면 자신이 작성하였던 모든 일기들을 간편하게 확인할 수 있습니다.

### **앱의 모든 해상도는 iPhone SE2 에 최적화 되어있습니다.** 

### **다른 기기에 설치할 경우 레이아웃이 맞지 않을 수 있습니다.**

## 구현 모습

<img src="https://user-images.githubusercontent.com/11778058/130349283-4947b07b-0a9d-43fa-9cc3-47248d81c7e8.gif"  width="256" height="455"/> <img src="https://user-images.githubusercontent.com/11778058/130349329-6eeed2e6-ff33-4203-a37a-47ba791ba49f.gif"  width="256" height="455"/> <img src="https://user-images.githubusercontent.com/11778058/130349631-3386359b-050c-4383-8f78-29ac37575674.gif"  width="256" height="455"/> <img src="https://user-images.githubusercontent.com/11778058/130349739-2abcf14e-4633-4f80-9ec3-a1540fa3edcd.gif"  width="256" height="455"/> <img src="https://user-images.githubusercontent.com/11778058/130349978-b7fc43a3-da47-447f-ad0a-d205e1e289ea.gif"  width="256" height="455"/> <img src="https://user-images.githubusercontent.com/11778058/130350119-1552c530-3101-4861-a0be-1502dce3be3d.gif"  width="256" height="455"/> 

## 제작 기간
**2021년 8월 12일 ~ 8월 22일**

**총 10일 소요**

## 사용언어
`Swift`

## 사용한 주요 라이브러리
`Kingfisher`,`Firebase`, `TextFieldEffects`, `IQKeyboardManagerSwift`, `NotificationBannerSwift`, `Tabman`, `YPImagePicker`

## 사용된 디자인 패턴(아키텍쳐)
`MVC`

## 서버
![image](https://user-images.githubusercontent.com/11778058/130351340-3cac484c-f7f1-4491-bf3a-1608c14fe160.png)

## 앱 설명
![image](https://user-images.githubusercontent.com/11778058/130352195-97d7055f-e23d-4ba8-bf17-6e6dc144c91a.png)![image](https://user-images.githubusercontent.com/11778058/130352387-7aaeda37-5624-4bfd-adb8-ee35e6942e05.png)![image](https://user-images.githubusercontent.com/11778058/130352587-552802d6-23de-4c5b-aa63-1c888e2ea157.png)![image](https://user-images.githubusercontent.com/11778058/130352785-43e62197-df10-4dd7-8a7a-b44338aa140b.png)![image](https://user-images.githubusercontent.com/11778058/130352977-fb90c205-b5b6-40fb-85cb-0f9377cb7988.png)![image](https://user-images.githubusercontent.com/11778058/130353090-05a8a63a-973d-4150-a574-316f0bbbda09.png)



## 구현 List
### Pages
- [X] 시작페이지 구현
- [X] 회원가입, 로그인 페이지 구현
- [X] 글쓰기 페이지 구현
- [X] 해시태그 페이지 구현
- [X] 검색 페이지 구현 -> 사진 페이지로 변경 후 구현
- [X] 더보기 페이지 구현


### Function
- [X] FireBase 서버를 통한 로그인, 회원가입, 로그아웃 구현
- [X] 일기 작성, 서버 업로드 구현
- [X] 일기 목록 정상적으로 보이게 구현
- [X] 해시태그 페이지 TableView UI 개선, 수정 구현
- [X] 일기 작성 시 폰트 설정 구현 (아직 사용자가 폰트 설정하는 것은 구현하지 못함)
- [X] 일기 업로드 시, 제한 사항 구현
- [X] 삭제 할 때 서버도 삭제 되게 구현
- [X] 메인화면 링 실시간 업데이트 구현
- [X] TIL 잔디 구현
- [X] 사진 추가 구현
- [X] 검색 UI 인스타그램 검색 페이지 처럼 구현 -> 인스타 피드 스토리로 변경 후 구현
- [X] 해시태그 뷰에서 사진이 추가되어있지 않은 글 게시 할 시, 빈 공간 지우기 구현(혹은 빈 공간 채우기 구현)



