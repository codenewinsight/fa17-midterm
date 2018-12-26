pragma solidity ^0.5.0;

import "./interfaces/IERC20.sol";
import "./math/SafeMath.sol";

/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure.
 * to use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using SafeMath for uint256;

    function safeTransfer(IERC20 token_, address to_, uint256 value_) internal {
        require(token_.transfer(to_, value_));
    }

    function safeTransferFrom(IERC20 token_, address from_, address to_, uint256 value_) internal {
        require(token_.transferFrom(from_, to_, value_));
    }

    function safeApprove(IERC20 token_, address spender_, uint256 value_) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to_ zero. to_ increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require((value_ == 0) || (token_.allowance(msg.sender, spender_) == 0));
        require(token_.approve(spender_, value_));
    }

    function safeIncreaseAllowance(IERC20 token_, address spender_, uint256 value_) internal {
        uint256 newAllowance = token_.allowance(address(this), spender_).add(value_);
        require(token_.approve(spender_, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token_, address spender_, uint256 value_) internal {
        uint256 newAllowance = token_.allowance(address(this), spender_).sub(value_);
        require(token_.approve(spender_, newAllowance));
    }
}
