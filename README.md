# BBD_APP 🚀

A hybrid **Angular frontend** with **Solidity smart contracts**, generated using Angular CLI v15.0.4. Ideal for blockchain-based dashboard or dApp development.

---

## 🎯 Features

- **Angular SPA** with TypeScript & SCSS  
- **Solidity contracts** for on-chain interaction  
- **Modular structure**: ready for components, services, directives  
- **Testing-ready**: Unit tests (Karma + Jasmine), placeholder for E2E (Protractor/Cypress)

---

## 🛠 Requirements

- Node.js v16+ & npm v8+  
- Angular CLI v15+  
- Truffle or Hardhat (for contract development)  
- Ethereum client / Testnet access (Ganache, Infura, etc.)

---

## 🚧 Quickstart Guide

### 1. Setup

git clone https://github.com/PowerRyder/BBD_APP.git
cd BBD_APP
npm install


### 2. Angular Development

Start local dev server:

ng serve


Navigate to \`http://localhost:4200\`. The app auto-reloads upon changes.

### 3. Smart Contracts (if using Hardhat)

cd contracts
npm install
npx hardhat compile
npx hardhat test
npx hardhat node   # for local network


Deploy contracts:

npx hardhat run scripts/deploy.js --network localhost

### 4. Frontend Integration

- Update \`environment.ts\` with deployed contract address  
- Use \`ethers.js\` or \`web3.js\` in Angular services to interact with contracts  
- Inject providers like \`Web3Provider\`, \`Signer\` for wallet interaction

---

## 📦 Build for Production

ng build --prod

Results in a production-ready build at \`dist/\`. Serve via any static server.

---

## 🧩 Code Generation

To scaffold a new Angular component:

ng generate component MyComponent

---

