// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Challengue1 {
    string public id;
    bool public state = true;
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
    
    event ChangeState(uint256 balance, bool newState);
    
    event CompleteFund(uint256 balance, bool state);
    
    function fundProject() public payable blockOwner{
        require(state == true, "You cant donate because the project state is Closed");
        require(msg.value > 0 ,"Cant donate less than 0 ether in this project");
        author.transfer(msg.value);
        founds += msg.value;
        if(founds > foundAsignGoal) {
            state = false;
            emit CompleteFund(founds, state);
        }
    }
    
    function changeProjectState(bool newState) public onlyOwner {
        require (state != newState, "the new state cannot be equal to the current state");
        state = newState;
        emit ChangeState(founds, newState);
    }
}