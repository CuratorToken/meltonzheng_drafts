const { ethers, network } = require('hardhat')
const chai = require('chai')
const { solidity } = require('ethereum-waffle')
const chaiAsPromised = require('chai-as-promised')
const { isCallTrace } = require('hardhat/internal/hardhat-network/stack-traces/message-trace')
const { Contract } = require('hardhat/internal/hardhat-network/stack-traces/model')
const { expect } = chai

chai.use(chaiAsPromised)
chai.use(solidity)

const _Voting = artifacts.require("Voting");
contract("Voting", (accounts) =>{

    const testContent = 'z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE'

    let [alice, bob] = accounts;
    let contractInstance;
    beforeEach(async () => {
        contractInstance = await _Voting.new();
    });
    it(`should make some new content`, async ()=>{
        contractInstance.connect(alice).makeNewContent(testContent)
    })

    // Not sure how to test the emit

    it(`should get back content length`, async ()=>{
        var c = await contractInstance.connect(alice).getContentLength()
        expect(c).to.equal(1)
    })
})

describe(`Voting`,()=>{

    const testContent = 'z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE'

    let account1
    let account2
    before(`load accounts`, async () => {
    ;[ account1, account2 ] = await ethers.getSigners()
    })

    let Voting
    beforeEach(`deploy Voting contract`, async () => {
        const Factory__Voting = await ethers.getContractFactory('Voting')
        Voting = await Factory__Voting.connect(account1).deploy()
        await Voting.deployTransaction.wait()
    })    

    it(`should make some new content`, async ()=>{
        Voting.connect(account1).makeNewContent(testContent)
    })

    // Not sure how to test the emit

    it(`should get back content length`, async ()=>{
        var c = await Voting.connect(account1).getContentLength()
        expect(c).to.equal(1)
    })
})