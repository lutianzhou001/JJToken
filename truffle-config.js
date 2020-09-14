/**
 * Use this file to configure your truffle project. It's seeded with some
 * common settings for different networks and features like migrations,
 * compilation and testing. Uncomment the ones you need or modify
 * them to suit your project as necessary.
 *
 * More information about configuration can be found at:
 *
 * truffleframework.com/docs/advanced/configuration
 *
 * To deploy via Infura you'll need a wallet provider (like @truffle/hdwallet-provider)
 * to sign your transactions before they're sent to a remote public node. Infura accounts
 * are available for free at: infura.io/register.
 *
 * You'll also need a mnemonic - the twelve word phrase the wallet uses to generate
 * public/private key pairs. If you're publishing your code to GitHub make sure you load this
 * phrase from a file you've .gitignored so it doesn't accidentally become public.
 *
 */

// const HDWalletProvider = require('@truffle/hdwallet-provider');
// const infuraKey = "fj4jll3k.....";
//
// const fs = require('fs');
// const mnemonic = fs.readFileSync(".secret").toString().trim();
var HDWalletProvider = require('truffle-hdwallet-provider');

var privateKeys = [
  // admin
  "0x20ab39aa6f08575f06141cdb8211a3fba4b51954c4f8d7e54a2b53b04aaec54c",
  // store1
  "0x4ada9b8f5f9056627960f3486d88ae280ce94d65ab8cde213c53eb101e7a9580",
  // store2
  "0x19f4fc29e44d509877dce10a61c43e5ef4332b77ea6173c2a420b83b0d2bd209",
  //enterprise1
  "0x02c8bcb6c3d5779ec6f0217b519009dba2ed68e7568301c7cca75639c31a64a2",
  //enterprise2
  "0x1e5bc3ee97bc07722bcddbd265389682fa41e1bab611c98c2f234472b5240992",
  // staff1
  "0x23ac32a2f7419bd8d90afcc53d0f940daffd9bff66fe1a927ca29e0f243e14cb",
  // staff2
  "0xe9b50bb86684dfcdd6b887e6ebcfba049692d9f8b3699b5066cbdf40fe4d3c24",
  // feeaddress
  "0x8627c69a23f4eb1f69a2b1801daa43af77f71c3d6cca339ff889af43cdc125b9",
]

module.exports = {
  /**
   * Networks define how you connect to your ethereum client and let you set the
   * defaults web3 uses to send transactions. If you don't specify one truffle
   * will spin up a development blockchain for you on port 9545 when you
   * run `develop` or `test`. You can ask a truffle command to use a specific
   * network from the command line, e.g
   *
   * $ truffle test --network <network-name>
   */

  networks: {
    // Useful for testing. The `development` name is special - truffle uses it by default
    // if it's defined here and no other network is specified at the command line.
    // You should run a client (like ganache-cli, geth or parity) in a separate terminal
    // tab if you use this network and you must also set the `host`, `port` and `network_id`
    // options below to some value.
    //
    development: {
      provider: () => new HDWalletProvider(privateKeys, "http://47.75.214.198:8502", 0, 7),
      host: "47.75.214.198",
      port: "8502",
      network_id: "8888",
      gasPrice: 0,
    },


    //development: {
    //  host: "47.75.214.198",     // Localhost (default: none)
    //  port: 8502,            // Standard Ethereum port (default: none)
    //  network_id: "8888",       // Any network (default: none)
    //},
    //
    //
    // Another network with more advanced options...
    // advanced: {
    // port: 8777,             // Custom port
    // network_id: 1342,       // Custom network
    // gas: 8500000,           // Gas sent with each transaction (default: ~6700000)
    // gasPrice: 20000000000,  // 20 gwei (in wei) (default: 100 gwei)
    // from: <address>,        // Account to send txs from (default: accounts[0])
    // websockets: true        // Enable EventEmitter interface for web3 (default: false)
    // },
    // Useful for deploying to a public network.
    // NB: It's important to wrap the provider as a function.
    // ropsten: {
    // provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/YOUR-PROJECT-ID`),
    // network_id: 3,       // Ropsten's id
    // gas: 5500000,        // Ropsten has a lower block limit than mainnet
    // confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    // timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    // skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    // },
    // Useful for private networks
    // private: {
    // provider: () => new HDWalletProvider(mnemonic, `https://network.io`),
    // network_id: 2111,   // This network is yours, in the cloud.
    // production: true    // Treats this network as if it was a public net. (default: false)
    // }
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.6.10",    // Fetch exact version from solc-bin (default: truffle's version)
      // docker: true,        // Use "0.5.1" you've installed locally with docker (default: false)
      // settings: {          // See the solidity docs for advice about optimization and evmVersion
      //  optimizer: {
      //    enabled: false,
      //    runs: 200
      //  },
      //  evmVersion: "byzantium"
      // }
    },
  },
};
