# iOS_ChatApp
- Line 느낌의 채팅앱입니다
- 친구를 추가하고 채팅할 수 있는 앱입니다. 

# 개발 동기 
- 최근 대부분의 앱은 유저들간의 소통을 위해 채팅앱이 필수입니다.
- UI 디자인과 Back-End를 연습하기 위해 만들었습니다.

# 개발 환경 
- 개발언어 : Swift
- 개발서버 : Firebase
- 개발인원 : 1명 
- 소스제어 : git 

# 기능 상세 
> 회원가입

<img src="https://user-images.githubusercontent.com/60722292/116387150-77c4ba00-a855-11eb-8589-bb0cff97d20b.png" alt="SignUpOff" width="30%" height="30%"/></img>
<img src="https://user-images.githubusercontent.com/60722292/116387154-785d5080-a855-11eb-9540-2ba9df07d62e.png" alt="SignUpOn" width="30%" height="30%"/></img>
- profile photo 버튼을 누르면 프로필 사진을 설정할 수 있도록 구현했습니다.
- e-mail, password, user name 모두 입력해야 Register 버튼이 활성화됩니다.


> 로그인

<img src="https://user-images.githubusercontent.com/60722292/116387144-76938d00-a855-11eb-9101-13679a2d1c55.png" alt="LogIn" width="30%" height="30%"/></img>
- 이메일과 비밀번호를 입력하면 Firebase에서 정보를 확인한 후 대화목록으로 이동합니다. 
- 'If you don't have account'를 클릭하면 회원가입 화면으로 이동합니다. 


> 채팅 목록

<img src="https://user-images.githubusercontent.com/60722292/116387156-78f5e700-a855-11eb-9a7c-1956083961cb.png" alt="ChatList" width="30%" height="30%"/></img>
- 우측 상단의 NEW CHAT을 누르면 채팅 상대 추가 화면으로 이동합니다. 
- 채팅하고 있는 유저의 프로필 사진, 최근 메시지, 최근 메시지 도착 시간 등을 표시합니다. 
- 셀을 선택하면 대화창으로 넘어갑니다. 


> 채팅추가

<img src="https://user-images.githubusercontent.com/60722292/116387148-76938d00-a855-11eb-9976-e3d36a9677bd.png" alt="AddChat" width="30%" height="30%"/></img>
- 유저를 선택한 후 우측 상단의 버튼을 클릭하면 채팅룸이 만들어집니다. 
- 나를 제외한 다른 유저들이 표시됩니다. 

> 채팅룸

<img src="https://user-images.githubusercontent.com/60722292/116387130-72676f80-a855-11eb-970a-a47a9bfc9531.png" alt="ChatRoom" width="30%" height="30%"/></img>
- UID를 통해 상대방과 나의 메시지를 구분합니다. 
- UID를 통해 식별된 메시지는 내가 보냈을 경우와 상대가 보낸 경우 각각 다른 텍스트 필드에 입력됩니다. 

# 리뷰 
- 스토리보드를 사용해 많은 디자인을 해 본 것이 큰 도움이 되었습니다.
- 생명주기에 대해 많이 공부하게 되었습니다. viewDidLoad에 넣었을 경우와 viewWillAppear에 넣을 경우 동작의 차이 등, 정확한 시점에 정확한 동작이 일어나야 하는 것을 경험했습니다. 
- extension과 protocol을 사용해 보면서 Java와 C#과 다른 차이를 많이 공부할 수 있었습니다.
- UI 디자인이 Android Studio의 디자인이나 C#의 Winform보다 편하다고 느꼈습니다. 
- git flow를 사용하고, 커밋 메시지의 규칙을 만들어 소스관리를 했습니다. (CLI & Source Tree)
<img width="551" alt="gitflow" src="https://user-images.githubusercontent.com/60722292/116410598-e6af0c80-a86f-11eb-868e-7343766dfb0f.png">

# 계획 
- 마이페이지 추가 & 프로필 관리 기능 추가 
- 동영상, 사진 전송 기능 추가 
- Velog에 개념 정리 

