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

  it("...should allow players to chose an RPS option, and change the state to evaluating.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;

      return rockPaperScissorsInstance.play(1, {from: accounts[0]});
    }).then(function() {
      return rockPaperScissorsInstance.play(2, {from: accounts[1]});
    }).then(function() {
      return rockPaperScissorsInstance.getState.call();
    }).then(function(state) {
      var evaluatingState = 2;
      assert.equal(state, evaluatingState, "The contact was not in evaluating state after two players played.");
    });
  });

});
