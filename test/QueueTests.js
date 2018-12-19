'use strict';

/* Add the dependencies you're testing */
const BuyerQueue = artifacts.require("./BuyerQueue.sol");
// YOUR CODE HERE

contract('QueueTest', function(accounts) {
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

		it("enqueue", async function() {
			let currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 0,	"size inited");

			//Add address
			queue.enqueue(accounts[0]);
			currentSize = await queue.qsize.call();
			assert.equal(currentSize.valueOf(), 1,	"addr 0");

            // //can't addd the same
			// queue.enqueue(accounts[0]);
			// currentSize = await queue.qsize.call();
			// assert.equal(currentSize.valueOf(), 1,	"cant add the same addr");

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

        // it("dequeue", async function() {
        //     let currentSize = await queue.qsize.call();
        //
        //     queue.enqueue(accounts[1]);
		// 	currentSize = await queue.qsize.call();
        //     assert.equal(currentSize.valueOf(), 1,	"1 addr added");
        //
        //     queue.dequeue();
		// 	currentSize = await queue.qsize.call();
        //     assert.equal(currentSize.valueOf(), 0,	"1 addr removed");
        //
        // });
	});

});
