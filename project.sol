// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnToEarn {
    // Struct to hold tutorial details
    struct Tutorial {
        uint256 id;
        address creator;
        string title;
        string description;
        uint256 price;
        string contentURI;
        uint256 reward;
    }

    // State variables
    uint256 public tutorialCount;
    mapping(uint256 => Tutorial) public tutorials;
    mapping(address => uint256) public userBalances;

    // Events
    event TutorialCreated(
        uint256 id,
        address indexed creator,
        string title,
        uint256 price,
        uint256 reward
    );
    event TutorialPurchased(uint256 id, address indexed buyer);
    event RewardClaimed(address indexed learner, uint256 amount);

    // Function to create a new tutorial
    function createTutorial(
        string memory _title,
        string memory _description,
        uint256 _price,
        string memory _contentURI,
        uint256 _reward
    ) public {
        tutorialCount++;
        tutorials[tutorialCount] = Tutorial(
            tutorialCount,
            msg.sender,
            _title,
            _description,
            _price,
            _contentURI,
            _reward
        );
        emit TutorialCreated(tutorialCount, msg.sender, _title, _price, _reward);
    }

    // Function to purchase a tutorial
    function purchaseTutorial(uint256 _id) public payable {
        Tutorial memory tutorial = tutorials[_id];
        require(msg.value >= tutorial.price, "Insufficient payment");
        
        userBalances[tutorial.creator] += msg.value;
        emit TutorialPurchased(_id, msg.sender);
    }

    // Function to claim rewards
    function claimReward(uint256 _id) public {
        Tutorial memory tutorial = tutorials[_id];
        require(tutorial.reward > 0, "No reward available");

        uint256 reward = tutorial.reward;
        tutorial.reward = 0;
        tutorials[_id] = tutorial;

        userBalances[msg.sender] += reward;
        emit RewardClaimed(msg.sender, reward);
    }

    // Function to withdraw earnings
    function withdrawEarnings() public {
        uint256 balance = userBalances[msg.sender];
        require(balance > 0, "No balance to withdraw");
        
        userBalances[msg.sender] = 0;
        payable(msg.sender).transfer(balance);
    }
}