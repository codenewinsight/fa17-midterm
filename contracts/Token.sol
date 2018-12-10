pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

mapping (address => uint256) private _balances;
mapping (address => mapping (address =>uint256)) private _allowed;

contract Token is ERC20Interface {

      /// @param _owner The address from which the balance will be retrieved
      /// @return The balance
      function balanceOf(address _owner) constant returns (uint256 balance){
        return _balances[_owner];
      }

      /// @notice send `_value` token to `_to` from `msg.sender`
      /// @param _to The address of the recipient
      /// @param _value The amount of token to be transferred
      /// @return Whether the transfer was successful or not
      function transfer(address _to, uint256 _value) returns (bool success){
        //check balance of sender
        if (_balances[msg.sender] >= _value){
          _balances[msg.sender]-= _value;
          _balances[_to] += _value;

          emit Transfer(msg.sender, _to, _value);
          return true;
        }

        return false;
      }

      /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
      /// @param _from The address of the sender
      /// @param _to The address of the recipient
      /// @param _value The amount of token to be transferred
      /// @return Whether the transfer was successful or not
      function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
        //check balance of _spender
        if (balances[_from] >= _value){
          balances[_from]-= _value;
          balances[_to] += _value;

          emit Transfer(_from, _to, _value);
          return true;
        }

        return false;
      }


      /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
      /// @param _spender The address of the account able to transfer the tokens
      /// @param _value The amount of tokens to be approved for transfer
      /// @return Whether the approval was successful or not
      function approve(address _spender, uint256 _value) returns (bool success){
        //check balance of sender
        if (_balances[msg.sender] >= _value){
          //_balances[msg.sender]-= _value;
          _allowed[msg.sender][_spender] += _value;

          emit Approval(msg.sender, spender, _value);
          return true;
        }

        return false;
      }

      /// @param _owner The address of the account owning tokens
      /// @param _spender The address of the account able to transfer the tokens
      /// @return Amount of remaining tokens allowed to spent
      function allowance(address _owner, address _spender) constant returns (uint256 remaining);

      event Transfer(address indexed _from, address indexed _to, uint256 _value);
      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}
