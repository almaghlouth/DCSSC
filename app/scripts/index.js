// this java script got recycled from project 5 and extended to support the current project

import "../styles/app.css";

import { default as Web3 } from "web3";
import { default as contract } from "truffle-contract";

import DCSSCArtifact from "../../build/contracts/DCSSC.json";

const DCSSC = contract(DCSSCArtifact);

let accounts;
let account;

const DCSSCinfo = async () => {
  const instance = await DCSSC.deployed();
  var owner = await instance.getDCSSCOwner({ from: account });
  var migrate = await instance.getNewDCSSC({ from: account });
  var commision = await instance.getCommision({ from: account });
  var msg = "";
  if (migrate.toString() != "0x0000000000000000000000000000000000000000") {
    msg =
      "A new version of the system avaiable on this Address: " +
      (await migrate);
  }
  App.setDetails(
    "<br>Current DCSSC Owner Address: " +
      (await owner) +
      "<br>Current DCSSC Commision: " +
      (await commision) +
      "<br>" +
      msg,
    "0"
  );
};

const DCSSClookupItem = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id1").value;
  const serial = document.getElementById("serial1").value;
  const item1 = await instance.getItem(id, serial, { from: account });
  const item2 = await instance.trackItem(id, serial, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Serial: " +
      serial +
      "<br>Title: " +
      (await item1[0]) +
      "<br>Description: " +
      (await item1[1]) +
      "<br>Version: " +
      (await item1[2]) +
      "<br>Hash Value: " +
      (await item1[3]) +
      "<br>Link: " +
      (await item1[4]) +
      "<br>Creator: " +
      (await item2[0]) +
      "<br>Authenticator: " +
      (await item2[1]) +
      "<br>Publisher: " +
      (await item2[2]) +
      "<br>Seller: " +
      (await item2[3]) +
      "<br>Owner: " +
      (await item2[4]) +
      "<br>Price: " +
      (await item2[5]),
    "1"
  );
};

const DCSSCBuyItem = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id2").value;
  const serial = document.getElementById("seria2").value;
  const item1 = await instance.trackItem(id, serial, { from: account });
  await instance.BuyItem(id, serial, {
    from: account,
    gas: 100000,
    value: await item1[5]
  });
  const item3 = await instance.trackItem(id, serial, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Serial: " +
      serial +
      "<br>Creator: " +
      (await item3[0]) +
      "<br>Authenticator: " +
      (await item3[1]) +
      "<br>Publisher: " +
      (await item3[2]) +
      "<br>Seller: " +
      (await item3[3]) +
      "<br>Owner: " +
      (await item3[4]) +
      "<br>Price: " +
      (await item3[5]),
    "2"
  );
};

const DCSSCcreateContent = async () => {
  const instance = await DCSSC.deployed();
  const title = document.getElementById("title3").value;
  const description = document.getElementById("description3").value;
  const version = document.getElementById("version3").value;
  const hash = document.getElementById("hash3").value;
  const link = document.getElementById("link3").value;
  const item2 = await instance.createItem(
    title,
    description,
    version,
    hash,
    link,
    { from: account, gas: 100000 }
  );
  App.setDetails(
    "<br>ID: " +
      (await item2[0]) +
      "<br>Serial: " +
      (await item2[1]) +
      "<br>Title: " +
      (await item2[2]),
    "3"
  );
};

const DCSSCputContract = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id4").value;
  const price = document.getElementById("ContractPrice4").value;
  const royality = document.getElementById("Royality4").value;
  await instance.putContentForSale(id, price, royality, {
    from: account,
    gas: 100000
  });
  const item2 = await instance.getContentForSale(id, { from: account });
  App.setDetails(
    "<br>ID: " +
      (await item2[0]) +
      "<br>Auctioned: " +
      (await item2[1]) +
      "<br>Awarded: " +
      (await item2[2]) +
      "<br>Contract Price: " +
      (await item2[4]) +
      "<br>Royality: " +
      (await item2[5]),
    "4"
  );
};

const DCSSCbuyContract = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id5").value;
  const item1 = await instance.getContentForSale(id, { from: account });
  await instance.buyContentForSale(id, {
    from: account,
    gas: 100000,
    value: await item1[4]
  });
  const item3 = await instance.trackItem(id, serial, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Creator: " +
      (await item3[0]) +
      "<br>Authenticator: " +
      (await item3[1]) +
      "<br>Publisher: " +
      (await item3[2]) +
      "<br>Seller: " +
      (await item3[3]) +
      "<br>Owner: " +
      (await item3[4]) +
      "<br>Price: " +
      (await item3[5]),
    "5"
  );
};

const DCSSCauthenticate = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id6").value;
  const hash = document.getElementById("hash6").value;
  await instance.authenticate(id, hash, {
    from: account,
    gas: 100000
  });
  const item3 = await instance.trackItem(id, serial, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Creator: " +
      (await item3[0]) +
      "<br>Authenticator: " +
      (await item3[1]) +
      "<br>Publisher: " +
      (await item3[2]) +
      "<br>Seller: " +
      (await item3[3]) +
      "<br>Owner: " +
      (await item3[4]) +
      "<br>Price: " +
      (await item3[5]),
    "6"
  );
};

