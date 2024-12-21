// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PhysicsPuzzleGame {

    // Declare state variables
    address public owner;
    uint256 public rewardAmount = 10 * 10**18; // Reward per level completion (in wei)
    uint256 public totalLevels = 10; // Total number of levels in the game
    mapping(address => uint256) public playerRewards;
    mapping(address => uint256) public playerLevel;
    
    // Event for rewards
    event LevelCompleted(address indexed player, uint256 reward);
    event TokenClaimed(address indexed player, uint256 amount);

    // Modifier to ensure only the owner can call certain functions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    // Constructor to set the owner of the contract
    constructor() {
        owner = msg.sender;
    }

    // Function to complete a level
    function completeLevel() public {
        uint256 currentLevel = playerLevel[msg.sender];

        require(currentLevel < totalLevels, "All levels completed");
        
        // Reward for completing a level
        playerRewards[msg.sender] += rewardAmount;
        playerLevel[msg.sender] += 1;

        emit LevelCompleted(msg.sender, rewardAmount);
    }

    // Function for the player to claim their rewards
    function claimReward() public {
        uint256 reward = playerRewards[msg.sender];
        require(reward > 0, "No rewards to claim");

        // Reset rewards after claiming
        playerRewards[msg.sender] = 0;

        // Transfer reward to the player (for simplicity, using ether as rewards)
        payable(msg.sender).transfer(reward);

        emit TokenClaimed(msg.sender, reward);
    }

    // Function to fund the contract with ether (for testing)
    receive() external payable {}

    // Function to change the reward amount (only by the owner)
    function setRewardAmount(uint256 newRewardAmount) public onlyOwner {
        rewardAmount = newRewardAmount;
    }

    // Function to set the total number of levels (only by the owner)
    function setTotalLevels(uint256 newTotalLevels) public onlyOwner {
        totalLevels = newTotalLevels;
    }

    // Function to view the player's current level
    function getPlayerLevel(address player) public view returns (uint256) {
        return playerLevel[player];
    }

    // Function to view the player's available reward
    function getPlayerReward(address player) public view returns (uint256) {
        return playerRewards[player];
    }
}
