pragma solidity ^0.4.15;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
	/* State variables */
	uint8 private queueSize = 5;
	uint8 private headIndex = 1; //ineex starts 1 and wrap around 7. so the non existing address in the below mapping is 0
	uint8 private tailIndex = 1;
	mapping (uint8 => address) private addresses;
	mapping (address => uint8) private indexes;
	mapping (address => uint256) private releaseTime;
	uint16 constant TIME_DIFF = 3600;

	/* Add events */
	//event Enqueue(address sender);
	//event Dequeue(address sender);

	/* Add constructor */
	constructor () public {

	}

	/* Returns the number of people waiting in line */
	function qsize() constant public returns(uint8) {

		//Return 0 if queue is empty
		if (tailIndex  == headIndex)
		    return 0;

    //Size is the distance  between head and tail
		if (headIndex > tailIndex)
		    return (headIndex - tailIndex);
		else
		    return (queueSize - tailIndex + headIndex);
	}

	/* Returns whether the queue is empty or not */
	function empty() constant public returns(bool) {
		if (0 == qsize())
		    return true;
		return false;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst() constant public returns(address) {
		return addresses[headIndex];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace() constant public returns(uint8) {
	   return 	indexes[msg.sender];
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime() public {
    	if (releaseTime[addresses[headIndex]] > now)
		    dequeue();
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function dequeue() public {
		if (qsize() >=1 ){
			 indexes[addresses[tailIndex]] = 0;
			 releaseTime[addresses[tailIndex]] = 0;
			 addresses[tailIndex] = 0x0;
			 moveIndex(tailIndex);
		}
	}

	/* Places `addr` in the first empty position in the queue */
	function enqueue(address addr_) public {
        //Address must not exist
        require(indexes[addr_] == 0x0);

		//if queue is full, check whether the first one should expire
		if (qsize() >= queueSize){
			if (releaseTime[addresses[0]] > now)
			  dequeue();
			else
			  return;
		}
        //Queue has space, add input to the next empty spot
		if (qsize() < queueSize){
		  indexes[addr_] = headIndex;
		  addresses[headIndex] = addr_;
		  releaseTime[addr_] = now + TIME_DIFF;
	      moveIndex(headIndex);
	    }
	}

    function moveIndex(uint8 index_) constant returns(uint8){
        //index must start after 0
        require(index_ > 0);

		//wrap around
		if (index_ >= (queueSize + 1))
		    index_ = 1;
		else
		    index_ += 1;

        return index_;
	}
}
