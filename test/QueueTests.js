'use strict';
const Web3 = require('web3');
const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
const helper = require("./helpers/truffleTestHelper");

/* Add the dependencies you're testing */
const BuyerQueue = artifacts.require("./BuyerQueue.sol");
// YOUR CODE HERE

contract('BuyerQueue', function(accounts) {
	/* Define your constant variables and instantiate constantly changing
	 * ones
	 */
	const args = {};
	let queue;
	// YOUR CODE HERE

	/* Do something before every `describe` method */
	beforeEach(async function() {
		queue = await BuyerQueue.new();

	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Queue', function() {
		it("Constrcutor", async function() {
			let currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 0,	"size inited");
		});

        it("empty", async function() {
			let isEmpty = await queue.empty.call();
			assert.equal(isEmpty.valueOf(), true,	"queue empty");

            //Add address
			queue.enqueue(accounts[0]);
			let currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 1,	"addr 0");

            isEmpty = await queue.empty.call();
			assert.equal(isEmpty.valueOf(), false,	"queue not empty");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 0,	"1 addr removed");

            isEmpty = await queue.empty.call();
			assert.equal(isEmpty.valueOf(), true,	"queue empty");
		});

		it("enqueue", async function() {
			let currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 0,	"size inited");

			//Add address
			queue.enqueue(accounts[0]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 1,	"addr 0");

            //can't addd the same
			queue.enqueue(accounts[0]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 1,	"cant add the same addr");

            //add more addrs
			queue.enqueue(accounts[1]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 2,	"addr 1");

			queue.enqueue(accounts[2]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 3,	"addr 2");

			queue.enqueue(accounts[3]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 4,	"addr 3");

            queue.enqueue(accounts[3]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 4,	"cant add the same addr");

			queue.enqueue(accounts[4]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 5,	"addr 4");

			queue.enqueue(accounts[5]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 5,	"can't add more");

			queue.enqueue(accounts[6]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 5,	"can't add more");
		});

        it("dequeue", async function() {
            let currentSize = await queue.qsize.call();

            queue.enqueue(accounts[9]);
			currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 1,	"1 addr added");

            queue.dequeue();
			currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 0,	"1 addr removed");

            queue.enqueue(accounts[5]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 1,	"1 addr added");

            queue.enqueue(accounts[6]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 2,	"2 addr added");

            queue.enqueue(accounts[7]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 3,	"3 addr added");

            queue.enqueue(accounts[8]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 4,	"4 addr added");

            queue.enqueue(accounts[9]);
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 5,	"5 addr added");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 4,	"1 addr removed");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 3,	"1 addr removed");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 2,	"1 addr removed");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 1,	"1 addr removed");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 0,	"1 addr removed");

            queue.dequeue();
            currentSize = await queue.qsize.call();
            assert.equal(currentSize.valueOf(), 0,	"0 addr removed");
        });


    it("getFirst", async function() {
		let currentSize = await queue.qsize.call();
        let currentAddr = await queue.getFirst.call();
		//assert.equal(currentAddr, address(0),	"no addr");

		//Add address
		queue.enqueue(accounts[0]);
        currentAddr = await queue.getFirst.call();
        assert.equal(currentAddr, accounts[0],	"1st addr");

        queue.dequeue();

        //Add address
        queue.enqueue(accounts[9]);
        currentAddr = await queue.getFirst.call();
        assert.equal(currentAddr, accounts[9],	"1st addr");

	});

    it("doCheckPlace", async function() {
        let currentPlace = await queue.doCheckPlace.call(accounts[0]);
        assert.equal(currentPlace.valueOf(), 0xFF, "no place");

        //Add address
        queue.enqueue(accounts[0]);
        queue.enqueue(accounts[1]);
        queue.enqueue(accounts[2]);
        queue.enqueue(accounts[3]);
        queue.enqueue(accounts[4]);

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[0]);
        assert.equal(currentPlace.valueOf(), 0,	"place 0");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[1]);
        assert.equal(currentPlace.valueOf(), 1,	"place 1");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[2]);
        assert.equal(currentPlace.valueOf(), 2,	"place 2");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[3]);
        assert.equal(currentPlace.valueOf(), 3,	"place 3");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[4]);
        assert.equal(currentPlace.valueOf(), 4,	"place 4");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[5]);
        assert.equal(currentPlace.valueOf(), 0xFF,	"non existing");

        //check place
        currentPlace = await queue.doCheckPlace.call(accounts[9]);
        assert.equal(currentPlace.valueOf(), 0xFF,	"non existing");

    });

    it("doCheckTime", async function() {
        const advancement = 604800;
        let originalBlock;
        let newBlock;

        await web3.eth.getBlock('latest')
        .then(function (block) {
           originalBlock = block;
        }).catch(function(e) {
           console.log(e);
        });

        //Check time of empty queue
        await queue.doCheckTime.call(originalBlock.timestamp);

        let currentSize = await queue.qsize.call();
        assert.equal(currentSize.valueOf(), 0, "non existing");

        //Add address
        queue.enqueue(accounts[0]);

        await web3.eth.getBlock('latest')
        .then(function (block) {
           originalBlock = block;
        }).catch(function(e) {
           console.log(e);
        });

        await queue.doCheckTime.call(originalBlock.timestamp);

        currentSize = await queue.qsize.call();
        assert.equal(currentSize.valueOf(), 1, "still in queue");

        let currentPlace = await queue.doCheckPlace.call(accounts[0]);
        assert.equal(currentPlace.valueOf(), 0,	"place 0");

        //let currentTime = await queue.doCheckInputTime.call(accounts[0]);
        //assert.equal(currentTime.valueOf(), originalBlock.timestamp, "time 0");

        //advance time
        newBlock = await helper.advanceTimeAndBlock(advancement);

        const timeDiff = newBlock.timestamp - originalBlock.timestamp;

        assert.isTrue(timeDiff >= advancement);

        //Check queue
        await queue.doCheckTime(newBlock.timestamp)
        //await queue.doCheckTime(1)
        .then(function () {
           ;
        }).catch(function(e) {
           console.log(e);
        });

        currentSize = await queue.qsize.call();
        assert.equal(currentSize.valueOf(), 0, "Removed");
    });
	});

describe("Testing Helper Functions", () => {
    it("should advance the blockchain forward a block", async () =>{
        let originalBlock;
        let newBlock;

        await web3.eth.getBlock('latest')
        .then(function (block) {
           originalBlock = block;
        }).catch(function(e) {
           console.log(e);
        });

        //Advance current block
        newBlock = await helper.advanceBlock();

        assert.notEqual(originalBlock.hash, newBlock.hash);
    });

    it("should be able to advance time and block together", async () => {
        const advancement = 600;
        let originalBlock;
        let newBlock;

        await web3.eth.getBlock('latest')
        .then(function (block) {
           originalBlock = block;
        }).catch(function(e) {
           console.log(e);
        });

        //Advance time and block
        newBlock = await helper.advanceTimeAndBlock(advancement);
        const timeDiff = newBlock.timestamp - originalBlock.timestamp;

        assert.isTrue(timeDiff >= advancement);
    });
});
});
