pragma solidity ^0.5.0;

import './Queue.sol';

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */


contract BuyerQueue is Queue {
    QueueSt buyers;

    constructor() public {
        buyers.data.length = 5;
        buyers.front = 0;
        buyers.back = 0;
    }
    function enqueue(address addr_) public {
        push(buyers, addr_);
    }
    function dequeue() public {
        pop(buyers);
    }
    function qsize() public view returns (uint8) {
        return qsize(buyers);
    }
}
