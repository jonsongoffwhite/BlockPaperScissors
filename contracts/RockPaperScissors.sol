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
        Revealing,
        Evaluating,
        Draw,
        Player1Win,
        Player2Win
    }

    address player1;
    address player2;

    RPS player1choice;
    RPS player2choice;

    uint256 player1bet;
    uint256 player2bet;

    bytes32 player1ChoiceHash;
    bytes32 player2ChoiceHash;

    State globalState;

    uint256 MINIMUM_BET = 5;

    mapping(uint => mapping(uint => uint)) outcomes;

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
        } else if (player2 == 0 && newPlayer != player1) {
            player2 = newPlayer;
        }
    }

    function play(RPS choice, string secret) public
      payable
      isValidPlayer()
      statePlaying()
      largeEnoughBet(MINIMUM_BET) {
        if (msg.sender == player1 && player1ChoiceHash == 0) {
            player1ChoiceHash = keccak256(keccak256(choice) ^ keccak256(secret));
            player1bet = msg.value;
        } else if (msg.sender == player2 && player2ChoiceHash == 0) {
            player2ChoiceHash = keccak256(keccak256(choice) ^ keccak256(secret));
            player2bet = msg.value;
        }

        if (player1ChoiceHash != 0 && player2ChoiceHash != 0) {
            globalState = State.Revealing;
        }
    }

    function reveal(RPS choice, string secret) public
      isValidPlayer()
      stateRevealing() {

        if (msg.sender == player1 && keccak256(keccak256(choice) ^ keccak256(secret)) == player1ChoiceHash) {
            player1choice = choice;
        } else if (msg.sender == player2 && keccak256(keccak256(choice) ^ keccak256(secret)) == player2ChoiceHash) {
            player2choice = choice;
        }

        if (player1choice != RPS.Unchosen && player2choice != RPS.Unchosen) {
            globalState = State.Evaluating;
            evaluate();
            globalState = getState();
        }


    }

    function evaluate() private stateEvaluating() {
        uint result = outcomes[uint(player1choice)][uint(player2choice)];

        if (result == 0) {
            globalState = State.Draw;
            player1.transfer(player1bet);
            player2.transfer(player2bet);
        } else if (result == 1) {
            globalState = State.Player1Win;
            player1.transfer(this.balance);
        } else if (result == 2) {
            globalState = State.Player2Win;
            player2.transfer(this.balance);
        }
    }

    function getBalance() public view returns(uint) {
        return this.balance;
    }

    modifier isValidPlayer() {
        if (msg.sender != player1 && msg.sender != player2) {
            revert();
        } else {
            _;
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

    modifier stateRevealing() {
        if (getState() != State.Revealing) {
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

    modifier largeEnoughBet(uint256 amount) {
        if (msg.value < amount) {
            revert();
        } else {
            _;
        }
    }

    function getState() public view returns(State) {
        return globalState;
    }

}
