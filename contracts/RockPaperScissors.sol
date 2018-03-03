pragma solidity ^0.4.18;
contract RockPaperScissors {

    enum RPS {
        Rock,
        Paper,
        Scissors,
        Unchosen
    }

    enum State {
        Registering,
        Playing,
        Evaluating
    }

    address player1;
    address player2;

    RPS player1choice;
    RPS player2choice;

    State globalState;

    mapping(uint => mapping(uint => uint)) outcomes;

    mapping(address => RPS) choices;

    function RockPaperScissors() public {
        outcomes[0][0] = 0;
        outcomes[1][1] = 0;
        outcomes[2][2] = 0;
        outcomes[0][1] = 2;
        outcomes[0][2] = 1;
        outcomes[1][0] = 1;
        outcomes[1][2] = 2;
        outcomes[2][0] = 2;
        outcomes[2][1] = 1;

        globalState = State.Registering;

        player1choice = RPS.Unchosen;
        player2choice = RPS.Unchosen;
    }

    function register() public payable {
      registerPlayer(msg.sender);
      if (player1 != 0 && player2 != 0) {
        globalState = State.Playing;
      }
    }

    function registerPlayer(address newPlayer) private stateRegistering() {

        if (player1 == 0) {
            player1 = newPlayer;
        } else if (player2 == 0) {
            player2 = newPlayer;
        }
    }

    function play(RPS choice) public statePlaying() {
        if (msg.sender == player1) {
            player1choice = choice;
        } else if (msg.sender == player2) {
            player2choice = choice;
        }

        if (player1choice != RPS.Unchosen && player2choice != RPS.Unchosen) {
            globalState = State.Evaluating;
            evaluate();
        }
    }

    function evaluate() private stateEvaluating() {
        uint result = outcomes[uint(player1choice)][uint(player2choice)];

        if (result == 0) {
            player1.transfer(this.balance/2);
            player2.transfer(this.balance);
        } else if (result == 1) {
            player1.transfer(this.balance);
        } else if (result == 2) {
            player2.transfer(this.balance);
        }
    }

    modifier stateRegistering() {
        if (getState() != State.Registering) {
            revert();
        } else {
            _;
        }
    }

    modifier statePlaying() {
        if (getState() != State.Playing) {
            revert();
        } else {
            _;
        }
    }

    modifier stateEvaluating() {
        if (getState() != State.Evaluating) {
            revert();
        } else {
            _;
        }
    }

    function getState() public view returns(State) {
        return globalState;
    }

}
