var RockPaperScissors = artifacts.require("./RockPaperScissors.sol");

contract('RockPaperScissors', function(accounts) {

  it("...should store the address of the caller.", function() {
    return RockPaperScissors.deployed().then(function(instance) {
      rockPaperScissorsInstance = instance;

      return rockPaperScissorsInstance.register({from: accounts[0]});
    }).then(function() {
      return rockPaperScissorsInstance.getPlayer1Address.call();
    }).then(function(storedData) {
      assert.equal(storedData, accounts[0], "The address of the calling account was not stored.");
    });
  });

});
