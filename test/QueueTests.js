'use strict';

/* Add the dependencies you're testing */
const Crowdsale = artifacts.require("./Queue.sol");
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
		queue = await Queue.new();

	});

	/* Group test cases together
	 * Make sure to provide descriptive strings for method arguements and
	 * assert statements
	 */
	describe('Queue', function() {
		it("Constrcutor", async function() {
			let index = await queue.qsize.call();
			/* Why do you think `.valueOf()` is necessary? */
			assert.equal(index.valueOf(), 0,
				"value set correctly");
		});
		// YOUR CODE HERE
	});

	describe('Your string here', function() {
		it("your string here", async function() {
				// YOUR CODE HERE
			});
		// YOUR CODE HERE
	});
});
