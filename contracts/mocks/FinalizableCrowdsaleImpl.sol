pragma solidity ^0.5.0;

import "../interfaces/IERC20.sol";
import "../FinalizableCrowdsale.sol";

contract FinalizableCrowdsaleImpl is FinalizableCrowdsale {

    constructor (uint256 openingTime, uint256 closingTime, uint256 rate, address payable wallet, IERC20 token)
        public
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(rate, wallet, token, openingTime, closingTime)
        FinalizableCrowdsale(rate, wallet, token, openingTime, closingTime)
    {}
}
