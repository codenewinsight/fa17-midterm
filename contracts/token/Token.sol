pragma solidity ^0.5.0;


import '../interfaces/IERC20.sol';
import '../access/roles/MinterRole.sol';
import '../math/SafeMath.sol';
import './SafeERC20.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of gBalances, etc.
 */


contract Token is IERC20, MinterRole {

    using SafeMath for uint256;

    using SafeERC20 for IERC20;

    mapping (address => uint256) private gBalances;

    mapping (address => mapping (address =>uint256)) private gAllowed;

    /// total amount of tokens
   uint256 public gTotalSupply;

    /**
    * @dev Total number of tokens in existence
    */
    function totalSupply() public view returns (uint256) {
        return gTotalSupply;
    }

       /// @param owner_ The address from which the balance will be retrieved
      /// @return The balance
      function balanceOf(address owner_) public view returns (uint256){
        return gBalances[owner_];
      }

      /// @notice send `value_` token to `_to` from `msg.sender`
      /// @param to_ The address of the recipient
      /// @param value_ The amount of token to be transferred
      /// @return Whether the transfer was successful or not
      function transfer(address to_, uint256 value_) public returns (bool){
        _transfer(msg.sender, to_, value_);
        return true;
      }

      /// @notice send `value_` token to `_to` from `_from` on the condition it is approved by `_from`
      /// @param from_ The address of the sender
      /// @param to_ The address of the recipient
      /// @param value_ The amount of token to be transferred
      /// @return Whether the transfer was successful or not
      function transferFrom(address from_, address to_, uint256 value_) public returns (bool){
        gAllowed[from_][msg.sender] = gAllowed[from_][msg.sender].sub(value_);
        _transfer(from_, to_, value_);
        emit Approval(from_, msg.sender, gAllowed[from_][msg.sender]);
        return true;
      }

      /// @notice `msg.sender` approves `spender_` to spend `value_` tokens
      /// @param spender_ The address of the account able to transfer the tokens
      /// @param value_ The amount of tokens to be approved for transfer
      /// @return Whether the approval was successful or not
      function approve(address spender_, uint256 value_) public returns (bool){
        require(spender_ != address(0));

        gAllowed[msg.sender][spender_] = value_;
        emit Approval(msg.sender, spender_, value_);
        return true;
    }

      /// @param owner_ The address of the account owning tokens
      /// @param spender_ The address of the account able to transfer the tokens
      /// @return Amount of remaining tokens gAllowed to spent
      function allowance(address owner_, address spender_) public view returns (uint256){
        return gAllowed[owner_][spender_];
    }

    /**
     * @dev Function to mint tokens
     * @param to_ The address that will receive the minted tokens.
     * @param value_ The amount of tokens to mint.
     * @return A boolean that indicates if the operation was successful.
     */
    function mint(address to_, uint256 value_) public onlyMinter returns (bool) {
        _mint(to_, value_);
        return true;
    }

    /**
     * @dev Burns a specific amount of tokens.
     * @param value_ The amount of token to be burned.
     */
    function burn(uint256 value_) public {
        _burn(msg.sender, value_);
    }

    /**
     * @dev Burns a specific amount of tokens from the target address and decrements allowance
     * @param from_ address The address which you want to send tokens from
     * @param value_ uint256 The amount of token to be burned
     */
    function burnFrom(address from_, uint256 value_) public {
        _burnFrom(from_, value_);
    }

    /**
    * @dev Transfer token for a specified addresses
    * @param from_ The address to transfer from.
    * @param to_ The address to transfer to.
    * @param value_ The amount to be transferred.
    */
    function _transfer(address from_, address to_, uint256 value_) internal {
        require(to_ != address(0));

        gBalances[from_] = gBalances[from_].sub(value_);
        gBalances[to_] = gBalances[to_].add(value_);
        emit Transfer(from_, to_, value_);
    }

    /**
     * @dev Internal function that mints an amount of the token and assigns it to
     * an account. This encapsulates the modification of gBalances such that the
     * proper events are emitted.
     * @param account_ The account that will receive the created tokens.
     * @param value_ The amount that will be created.
     */
    function _mint(address account_, uint256 value_) internal {
        require(account_ != address(0));

        gTotalSupply = gTotalSupply.add(value_);
        gBalances[account_] = gBalances[account_].add(value_);
        emit Transfer(address(0), account_, value_);
    }


    /**
     * @dev Internal function that burns an amount of the token of a given
     * account.
     * @param account_ The account whose tokens will be burnt.
     * @param value_ The amount that will be burnt.
     */
    function _burn(address account_, uint256 value_) internal {
        require(account_ != address(0));

        gTotalSupply = gTotalSupply.sub(value_);
        gBalances[account_] = gBalances[account_].sub(value_);
        emit Transfer(account_, address(0), value_);
    }

    /**
     * @dev Internal function that burns an amount of the token of a given
     * account, deducting from the sender's allowance for said account. Uses the
     * internal burn function.
     * Emits an Approval event (reflecting the reduced allowance).
     * @param account_ The account whose tokens will be burnt.
     * @param value_ The amount that will be burnt.
     */
    function _burnFrom(address account_, uint256 value_) internal {
        gAllowed[account_][msg.sender] = gAllowed[account_][msg.sender].sub(value_);
        _burn(account_, value_);
        emit Approval(account_, msg.sender, gAllowed[account_][msg.sender]);
    }

}
