// SPDX-License-Identifier: MIT

pragma solidity  ^0.8.18;

/**
 * @title A sample raffle contract 
 * @author Patrick Collins - Foundry full course 2023 - BowtiedHarpyEagle going through the course
 * @notice This contract is for creating a provably fair lottery
 * @dev Implements Chainlink VRFv2 for random number generation
 */

contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 _entranceFee) {
        i_entranceFee = _entranceFee;
    }

    function enterRaffle()  public payable{
        
    }

    function pickWinner() public {
        
    }

    /** Getter functions */

    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }
}