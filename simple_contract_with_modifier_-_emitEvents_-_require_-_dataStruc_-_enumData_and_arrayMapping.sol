// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Challengue1 {
    enum State { Opened, Closed }
    struct Contributors {
        address contributor;
        uint contribution;
    }
    struct Project {
        string id;
        string name;
        string description;
        uint foundAsignGoal;
        address payable author;
        uint founds;
        State state;
    }
    Project[] public projects;
    mapping(string => Contributors[]) public contributions;
    
    modifier onlyOwner(uint position) {
        require(msg.sender == projects[position].author, "Only owner can change the project name");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    modifier blockOwner(uint position) {
        require(msg.sender != projects[position].author, "The owner cant fund for this project");
        //la función es insertada en donde aparece este símbolo
        _;
    }
    
    event ChangeState(uint256 balance, State newState);
    
    event CompleteFund(uint256 balance, State state);
    
    function CreateProject(string memory _id,string memory _name,string memory _description,uint _foundAsignGoal) public {
        projects.push(Project(_id,_name,_description,_foundAsignGoal,payable(msg.sender),0,State.Opened));
    }
    
    function fundProject(uint position) public payable blockOwner(position){
        require(projects[position].state == State.Opened, "You cant donate because the project state is Closed");
        require(msg.value > 0 ,"Cant donate less than 0 ether in this project");
        projects[position].author.transfer(msg.value);
        projects[position].founds += msg.value;
        contributions[projects[position].id].push(Contributors(msg.sender,msg.value));
        if(projects[position].founds >= projects[position].foundAsignGoal) {
            projects[position].state = State.Closed;
            emit CompleteFund(projects[position].founds, projects[position].state);
        }
    }
    
    function changeProjectState(uint position,State newState) public onlyOwner(position){
        require (projects[position].state != newState, "the new state cannot be equal to the current state");
        projects[position].state = newState;
        emit ChangeState(projects[position].founds, newState);
    }
}