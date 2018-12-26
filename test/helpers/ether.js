function ether (n) {
  return new web3.utils.BN(web3.toWei(n, 'ether'));
}

module.exports = {
  ether,
};
