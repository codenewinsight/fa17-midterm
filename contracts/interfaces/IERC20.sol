pragma solidity ^0.5.0;

/**
 * @title IERC20
 * @dev ERC20 token standard: https://github.com/ethereum/EIPs/issues/20
 * As seen here: https://github.com/ConsenSys/Tokens/blob/master/contracts/Token.sol
 */
interface IERC20 {
	/* This is a slight change to the ERC20 base standard.

    function totalSupply() constant returns (uint256 supply);
    is replaced with:
    uint256 public totalSupply;

    This automatically creates a getter function for the totalSupply.
    This is moved to the base contract since public getter functions are not
    currently recognised as an implementation of the matching abstract
    function by the compiler.
    */

    /// @param owner_ The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address owner_) external view returns (uint256 balance);

    /// @notice send `value_` token to `to_` from `msg.sender`
    /// @param to_ The address of the recipient
    /// @param value_ The amount_ of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address to_, uint256 value_) external returns (bool success);

    /// @notice send `value_` token to `to_` from `from_` on the condition it is approved by `from_`
    /// @param from_ The address of the sender
    /// @param to_ The address of the recipient
    /// @param value_ The amount_ of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address from_, address to_, uint256 value_) external returns (bool success);

    /// @notice `msg.sender` approves `spender_` to spend `value_` tokens
    /// @param spender_ The address of the account able to transfer the tokens
    /// @param value_ The amount_ of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address spender_, uint256 value_) external returns (bool success);

    /// @param owner_ The address of the account owning tokens
    /// @param spender_ The address of the account able to transfer the tokens
    /// @return amount_ of remaining tokens allowed to spent
    function allowance(address owner_, address spender_) external view returns (uint256 remaining);

    event Transfer(address indexed from_, address indexed to_, uint256 value_);
    event Approval(address indexed owner_, address indexed spender_, uint256 value_);
}