const DCSSCmassSell = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id6").value;
  const price = document.getElementById("price8").value;
  await instance.putMassSale(id, price, {
    from: account,
    gas: 100000
  });
  const item2 = await instance.getContentForSale(id, { from: account });
  App.setDetails(
    "<br>ID: " +
      (await item2[0]) +
      "<br>Auctioned: " +
      (await item2[1]) +
      "<br>Awarded: " +
      (await item2[2]) +
      "<br>Mass Sale: " +
      (await item2[3]),
    "7"
  );
};

const DCSSCestimate = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id8").value;
  const quantity = document.getElementById("quantity8").value;
  const item1 = await instance.estimateMassSale(id, quantity, {
    from: account
  });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Quantity: " +
      quantity +
      "<br>Estiamted Price: " +
      (await item1),
    "8"
  );
};

const DCSSCmassBuy = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id9").value;
  const quantity = document.getElementById("quantity9").value;
  const item1 = await instance.estimateMassSale(id, quantity, {
    from: account
  });
  await instance.buyMassSale(id, quantity, {
    from: account,
    gas: 100000,
    value: await item1
  });
  const item2 = await instance.checkStock(id, account, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Quantity: " +
      (await item2) +
      "<br>Address: " +
      account,
    "9"
  );
};

const DCSSCcheckStock = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id10").value;
  const address = document.getElementById("address10").value;
  const item1 = await instance.checkStock(id, address, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Quantity: " +
      (await item1) +
      "<br>Address: " +
      address,
    "10"
  );
};

const DCSSCsellItem = async () => {
  const instance = await DCSSC.deployed();
  const id = document.getElementById("id11").value;
  const price = document.getElementById("price11").value;
  const item0 = await instance.sellItem(id, price, { from: account });
  const item1 = await instance.getItem(id, await item0, { from: account });
  const item2 = await instance.trackItem(id, await item0, { from: account });
  App.setDetails(
    "<br>ID: " +
      id +
      "<br>Serial: " +
      serial +
      "<br>Title: " +
      (await item1[0]) +
      "<br>Description: " +
      (await item1[1]) +
      "<br>Version: " +
      (await item1[2]) +
      "<br>Hash Value: " +
      (await item1[3]) +
      "<br>Link: " +
      (await item1[4]) +
      "<br>Creator: " +
      (await item2[0]) +
      "<br>Authenticator: " +
      (await item2[1]) +
      "<br>Publisher: " +
      (await item2[2]) +
      "<br>Seller: " +
      (await item2[3]) +
      "<br>Owner: " +
      (await item2[4]) +
      "<br>Price: " +
      (await item2[5]),
    "1"
  );
};

const App = {
  start: function() {
    const self = this;

    DCSSC.setProvider(web3.currentProvider);

    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length === 0) {
        alert(
          "Couldn't get any accounts! Make sure your Ethereum client is configured correctly."
        );
        return;
      }

      accounts = accs;
      account = accounts[0];
      DCSSCinfo();
    });
  },

  setDetails: function(message, num) {
    const status = document.getElementById("details" + num);
    status.innerHTML = message;
  },

  DCSSC: function() {
    DCSSCinfo();
  },

  lookup: function() {
    DCSSClookupItem();
  },

  buyItem: function() {
    DCSSCBuyItem();
  },

  createContent: function() {
    DCSSCcreateContent();
  },

  putContract: function() {
    DCSSCputContract();
  },

  buyContract: function() {
    DCSSCbuyContract();
  },

  authenticate: function() {
    DCSSCauthenticate();
  },

  massSell: function() {
    DCSSCmassSell();
  },

  estimate: function() {
    DCSSCestimate();
  },

  massBuy: function() {
    DCSSCmassBuy();
  },

  checkStock: function() {
    DCSSCcheckStock();
  },

  sellItem: function() {
    DCSSCsellItem();
  }
};

window.App = App;

window.addEventListener("load", function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== "undefined") {
    console.warn(
      "Using web3 detected from external source." +
        " If you find that your accounts don't appear or you have 0 MetaCoin," +
        " ensure you've configured that source properly." +
        " If using MetaMask, see the following link." +
        " Feel free to delete this warning. :)" +
        " http://truffleframework.com/tutorials/truffle-and-metamask"
    );
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn(
      "No web3 detected. Falling back to http://127.0.0.1:9545." +
        " You should remove this fallback when you deploy live, as it's inherently insecure." +
        " Consider switching to Metamask for development." +
        " More info here: http://truffleframework.com/tutorials/truffle-and-metamask"
    );
    // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
    window.web3 = new Web3(
      new Web3.providers.HttpProvider("http://127.0.0.1:9545")
    );
  }

  App.start();
});
