// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Challengue1 {
    string public id;
    string public state = "Opened";
    string public name;
    string public description;
    address payable public author;
    uint public founds;
    uint public foundAsignGoal;
    
    constructor(string memory _id,string memory _name,string memory _description,uint _foundAsignGoal){
        id = _id;
        name = _name;
        description = _description;
        foundAsignGoal = _foundAsignGoal;
        author = payable(msg.sender);
    }
    
    modifier onlyOwner() {
        require(msg.sender == author, "Only owner can change the project name");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    modifier blockOwner() {
        require(msg.sender != author, "The owner cant fund for this project");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    function fundProject() public payable blockOwner{
        author.transfer(msg.value);
        founds += msg.value;
    }
    
    function changeProjectState(string calldata newState) public onlyOwner {
        state = newState;
    }
}