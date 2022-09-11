## Gitpod

[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/Aletheia-Data/contracts.aletheiadata.org)

# CONTRACTS Aletheia Data

Aletheia is an Open Source project that seeks to encourage both public and private entities to facilitate
access to public information, so that it can have a more relevant social impact.

As developers we have seen the need to make use of public information (information in the public
domain that should be available and accessible by law), but in the search we quickly realized that
although the information is (in part) available, it is not organized in a way that is easy to use (uses that
can range from the simple consultation of the data, to statistical use or to create computer smart
products oriented to citizens.

Another problem that we frequently find is the lack of a standard in the format of these files. As well as
the use of formats that DO NOT allow the extraction of the information. We know that, like us, there are
other Citizens who need to access this data and this is why we decided to develop an Open API to
facilitate access and distribution of resourceful public information.

The objective is to create an ecosystem where these files are ALWAYS available, accessible 24 hours a
day and accompanied by APIs to facilitate the consumption and exchange of this information while
providing an immutable and reliable "single source of truth".

**Table of Contents**

- [🏄 Get Started](#-get-started)
- [🛳 Deploy](#-deploy)
- [💖 Contributing](#-contributing)

## 🏄 Get Started

This project is a basic [Hardhat](https://hardhat.org/docs) project. It comes with our contracts, tests for the contracts, and a script that deploys the contracts.

To start local development:

```bash
git clone git@github.com:Aletheia-Data/contracts.aletheiadata.org.git
cd contracts.aletheiadata.org

# OPTIONAL: when using nvm to manage Node.js versions
nvm use

npm install
```

Finally, set environment variables to use this local connection in `.env` in the app:

```bash
# modify env variables
cp .env.dist .env
```

## ⚙️ Usage

### Compile

Compile the smart contracts with Hardhat:

```sh
$ npx hardhat compile
```

### Test

Run Tests:

```sh
$ npx hardhat test
```

### Added plugins

- Gas reporter [hardhat-gas-reporter](https://hardhat.org/plugins/hardhat-gas-reporter.html)
- Etherscan [hardhat-etherscan](https://hardhat.org/plugins/nomiclabs-hardhat-etherscan.html)

## 🛳 Deploy

Deploy contract to network (requires PRIVATE and ALCHEMY API key)

```
npx hardhat run ./scripts/deploy.js --network <NETWORK>
```

Validate a contract with etherscan (requires API key)

```
npx hardhat verify --network <NETWORK> <DEPLOYED_CONTRACT_ADDRESS> "Constructor argument 0"
```

## 💖 Contributing

We welcome contributions in form of bug reports, feature requests, code changes, or documentation improvements.

Please make sure to follow our guidelines:

- [Code of Conduct →](#)

For important changes please create first an (issue)[https://github.com/Aletheia-Data/contracts.aletheiadata.org/issues/new] to discuss what you would like to change.

Plase make sure that for each PR the necessary test are done.
