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

        buyers.data.length = 6;
        buyers.time.length = 6;
        buyers.data = new address[](6);
        buyers.time = new uint256[](6);
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

    /* Returns whether the queue is empty or not */
    function empty() public view returns(bool) {
    	return empty(buyers);
    }

    /* Returns the address of the person in the front of the queue */
    function getFirst() public view returns(address) {
    	return getFirst(buyers);
    }

    /* Allows `msg.sender` to check their position in the queue */
    function checkPlace() public view returns(uint8) {
    	return 	checkPlace(buyers);
    }

    /* Allows `msg.sender` to check their position in the queue */
    function doCheckPlace(address sendingAddr_) public view returns(uint8) {
    	return 	doCheckPlace(sendingAddr_, buyers);
    }

    /* Allows anyone to expel the first person in line if their time
    * limit is up
    */
    function checkTime() public {
        checkTime(buyers);
    }

    /* Allows anyone to expel the first person in line if their time
    * limit is up
    */
    function doCheckTime(uint256 currentTime_) public {
        doCheckTime(currentTime_, buyers);
    }

	function doCheckInputTime(address sendingAddr_) public view returns(uint256){
        return doCheckInputTime(sendingAddr_, buyers);
    }
}
