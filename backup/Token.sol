pragma solidity ^0.4.15;

import './interfaces/IERC20.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

 mapping (address => uint256) private _balances;
mapping (address => mapping (address =>uint256)) private _allowed;

contract Token is IERC20 {

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
      function allowance(address _owner, address _spender) constant returns (uint256 remaining){
          return _allowed[owner][spender];
      }

    /**
    * @dev Transfer token for a specified addresses
    * @param from The address to transfer from.
    * @param to The address to transfer to.
    * @param value The amount to be transferred.
    */
    function _transfer(address from, address to, uint256 value) internal {
        require(to != address(0));

        _balances[from] = _balances[from].sub(value);
        _balances[to] = _balances[to].add(value);
        emit Transfer(from, to, value);
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param value The amount of token to be burned.
     */
    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }

    /**
     * @dev Burns a specific amount of tokens from the target address and decrements allowance
     * @param from address The address which you want to send tokens from
     * @param value uint256 The amount of token to be burned
     */
    function burnFrom(address from, uint256 value) public {
        _burnFrom(from, value);
    }


    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burn(address account, uint256 value) internal {
        require(account != address(0));

        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account The account whose tokens will be burnt.
     * @param value The amount that will be burnt.
     */
    function _burnFrom(address account, uint256 value) internal {
        _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}
