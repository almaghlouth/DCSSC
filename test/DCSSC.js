//import 'babel-polyfill';
const DCSSC = artifacts.require('./DCSSC.sol')

let instance;
let accounts;

contract('DCSSC', async(accs) => {
   accounts = accs;
   instance = await DCSSC.deployed();

//constructor
it('Constructor assigned contract creator as DCSSC owner', async() => {
   assert.equal(await instance.getDCSSCOwner.call(), accounts[0])
});

//createItem
it('Can create Item', async() => {
   await instance.createItem('Test Item','Item Description test',1,'sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39','http://www.maghlouth.com/', { from: accounts[1] })
   assert.equal(await instance.getItem.call(0,0)[0], 'Test Item')
});

//getItem
it('Can get Item', async() => {
   await instance.createItem('Test Item','Item Description test',1,'sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39','http://www.maghlouth.com/', { from: accounts[1] })
   assert.equal(await instance.getItem.call(0,0)[1], 'Item Descreption test')
});

//trackItem
it('can track Item', async() => {
   await instance.createItem('Test Item','Item Description test',1,'sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39','http://www.maghlouth.com/', { from: accounts[1] })
   assert.equal(await instance.trackItem.call(0,0)[0], accounts[1])
});

//getDCSSCOwner
it('Can get DCSSC Smart Contract Owner', async() => {
   assert.equal(await instance.getDCSSCOwner.call(), accounts[0])
});

//setDCSSCOwnerasOther
it('Cannot set DCSSC smart contract owner without being the current owner', async() => {
   await instance.setDCSSCOwnert(accounts[2],{ from: accounts[1] })
   assert.equal(await instance.getDCSSCOwner.call(), accounts[0])
});

//setDCSSCOwnerasOwner
it('Can set DCSSC smart contract owner by current owner', async() => {
   await instance.setDCSSCOwnert(accounts[2],{ from: accounts[0] })
   assert.equal(await instance.getDCSSCOwner.call(), accounts[2])
});

//getCommision
it('Can get DCSSC smart contract commision', async() => {
   assert.equal(await instance.getCommision.call(), 0)
});

//setCommisionasOther
it('Cannot set DCSSC smart contract commision without being the current owner', async() => {
   await instance.setCommision(60000,{ from: accounts[1] })
   assert.equal(await instance.getCommision.call(), 0)
});

//setCommisionasOwner
it('Can set DCSSC smart contract commision by current owner', async() => {
   await instance.setCommision(90000,{ from: accounts[2] })
   assert.equal(await instance.getCommision.call(), 90000)
});

//getNewDCSSC
it('Can get new DCSSC smart contract address', async() => {
   assert.equal(await instance.getNewDCSSC.call(), '0x0')
});

//setNewDCSSCasOther
it('Cannot set DCSSC smart contract commision without being the current owner', async() => {
   await instance.getNewDCSSC(accounts[6],{ from: accounts[5] })
   assert.equal(await instance.getNewDCSSC.call(), '0x0')
});

//putContentForSale
it('Can put contents for sale', async() => {
   await instance.putContentForSale(0,5000000,30000, { from: accounts[1] })
   assert.equal(await instance.getContentForSale.call(0)[1], true)
});

//getContentForSale
it('Can get contents for sale', async() => {
   assert.equal(await instance.getContentForSale.call(0)[1], true)
});

//authenticate
it('Can authenticate content', async() => {
   await instance.authenticate(0,'sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39', { from: accounts[5] })
   assert.equal(await instance.getContentForSale.call(0)[6], 'sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39')
});

//buyContentForSale
it('Can buy contents for sale', async() => {
   await instance.putMassSale(0, { from: accounts[2], gas: 1000000, value: 5000000 })
   assert.equal(await instance.trackItem.call(0,0)[8], accounts[2])
});

//putMassSale
it('Can put contents for mass sale', async() => {
   await instance.putContentForSale(0,100000, { from: accounts[2] })
   assert.equal(await instance.getContentForSale.call(0)[3], true)
});

//estimateMassSale
it('Can estimate mass sale costs', async() => {
   assert.equal(await instance.estimateMassSale(0,4), 400000)
});

//buyMassSale
it('Can mass buy contents through mass sale', async() => {
   await instance.buyContentForSale(0,20, { from: accounts[3], gas: 1000000, value: 2000000 })
   assert.equal(await instance.massBuyStock[0][accounts[3]], 20)
});

//sellItem
it('Can mass buy contents through mass sale', async() => {
   await instance.sellItem(0,200000, { from: accounts[3]})
   assert.equal(await instance.trackItem.call(0,1)[9], accounts[3])
});

//buyItem
it('Can buy item from sell list', async() => {
   await instance.buyItem(0,1, { from: accounts[4], gas: 1000000, value: 320000 })
   assert.equal(await instance.trackItem.call(0,1)[10], accounts[4])
});

});

