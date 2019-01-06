pragma solidity ^0.5.0;

import "../interfaces/IERC20.sol";
import "../TimedCrowdsale.sol";

contract TimedCrowdsaleImpl is TimedCrowdsale {
    constructor (uint256 openingTime, uint256 closingTime, uint256 rate, address payable wallet, IERC20 token)
        public
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(rate, wallet, token, openingTime, closingTime)
    {}
}
