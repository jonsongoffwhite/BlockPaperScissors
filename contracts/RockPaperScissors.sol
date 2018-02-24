pragma solidity ^0.4.2;
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

    function register() public payable stateRegistering() {

        if (player1 == 0) {
            player1 = msg.sender;
        } else if (player2 == 0) {
            player2 = msg.sender;
            globalState = State.Playing;
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
        }

        evaluate();
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
        if (globalState != State.Registering) {
            revert();
        } else {
            _;
        }
    }

    modifier statePlaying() {
        if (globalState != State.Playing) {
            revert();
        } else {
            _;
        }
    }

    modifier stateEvaluating() {
        if (globalState != State.Evaluating) {
            revert();
        } else {
            _;
        }
    }

}
