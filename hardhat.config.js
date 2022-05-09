require("@nomiclabs/hardhat-waffle");
const fs = require("fs");
const projectId = "c61e143c9590484a9ef45a95e2f80102";
const privateKey = fs.readFileSync(".secret").toString();

module.exports = {
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/L8JzqdGnY_ECTKCrC9zU5cyeE_HxD7OR",
      },
      //chainId: 1337,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${projectId}`,
      accounts: [privateKey],
    },
  },
  solidity: {
    compilers: [
      {
        version: "0.6.0",
      },
      {
        version: "0.8.0",
      },
      {
        version: "0.8.9",
      },
    ],
  },
};
