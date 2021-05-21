// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

import "./SafeMath.sol";

interface IERC20 {
    /**
    Returns the name of the token - e.g. "MyToken".
     */
     function name() external view returns (string memory);

    /**
    Returns the symbol of the token. E.g. “HIX”.
     */
     function symbol() external view returns (string memory);

    /**
    Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000
     to get its user representation.
     */
    function decimals() external view returns (uint8);

    /** Returns the total token supply. */
    function totalSupply() external view returns (uint256);

    /**Returns the account balance of another account with address _owner.
     */
    function balanceOf(address _owner) external view returns (uint256 balance);

    /**
Transfers _value amount of tokens to address _to, and MUST fire the Transfer event. 
The function SHOULD throw if the message caller’s account balance does not have enough tokens to spend.
Note Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event.
 */
    function transfer(address _to, uint256 _value)
        external
        returns (bool success);

    /**Transfers _value amount of tokens from address _from to address _to, and MUST fire the Transfer event.

The transferFrom method is used for a withdraw workflow, allowing contracts to transfer tokens on your behalf.
 This can be used for example to allow a contract to transfer tokens on your behalf and/or to charge fees in sub-currencies. 
 The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism.
 */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    /**
Allows _spender to withdraw from your account multiple times, up to the _value amount. 
If this function is called again it overwrites the current allowance with _value.
 */
    function approve(address _spender, uint256 _value)
        external
        returns (bool success);

    /**
Returns the amount which _spender is still allowed to withdraw from _owner.
 */
    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}





contract BatchErc20{
    
    using SafeMath for uint256;
    
    address private owner;
    
    constructor(){
        owner = msg.sender;
    }
    
    modifier onlyOnwer(){
       require(msg.sender == owner,"Must be owner");
       _;
    }
    

   /**
   * need approve  manual before call this function
    **/
    function batchTransfer(address token,address[] memory toAdrs,uint256[] memory values)  external onlyOnwer returns (bool){
      require(token!=address(0));
      require(token!=address(this));
      require(toAdrs.length == values.length,"Length not match");
      IERC20  erc20= IERC20(token);
     
      uint256 totalTrans;
      
      for(uint i=0;i<values.length;i++){
          totalTrans.add(values[i]);
      }
    
      require(erc20.balanceOf(msg.sender)>=totalTrans,"Not enough total balance");
    //   erc20.approve(address(this),totalTrans);
      
      for(uint i=0;i<toAdrs.length;i++){
          erc20.transferFrom(msg.sender,toAdrs[i],values[i]);
      }
      
      return true;
        
    }
    
    function balanceTest(address token)  external view returns   (uint256){
       require(token!=address(0));
       require(token!=address(this));
     
       IERC20  erc20= IERC20(token);
       
       return erc20.balanceOf(msg.sender);
    }


    
    
}
