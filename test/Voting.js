const { ethers, network } = require('hardhat')
const chai = require('chai')
const { solidity } = require('ethereum-waffle')
const chaiAsPromised = require('chai-as-promised')
const { isCallTrace } = require('hardhat/internal/hardhat-network/stack-traces/message-trace')
const { Contract } = require('hardhat/internal/hardhat-network/stack-traces/model')
const { expect } = chai

chai.use(chaiAsPromised)
chai.use(solidity)

describe(`Voting`,()=>{

    const testContent = "z8mWaJHXieAVxxLagBpdaNWFEBKVWmMiE"

    let account1
    let account2
    before(`load accounts`, async () => {
    ;[ account1, account2 ] = await ethers.getSigners()
    })

    let Voting
    beforeEach(`deploy Voting contract`, async () => {
        const Factory__Voting = await ethers.getContractFactory('Voting')
        Voting = await Factory__Voting.deploy()
        await Voting.deployTransaction.wait()
    })    

    it(`should add some new content`, async ()=>{
        expect( await Voting.addNewContent(testContent) ).to.emit(Voting, 'NewContent').withArgs(1);
    })

    it(`should get back content length`, async ()=>{
        await Voting.addNewContent(testContent)
        var c = await Voting.connect(account1).getContentLength()
        expect(c).to.equal(1)
    })
})