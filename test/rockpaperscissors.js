var RockPaperScissors = artifacts.require("./RockPaperScissors.sol");

contract('RockPaperScissors', function(accounts) {

  // Runs sequentially, all operating on the same contract instance.

  it("...is in registration initially.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var registeringState = 0;
      assert.equal(state, registeringState, "The contract was not in registering state after one registration.")
    });
  });

  it("...is still registering after one registration.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;

      return rockPaperScissorsInstance.register({from: accounts[0]});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var registeringState = 0;
      assert.equal(state, registeringState, "The contract was not in registering state after one registration.")
    });
  });

  it("...should be in state playing after two registrations.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;

      return rockPaperScissorsInstance.register({from: accounts[1]});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var playingState = 1;
      assert.equal(state, playingState, "The contract was not in playing state after two registrations.");
    });
  });

  it("...should allow players to chose an RPS option and secret, and change the state to revealing.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;

      return rockPaperScissorsInstance.play(1, "secret", {from: accounts[0], value: 10});
    }).then(function() {
      return rockPaperScissorsInstance.play(2, "terces", {from: accounts[1], value: 10});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var revealingState = 2;
      assert.equal(state, revealingState, "The contact was not in revealing state after two players played.");
    });
  });

  it("...should allow a player to reveal but remain in revealing to wait for the next player", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;
    }).then(function() {
      return rockPaperScissorsInstance.reveal(1, "secret", {from: accounts[0]});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var revealingState = 2;
      assert.equal(state, revealingState, "The contact was not in revealing state after one player revealed.");
    });
  });

  it("...should change state to Player2Win after the second player has revealed", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;
    }).then(function() {
      return rockPaperScissorsInstance.reveal(2, "terces", {from: accounts[1]});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var player2WinState = 6;
      assert.equal(state, player2WinState, "The contact was not in evaluating state after both players revealed.");
    });
  });

});
