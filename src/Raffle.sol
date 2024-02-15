// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.18;

/**
 * @title A sample raffle contract 
 * @author Patrick Collins - Foundry full course 2023 - BowtiedHarpyEagle going through the course
 * @notice This contract is for creating a provably fair lottery
 * @dev Implements Chainlink VRFv2 for random number generation
 */

contract Raffle {
    error Raffle__NotEnoughEthSent();
    uint256 private immutable i_entranceFee;
    // @dev i_interval is how long the raffle is open in seconds
    uint256 private immutable i_interval;
    address payable [] private s_players;
    uint256 private s_lastTimestamp;

    /** Events */

    event EnteredRaffle(address indexed player);

    constructor(uint256 entranceFee, uint256 interval)  {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimestamp = block.timestamp;
    }

    function enterRaffle()  external payable{
        // require(msg.value >= i_entranceFee, "Raffle: insufficient entrance fee");
        // don't use require, use revert with custom error, more gas efficient

        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }

        s_players.push(payable(msg.sender)); // push new player to the players array
        /** Whenever a storage variable is changed, it is best to emit an event because:
         * 1) Makes migrations easier
         * 2) Makes front end indexing easier
         */
        emit EnteredRaffle(msg.sender);
    }

    /** 1. Get a random number
     *  2. Pick a winner
     *  3. Get called automatically at a certain time
      */
    function pickWinner() external {
        // Check if enough time has passed

        if (block.timestamp - s_lastTimestamp < i_interval) {
            revert();
        }
        }
        
    /** Getter functions */

    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }
}