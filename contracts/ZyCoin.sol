// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./SafeMath.sol";

interface IERC20 {
    // /**
    // Returns the name of the token - e.g. "MyToken".
    //  */
    //   function name() public view returns (string memory);

    // /**
    // Returns the symbol of the token. E.g. “HIX”.
    //  */
    //   function symbol() public view returns (string memory);

    // /**
    // Returns the number of decimals the token uses - e.g. 8, means to divide the token amount by 100000000
    //  to get its user representation.
    //  */
    // function decimals() public view returns (uint8);

    // /** Returns the total token supply. */
    // function totalSupply() public view returns (uint256);

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

contract ZyCoin is IERC20 {
    address public owner;
    using SafeMath for uint256;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 public totalSupply;

    string public name;
    string public symbol;
    uint8 public decimals;

    constructor() {
        owner = msg.sender;
        name = "ZyCoin";
        symbol = "ZYC";
        decimals = 18;
        totalSupply = 4 * 10**27;
        balances[owner] = totalSupply;
    }

    // function name() public view returns (string){
    //   return  name;
    // }

    //  function symbol() public view returns (string){
    //    return symbol;
    //  }

    //  function decimals() public view returns (uint8){
    //    return decimals;
    //  }

    //  function totalSupply() public view returns (uint256){
    //    return totalSupply;
    //  }

    function balanceOf(address _owner) external view override returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        external
        override
        returns (bool success)
    {
        require(balances[msg.sender] >= _value, "Not enough balance");
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override returns (bool success) {
        require(balances[_from] >= _value, "Not enough balance");
        require(allowed[_from][_to] >= _value, "Not enough allowance");
        allowed[_from][_to] = allowed[_from][_to].sub(_value);
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value)
        external
        override
        returns (bool success)
    {
        //  require(balances[msg.sender]>=_value, "Not enough balance");
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender)
        external
        view
        override
        returns (uint256 remaining)
    {
        return allowed[_owner][_spender];
    }
}
