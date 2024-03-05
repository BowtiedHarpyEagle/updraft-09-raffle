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

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import {VRFConsumerBaseV2} from "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
/**
 * @title A sample raffle contract 
 * @author Patrick Collins - Foundry full course 2023 - BowtiedHarpyEagle going through the course
 * @notice This contract is for creating a provably fair lottery
 * @dev Implements Chainlink VRFv2 for random number generation
 */

contract Raffle is VRFConsumerBaseV2 {
    error Raffle__NotEnoughEthSent();
    error Raffle__TransferFailed();
    error Raffle__Raffle__NotOpen();
    /** Type declarations */
    enum RaffleState { 
        OPEN,
        CALCULATING 
    }
    /** Constants */
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint256 private immutable i_entranceFee;
    uint32 private constant NUM_WORDS = 1;
    // @dev i_interval is how long the raffle is open in seconds
    uint256 private immutable i_interval;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    address payable [] private s_players;
    uint256 private s_lastTimestamp;
    address private s_recentWinner;
    RaffleState private s_raffleState;

    /** Events */

    event EnteredRaffle(address indexed player);
    event PickedWinner (address indexed winner);

    constructor(uint256 entranceFee, 
                uint256 interval, 
                address vrfCoordinator, 
                bytes32 gasLane, 
                uint64 subscriptionId,
                uint32 callbackGasLimit

                )  VRFConsumerBaseV2(vrfCoordinator)
    {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimestamp = block.timestamp;
        s_raffleState = RaffleState.OPEN;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinator);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

    function enterRaffle()  external payable{
        // require(msg.value >= i_entranceFee, "Raffle: insufficient entrance fee");
        // don't use require, use revert with custom error, more gas efficient

        if (msg.value < i_entranceFee) {
            revert Raffle__NotEnoughEthSent();
        }

        if (s_raffleState != RaffleState.OPEN) {
            revert Raffle__Raffle__NotOpen();
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

        s_raffleState = RaffleState.CALCULATING;

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );

    }

    function fulfillRandomWords (
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {

        //Checks
        //Effects

        uint256 indexOfWinner = randomWords[0] % s_players.length;
        address payable winner = s_players[indexOfWinner];
        s_recentWinner = winner;
        s_raffleState = RaffleState.OPEN;

        s_players = new address payable[](0);
        s_lastTimestamp = block.timestamp;
        emit PickedWinner(winner);
        
        //Interactions
        
        (bool success, ) = winner.call{value: address(this).balance}("");

        if (!success) {
            revert Raffle__TransferFailed();
        }

        

        
    }
        
    /** Getter functions */

    function getEntranceFee() public view returns(uint256) {
        return i_entranceFee;
    }
}