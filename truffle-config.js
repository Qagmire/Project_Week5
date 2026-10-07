const Ganache = require("ganache");
let testProvider;
module.exports = {
  networks: {
    development: { host: "127.0.0.1", port: 8545, network_id: "*" },
    test: {
      provider: () => testProvider || (testProvider = Ganache.provider({
        logging: { quiet: true }, wallet: { totalAccounts: 6 },
        chain: { chainId: 1338, networkId: 5778 }
      })),
      network_id: "*"
    }
  },
  compilers: { solc: { version: require.resolve("solc/soljson.js") } }
};

