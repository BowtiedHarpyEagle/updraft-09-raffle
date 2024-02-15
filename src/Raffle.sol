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
    address payable [] private s_players;

    /** Events */

    event EnteredRaffle(address indexed player);

    constructor(uint256 _entranceFee) {
        i_entranceFee = _entranceFee;
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
    function pickWinner() public {
        
    }

    /** Getter functions */

    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }
}