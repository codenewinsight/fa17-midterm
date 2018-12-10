pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 private size = 5;
	uint8 private index = 0xFF;
	mapping (uint8 => address) private _addresses;
	mapping (address => uint8) private _indexes;
	mapping (address => uint256) private _releaseTime;
	uint8 constant _timeDiff = 3600;

	/* Add events */
	event Enqueue(address _sender);
	event Dequeue(address _sender);

	/* Add constructor */
	function Queue (){

	}

	/* Returns the number of people waiting in line */
	function qsize() constant returns(uint8) {
		return index;
	}

	/* Returns whether the queue is empty or not */
	function empty() constant returns(bool) {
		if (index != 0)
		  return true;

		return false;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant returns(address) {
		return _addresses[0];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant returns(uint8) {
	  return 	_indexes[msg.sender];
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() {
		if (index >= (size - 1)){
			if (_releaseTime[_addresses[0]] > now)
			  dequeue();
		}
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() {
		if (index >=1 ){
			 _indexes[_addresses[0]] = 0;
			 _releaseTime[_addresses[0]] = 0;
			 _addresses[0] = 0x0;
			 index -= 1;
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr) {
		//if queue is full, check whether the first one should expire
		if (index >= (size - 1)){
			if (_releaseTime[_addresses[0]] > now)
			  dequeue();
		}

		if (index < (size - 1)){
      index += 1;
		  _indexes[addr] = index;
		  _addresses[index] = addr;
		  _releaseTime[addr] = now + _timeDiff;
	  }
	}

}
