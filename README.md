# Digital Contents Simple Supply Chain (DCSSC) v1.0

## Project Introduction

This project is a simple digital assets supply chain from the creator to the buyer through publisher/ authenticator and seller, built in solidity to run over Ethereum network along with an application webpage that interact with the smart contract.

### Supply Chain Flow

    Content Creator => Publisher(/+ Authenticator) => Seller => Buyer (consumer)

### Features

- Each Item have a **unique ID + Unique Serial Number**.
- All created items will be preserved with serial # 0 and owned by the creator.
- Creators can sell publishing rights of their created items.
- Publishers can authenticate items or use a third party to authenticate the items before it can be put for sale.
- Sellers can mass Buy items through publisher mass sale.
- Each Item can be tracked by `trackItem()` function.
- No restrcutions on playing multiroles as it all can be tracked by functions.

### Demo links

- Demo Contract Address on Rinkeby: `_`
- Demo Transaction Address on Rinkeby : `_`
- Link: `https://rinkeby.etherscan.io/token/`

### Diagrams

In this project under `diagrams` folder you will find 4 digrams explaning this project.

- `Activity Diagram.pdf`
- `Sequence Diagram.pdf`
- `State Diagram.pdf`
- `Data Diagram.pdf`

## Install and Config

    npm install -g truffle

then cd to the folder

    npm install
    truffle develop
    compile --reset
    test --reset
    migrate --reset

then from a second terminal run

    npm run dev

this will activate the app and the webpage on the local link: http://127.0.0.1:8080/

_Ensure metamask configured to run on truffle develop at custom RPC `http://127.0.0.1:9545/`_

_also to use rinkeby add your mnemonic and the infura link in `truffle.js`_

## License and Disclaimer

This project is not licensed for commercial use or reuse, and intended as precurser for Udacity Blockchain Development Nanodegree Capstone project.

App and Enviorment template were recycled from project 5 which used a Udacity boilerplate.

## Credits

**Developer:** Abdullah Almaghlouth

App and Enviorment template were recycled from project 5 which used a Udacity Bolierplate.
