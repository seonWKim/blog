# Deterministic Data Recovery

- Project Chronobreak
    - Allows esports officials to rewind a live game to a specific point in time
    - make the LoL game server deterministic so we could re-play a recorded game and restore the server to the exact
      state it was in at an earlier time
- SNR(Server Network Recordings)
    - game servers that record each game
        - complete record of all the inputs, match settings and configurations used to play the game
    - can start from any time again when there's a bug

# Implementation

- What is determinism
    - when given a fixed set of inputs, it produces the same outputs
- `Divergence` is when software fails to behave in a deterministic fashion
- Because computer software is designed to be free of divergences, software divergences are the product of unexpected
  inputs
- Validating determinism
    - If divergence occurs, it causes the game to progressively diverge and eventually break down into chaos
    - the goal of determinism validation is to find the root cause of the divergence
    - Don't have to make everything deterministic. It would be too complicated
- Classifying the inputs
    - Controlled inputs: inputs that never change between executions of the same game version
        - scripts, hardware platform, OS
    - Uncontrolled outputs: inputs into the LoL server that was either noisy, random or generated from player inputs
        - frame time, client network traffic, random number generators etc
- Recording inputs
    - record network inputs each frame in the order in which they're received by the server
    - Critical simplification they made up front was that SNRs would record and play back the state of the game a single
      frame at a time -> led to numerous conventions and simplifications that allowed them to deliver gameplay server
      determinism in a reasonable amount of time
- Taking control of inputs
    - unify the game clocks as they had more than 6 individual clock implementations
    -

# Links

- https://technology.riotgames.com/news/determinism-league-legends-introduction
- https://technology.riotgames.com/news/determinism-league-legends-implementation

# 얘기해보고 싶은 것

- 내가 이걸 왜 읽었을까? app 개발자로서 게임 서버들은 어떤 기술을 사용하는지 알고 싶었음
- determinism 이란 개념이 흥미로웠음
    - turso라는 오픈소스 데이터베이스에 기여중인데 deterministic simulation testing을 활용해 버그를 잡고 있었음
- determinism 이란 ?
    - same input -> same output
    - divergence. 상태가 determinism으로부터 벗어나는 것
- LoL 서버는 determinism으로 뭘 하는가?
    - replay, testing, find bugs etc
- LoL 서버가 determinism을 구현하기 위해 고민한 플로우가 인상 깊음
    - divergence를 유발하는 원인? inputs(not software because softwares are mostly deterministic)
    - input classification - controlled and uncontrolled
    - make deterministic everywhere ?? No -> only essential parts
    - simplified rule -> LoL servers will record and play back the state of the game a single frame at a time
        - Linux의 everything is a file과 비슷하다고 느낌. 잘 규정된 단순한 규칙 위에 만들어진 소프트웨어가 얼마나 단순해질 수 있는지
- determinism을 활용하는 방법이 functional programming과 event sourcing과 비슷하다고 느껴짐
    - functional programming : same input, same output, ease of testing
    - event sourcing : replaying, snapshotting etc
- final thoughts
    - 게임 서버를 구현하는데 있어 determinism이란 개념이 적용된게 흥미로웟음
    - app 개발할 때 엄격한 상태 관리, replay 등의 요구사항이 존재할 때 determinism을 적용해볼 수 있을 것 같음. 다만 그 방법이 determinism이라 부를지는 모르겠음. 아마 event
      sourcing이 되지 않을까 싶음(혹은 모르지)