const { ethGetBalance } = require('./web3');
const BigNumber = web3.utils.BN;

async function balanceDifference (account, promiseFunc) {
  const balanceBefore = await ethGetBalance(account);
  await promiseFunc();
  const balanceAfter = await ethGetBalance(account);
  return new web3.utils.BN(balanceAfter).sub(new web3.utils.BN(balanceBefore));
}

module.exports = {
  balanceDifference,
};
