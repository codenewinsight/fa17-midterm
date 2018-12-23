const promisify = (inner) =>
  new Promise((resolve, reject) =>
    inner((err, res) => {
      if (err) { reject(err) }

      resolve(res);
    })
  );

// promisify: function (web3) {
//     // Pipes values from a Web3 callback.
//     var callbackToResolve = function (resolve, reject) {
//         return function (error, value) {
//                 if (error) {
//                     reject(error);
//                 } else {
//                     resolve(value);
//                 }
//             };
//     };

advanceTimeAndBlock = async (time) => {
    await advanceTime(time);
    await advanceBlock();

    return Promise.resolve(web3.eth.getBlock('latest'));
}

advanceTime = (time) => {
    return new Promise((resolve, reject) => {
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_increaseTime",
            params: [time],
            id: new Date().getTime()
        }, (err, result) => {
            if (err) { return reject(err); }
            return resolve(result);
        });
    });
}

advanceBlock = () => {
    return new Promise((resolve, reject) => {
        web3.currentProvider.send({
            jsonrpc: "2.0",
            method: "evm_mine",
            id: new Date().getTime()
        }, (err, result) => {
            if (err) { return reject(err); }
            const newBlock = Promise.resolve(web3.eth.getBlock('latest'));

            return resolve(newBlock)
        });
    });
}

module.exports = {
    promisify,
    advanceTime,
    advanceBlock,
    advanceTimeAndBlock
}
