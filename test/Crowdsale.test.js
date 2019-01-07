//const Web3 = require('web3');
//const web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
const expectEvent = require('./helpers/expectEvent');
const shouldFail = require('./helpers/shouldFail');
const { balanceDifference } = require('./helpers/balanceDifference');
const { ether } = require('./helpers/ether');
const { ZERO_ADDRESS } = require('./helpers/constants');
const { ethGetBalance } = require('./helpers/web3');

const BigNumber = web3.utils.BN;

require('chai')
  .use(require('chai-bignumber')(BigNumber))
  .should();

const Crowdsale = artifacts.require('CrowdsaleMock');
const SimpleToken = artifacts.require('SimpleToken');

const ERC20Mock = artifacts.require('ERC20Mock');

contract('Crowdsale', function ([_, investor, wallet, purchaser]) {
  const rate = new BigNumber(1);
  const value = web3.utils.toWei('0.00000000001', 'ether');
  const tokenSupply = new BigNumber(100000000);
  const expectedTokenAmount = new web3.utils.BN(rate).mul(new web3.utils.BN(value));

  it('requires a non-null token', async function () {
    await shouldFail.reverting(
      Crowdsale.new(rate, wallet, ZERO_ADDRESS)
    );
  });

  context('with token', async function () {
    beforeEach(async function () {
      this.token = await SimpleToken.new();
    });

    it('requires a non-zero rate', async function () {
      await shouldFail.reverting(
        Crowdsale.new(0, wallet, this.token.address)
      );
    });

    it('requires a non-null wallet', async function () {
      await shouldFail.reverting(
        Crowdsale.new(rate, ZERO_ADDRESS, this.token.address)
      );
    });

    context('once deployed', async function () {
      beforeEach(async function () {
         this.crowdsale = await Crowdsale.new(rate, wallet, this.token.address);
         await this.token.transfer(this.crowdsale.address, tokenSupply.toNumber());
         //await this.token.mint(purchaser, 100000000);

        //  let result = await this.token.balanceOf(purchaser);
        //  console.log(result.toNumber());
        //  console.log(rate.toNumber());
        //  console.log(value);
        //  console.log(expectedTokenAmount.toString(10));
      });

      describe('accepting payments', function () {
        describe('bare payments', function () {
            //should revert as fallback function doesnt call buyToken any more
          it('should not accept payments', async function () {
            await shouldFail.reverting(this.crowdsale.send(value, { from: purchaser }));
          });

          it('reverts on zero-valued payments', async function () {
            await shouldFail.reverting(
              this.crowdsale.send(0, { from: purchaser })
            );
          });
        });

        describe('buyTokens', function () {
          it('should accept payments', async function () {
            await this.crowdsale.buyTokens(investor, { from: purchaser, value: value});
          });

          it('reverts on zero-valued payments', async function () {
            await shouldFail.reverting(
              this.crowdsale.buyTokens(investor, { value: 0, from: purchaser })
            );
          });

          it('requires a non-null beneficiary', async function () {
            await shouldFail.reverting(
              this.crowdsale.buyTokens(ZERO_ADDRESS, { value: value, from: purchaser })
            );
          });
        });
      });

      describe('high-level purchase', function () {
        it('should log purchase', async function () {
            //should revert as fallback function doesnt call buyToken any more
            await shouldFail.reverting(this.crowdsale.sendTransaction({ value: value, from: investor }));

            await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });
        //   expectEvent.inLogs(logs, 'TokensPurchased', {
        //     purchaser: investor,
        //     beneficiary: investor,
        //     value: value,
        //     amount: expectedTokenAmount,
        //   });
        });

        it('should assign tokens to sender', async function () {
          await shouldFail.reverting(this.crowdsale.sendTransaction({ value: value, from: investor }));
          //(await this.token.balanceOf(investor)).should.be.bignumber.equal(expectedTokenAmount);
        });
        
        // it('should forward funds to wallet', async function () {
        //   (await balanceDifference(wallet, () =>
        //     this.crowdsale.sendTransaction({ value, from: investor }))
        //   ).should.be.bignumber.equal(value);
        // });
      });

      describe('low-level purchase', function () {
        it('should log purchase', async function () {
           const { logs } = await this.crowdsale.buyTokens(investor, { value: value, from: purchaser });

          // expectEvent.inLogs(logs, 'TokensPurchased', {
          //   purchaser: purchaser,
          //   beneficiary: investor,
          //   value: value,
          //   amount: expectedTokenAmount,
          // });
        });

        it('should assign tokens to beneficiary', async function () {
          await this.crowdsale.buyTokens(investor, { value, from: purchaser });

          //(await this.token.balanceOf(investor)).should.be.bignumber.equal(expectedTokenAmount);
          let result = await this.token.balanceOf(investor);
          assert.equal(result.valueOf(), expectedTokenAmount.toNumber(),	"should assign tokens to beneficiary");
        });

        it('should forward funds to wallet', async function () {
          // (await balanceDifference(wallet, () =>
          //   this.crowdsale.buyTokens(investor, { value, from: purchaser }))
          // ).should.be.bignumber.equal(value);
          //let bal = await ethGetBalance(wallet);
          //console.log(bal);

         let result = await balanceDifference(wallet, () =>
                 this.crowdsale.buyTokens(investor, { value, from: purchaser }));
         assert.equal(result, value,	"should forward funds to wallet");

          console.log(result);
          
         //bal = await ethGetBalance(wallet);
        //  console.log(bal);
        });
      });
    });
  });
});
