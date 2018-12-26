pragma solidity ^0.5.0;

import "../Token.sol";

// mock class using ERC20
contract ERC20Mock is Token {
    constructor (address initialAccount_, uint256 initialBalance_) public {
        _mint(initialAccount_, initialBalance_);
    }

    function mint(address to_, uint256 value_) public onlyMinter returns (bool) {
        _mint(to_, value_);
    }

    function burn(address account_, uint256 value_) public {
        _burn(account_, value_);
    }

    function burnFrom(address from_, uint256 value_) public {
        _burnFrom(from_, value_);
    }
}
