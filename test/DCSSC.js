//import 'babel-polyfill';
const DCSSC = artifacts.require("./DCSSC.sol");

contract("DCSSC", async accounts => {
  //constructor
  it("Constructor assigned contract creator as DCSSC owner", async () => {
    let instance = await DCSSC.deployed();
    assert.equal(await instance.getDCSSCOwner.call(), accounts[0]);
  });

  //createItem
  it("Can create Item", async () => {
    let instance = await DCSSC.deployed();
    await instance.createItem(
      "Test Item",
      "Item Description test",
      1,
      "sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39",
      "http://www.maghlouth.com/",
      { from: accounts[1], gas: 1000000 }
    );
    let item = await instance.getItem.call(0, 0);
    assert.equal(item[0], "Test Item");
  });

  //getItem
  it("Can get Item", async () => {
    let instance = await DCSSC.deployed();
    let item = await instance.getItem.call(0, 0);
    assert.equal(item[1], "Item Description test");
  });

  //trackItem
  it("can track Item", async () => {
    let instance = await DCSSC.deployed();
    let item = await instance.trackItem.call(0, 0);
    assert.equal(item[0], accounts[1]);
  });

  //getDCSSCOwner
  it("Can get DCSSC Smart Contract Owner", async () => {
    let instance = await DCSSC.deployed();
    assert.equal(await instance.getDCSSCOwner.call(), accounts[0]);
  });

  //setDCSSCOwnerasOwner
  it("Can set DCSSC smart contract owner by current owner", async () => {
    let instance = await DCSSC.deployed();
    await instance.setDCSSCOwner(accounts[7], {
      from: accounts[0],
      gas: 1000000
    });
    //console.log("current owner : " + (await instance.getDCSSCOwner.call()));
    assert.equal(await instance.getDCSSCOwner.call(), accounts[7].toString());
  });

  //getCommision
  it("Can get DCSSC smart contract commision", async () => {
    let instance = await DCSSC.deployed();
    assert.equal(await instance.getCommision.call(), 0);
  });

  //setCommisionasOwner
  it("Can set DCSSC smart contract commision by current owner", async () => {
    let instance = await DCSSC.deployed();
    await instance.setCommision(50, { from: accounts[7], gas: 1000000 });
    assert.equal(await instance.getCommision.call(), 50);
  });

  //getNewDCSSC
  it("Can get new DCSSC smart contract address", async () => {
    let instance = await DCSSC.deployed();
    assert.equal(
      await instance.getNewDCSSC.call(),
      "0x0000000000000000000000000000000000000000"
    );
  });

  //putContentForSale
  it("Can put contents for sale", async () => {
    let instance = await DCSSC.deployed();
    await instance.putContentForSale(0, 1400, 50, {
      from: accounts[1],
      gas: 1000000
    });
    let item = await instance.getContentForSale.call(0);
    assert.equal(await item[1], true);
  });

  //getContentForSale
  it("Can get contents for sale", async () => {
    let instance = await DCSSC.deployed();
    let item = await instance.getContentForSale.call(0);
    assert.equal(await item[1], true);
  });

  //authenticate
  it("Can authenticate content", async () => {
    let instance = await DCSSC.deployed();
    await instance.authenticate(
      0,
      "sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39",
      { from: accounts[5], gas: 1000000 }
    );
    let obj = await instance.getContentForSale.call(0);
    assert.equal(
      await obj[6],
      "sha256:8ACD0F91D1311BE5836078DDF9E1E2F8C2331A400E2A577F905B822444EB1F39"
    );
  });

  //buyContentForSale
  it("Can buy contents for sale", async () => {
    let instance = await DCSSC.deployed();
    await instance.buyContentForSale(0, {
      from: accounts[2],
      gas: 1000000,
      value: 1400
    });
    let item = await instance.trackItem.call(0, 0);
    assert.equal(await item[2], accounts[2]);
  });

  //putMassSale
  it("Can put contents for mass sale", async () => {
    let instance = await DCSSC.deployed();
    await instance.putMassSale(0, 100, { from: accounts[2], gas: 1000000 });
    let item = await instance.getContentForSale.call(0);
    //console.log("mass Sale : " + (await JSON.stringify(item)));
    assert.equal(await item[3], true);
  });

  //estimateMassSale
  it("Can estimate mass sale costs", async () => {
    let instance = await DCSSC.deployed();
    let item = await instance.estimateMassSale(0, 5);
    //console.log("Estimated value : " + (await item.toNumber()));
    assert.equal(await item.toNumber(), 500);
  });

  //buyMassSale
  it("Can mass buy contents from mass sale", async () => {
    let instance = await DCSSC.deployed();
    await instance.buyMassSale(0, 20, {
      from: accounts[3],
      gas: 1000000,
      value: 2000
    });
    let item = await instance.checkStock(0, accounts[3].toString());
    assert.equal(await item.toNumber(), 20);
  });

  //checkStock
  it("Seller can check his own stock", async () => {
    let instance = await DCSSC.deployed();
    let item = await instance.checkStock(0, accounts[3].toString());
    //console.log("Stock Found : " + (await item.toNumber()));
    assert.equal(await item.toNumber(), 20);
  });

  //sellItem
  it("Seller can put an item for sale", async () => {
    let instance = await DCSSC.deployed();
    await instance.sellItem(0, 200, {
      from: accounts[3],
      gas: 1000000
    });
    let item = await instance.trackItem.call(0, 1);
    assert.equal(await item[3], accounts[3].toString());
  });

  //buyItem
  it("Buyer can buy an item from sell list", async () => {
    let instance = await DCSSC.deployed();
    await instance.buyItem(0, 1, {
      from: accounts[4],
      gas: 1000000,
      value: 300
    });
    let item = await instance.trackItem.call(0, 1);
    assert.equal(await item[4], accounts[4].toString());
  });

  //setNewDCSSCasowner
  it("Can set new DCSSC smart contract by current owner", async () => {
    let instance = await DCSSC.deployed();
    await instance.setNewDCSSC(accounts[9], {
      from: accounts[7],
      gas: 1000000
    });
    assert.equal(await instance.getNewDCSSC.call(), accounts[9].toString());
  });
});
