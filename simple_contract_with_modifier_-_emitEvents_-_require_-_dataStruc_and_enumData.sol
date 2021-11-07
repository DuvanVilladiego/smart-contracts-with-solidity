// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Challengue1 {
    enum State { Opened, Closed }
    struct Project {
        string id;
        string name;
        string description;
        uint foundAsignGoal;
        address payable author;
        uint founds;
        State state;
    }
    Project public project;
    
    constructor(string memory _id,string memory _name,string memory _description,uint _foundAsignGoal){
       project = Project(_id,_name,_description,_foundAsignGoal,payable(msg.sender),0,State.Opened);
    }
    
    modifier onlyOwner() {
        require(msg.sender == project.author, "Only owner can change the project name");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    modifier blockOwner() {
        require(msg.sender != project.author, "The owner cant fund for this project");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    event ChangeState(uint256 balance, State newState);
    
    event CompleteFund(uint256 balance, State state);
    
    function fundProject() public payable blockOwner{
        require(project.state == State.Opened, "You cant donate because the project state is Closed");
        require(msg.value > 0 ,"Cant donate less than 0 ether in this project");
        project.author.transfer(msg.value);
        project.founds += msg.value;
        if(project.founds >= project.foundAsignGoal) {
            project.state = State.Closed;
            emit CompleteFund(project.founds, project.state);
        }
    }
    
    function changeProjectState(State newState) public onlyOwner {
        require (project.state != newState, "the new state cannot be equal to the current state");
        project.state = newState;
        emit ChangeState(project.founds, newState);
    }
}