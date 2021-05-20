// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./SafeMath.sol";

contract Ballot{
    
    using SafeMath for uint;
    
    struct Voter{
        uint weight; 
        bool voted;
        address delegated;
        uint vote;
    }
    
    struct Proposal{
        string name;
        uint voteCount;
    }
    
    address public chairman;
    
    mapping(address => Voter)  voters;
    
    Proposal[] proposals;
    
    constructor(string[] memory names){
        
        chairman = msg.sender;
        voters[chairman].weight =1;
        
        for(uint i=0;i<names.length;i++){
            
            proposals.push(Proposal({
                
                name: names[i],
                voteCount:0
                
            }));
            
            
        }
        
    }
    

    
    function giveRightToVoter(address _address) public returns (bool){
        require(msg.sender == chairman,"Only chairman can give right");
        
        require(!voters[_address].voted,"Already voted");
        require(voters[_address].weight == 0);
        voters[_address].weight = 1;
    
         return true;
    }
    
    
    function vote(uint _index) public returns (bool){
         require(!voters[msg.sender].voted,"Already voted");
         require(voters[msg.sender].weight>0,"No rights to vote");
         
         voters[msg.sender].voted = true;
         voters[msg.sender].vote = _index;
         proposals[_index].voteCount=  proposals[_index].voteCount.add(voters[msg.sender].weight);
        
        return true;
    }
    
    function delegateTo(address _to) public returns (bool){
         require(!voters[msg.sender].voted,"Already voted");
         require(voters[msg.sender].weight>0,"No rights to vote");
         require(msg.sender != _to,"Can't delegated to self");
         
         
        while(voters[_to].delegated != address(0)){
            _to = voters[_to].delegated;
            require(msg.sender != _to,"Find loop");
        }
        
        voters[msg.sender].voted = true;
        voters[msg.sender].delegated = _to;
        
        if(voters[_to].voted){
            proposals[voters[_to].vote].voteCount = proposals[voters[_to].vote].voteCount.add(voters[msg.sender].weight);
        }else{
            voters[_to].weight = voters[_to].weight.add(voters[msg.sender].weight);
        }
         
         return true;
         
    }
    
    
    modifier onlyChairman(){
        require(msg.sender == chairman,"Only chairman");
        _;
    }
    
    
    function countMax() internal view onlyChairman returns (uint maxIndex) {
        uint maxCount = 0;
        
        for(uint i=0;i<proposals.length;i++){
            if(proposals[i].voteCount>maxCount){
                maxCount = proposals[i].voteCount;
                maxIndex = i;
            }
        }
        
    }
    
    
    function winnerName() public view returns (string memory){
        return proposals[countMax()].name;
    }
    
    
    
}