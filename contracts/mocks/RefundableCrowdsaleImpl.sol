pragma solidity ^0.5.0;

import "../token/Token.sol";
import "../RefundableCrowdsale.sol";

contract RefundableCrowdsaleImpl is RefundableCrowdsale {
    constructor (
        uint256 openingTime,
        uint256 closingTime,
        uint256 rate,
        address payable wallet,
        Token token,
        uint256 goal
    )
        public
        Crowdsale(rate, wallet, token)
        TimedCrowdsale(rate, wallet, token, openingTime, closingTime)
        FinalizableCrowdsale(rate, wallet, token, openingTime, closingTime)
        //RefundableCrowdsale(rate, wallet, token, openingTime, closingTime, goal)
    {}
}
