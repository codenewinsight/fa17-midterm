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
    uint32 constant TIME_DIFF = 604800;  //1 week

	/* Add events */

	/* Add constructor */
	constructor() public {

	}

	/* Returns the number of people waiting in line */
	function qsize(QueueSt storage q_) view internal returns(uint8) {
        if (q_.back >= q_.front)
            return q_.back - q_.front;
        else
            return ((uint8)(q_.data.length) + q_.back - q_.front);
	}

    /* Returns the capacity of queue */
    function capacity(QueueSt storage q_) view internal returns(uint8) {
        return ((uint8)(q_.data.length)) - 1;
    }

	/* Returns whether the queue is empty or not */
	function empty(QueueSt storage q_) view internal returns(bool) {
        if (qsize(q_) > 0)
            return false;

        return true;
	}

	/* Returns the address of the person in the front of the queue */
	function getFirst(QueueSt storage q_) view internal returns(address) {
        if (q_.back == q_.front)
            return address(0); // throw;

        return q_.data[q_.front];
	}

	/* Allows `msg.sender` to check their position in the queue */
	function checkPlace(QueueSt storage q_) view internal returns(uint8) {

        return doCheckPlace(msg.sender, q_);
	}

	/* Allows 'sendingAddr' to check their position in the queue */
	function doCheckPlace(address sendingAddr_, QueueSt storage q_) view internal returns(uint8) {
        uint8 index = 0xFF;
        uint8 i = 0;
        uint8 arraySize = qsize(q_);

        //Iterate to find matching address
        index = q_.front;

        for (i = 0; i < arraySize; i++){
            if (sendingAddr_ == q_.data[index])
                break;

            index = (index + 1) % ((uint8)(q_.data.length)) ;
        }

        //if no matching found, set to 0xFF
        if (i == arraySize)
            index = 0xFF;

        return index;
	}


	/* Allows anyone to expel the first person in line if their time
	 * limit is up
	 */
	function checkTime(QueueSt storage q_) internal {
        doCheckTime(now, q_);
	}


	/* Allows anyone to check the first person's expiry time against input time
	 */
	function doCheckTime(uint256 currentTime_, QueueSt storage q_) internal {
        if (q_.time[q_.front] <= currentTime_)
		    pop(q_);
	}


	/* Allows 'sendingAddr' to check their position in the queue */
	function doCheckInputTime(address sendingAddr_, QueueSt storage q_) view internal returns(uint256) {
        uint8 index = 0xFF;
        uint8 i = 0;
        uint8 arraySize = qsize(q_);
        uint256 time = 0;

        //Iterate to find matching address
        index = q_.front;

        for (i = 0; i < arraySize; i++){
            if (sendingAddr_ == q_.data[index])
                break;

            index = (index + 1) % ((uint8)(q_.data.length)) ;
        }

        //if no matching found, set to 0xFF
        if (i != arraySize)
            time = q_.time[q_.front];

        return time;
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
        //If queue is full, return right away
        if ((q_.back + 1) % q_.data.length == q_.front)
            return; // throw;

        //If addr already exist, return right away
        for (uint8 i = 0; i <= q_.back; i++){
            if (addr_ == q_.data[i])
                return;
        }

        q_.data[q_.back] = addr_;
        q_.time[q_.back] = now + TIME_DIFF;
        q_.back = (q_.back + 1) % ((uint8)(q_.data.length));
	}

}
