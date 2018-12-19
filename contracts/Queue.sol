pragma solidity ^0.5.0;

/**
 * @title Queue
 * @dev Data structure contract used in `Crowdsale.sol`
 * Allows buyers to line up on a first-in-first-out basis
 * See this example: http://interactivepython.org/courselib/static/pythonds/BasicDS/ImplementingaQueueinPython.html
 */

contract Queue {
    struct QueueSt{
        address[] data;
        uint256[] time;
        uint8 front;
        uint8 back;
    }

	/* State variables */
    uint16 constant TIME_DIFF = 3600;

	/* Add events */


	/* Add constructor */
	constructor() public {

	}

	/* Returns the number of people waiting in line */
	function qsize(QueueSt storage q_) view internal returns(uint8) {
        return q_.back - q_.front;
	}

    /* Returns the capacity of queue */
    function capacity(QueueSt storage q_) view internal returns(uint8) {
        return ((uint8)(q_.data.length)) - 1;
    }

	/* Returns whether the queue is empty or not */
	function empty(QueueSt storage q_) view internal returns(bool) {
        if (qsize(q_) > 0)
            return true;

        return false;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst(QueueSt storage q_) view internal returns(address) {
        if (q_.back == q_.front)
            return address(0); // throw;

        return q_.data[q_.front];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace(QueueSt storage q_) view internal returns(uint8) {
        uint8 i = 0xFF;

        //Iterate to find matching address
        for (i = 0; i <= q_.back; i++){
            if (msg.sender == q_.data[i])
                break;
        }

        return i;
	}

	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime(QueueSt storage q_) internal {
        if (q_.time[q_.front] > now)
		    pop(q_);
	}

	/* Removes the first person in line; either when their time is up or when
	 * they are done with their purchase
	 */
	function pop(QueueSt storage q_) internal {
        if (q_.back == q_.front)
            return; // throw;
        //r = q.data[q_.front];
        delete q_.data[q_.front];
        delete q_.time[q_.front];
        q_.front = (q_.front + 1) % ((uint8)(q_.data.length)) ;
	}

	/* Places `addr` in the first empty position in the queue */
	function push(QueueSt storage q_, address addr_) internal {
        // if ((q_.back + 1) % q_.data.length == q_.front)
        //     return; // throw;
        q_.data[q_.back] = addr_;
        q_.time[q_.back] = now;//TIME_DIFF;
        q_.back = (q_.back + 1) % ((uint8)(q_.data.length));
	}

}
