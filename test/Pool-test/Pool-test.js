const { ethers } = require("hardhat");
const ERC20ABI = require("./ERC20.json");

const usdcAddress = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
const ethAddress = "0x64FF637fB478863B7468bc97D30a5bF3A428a1fD";

describe("SYLIUMPool", function () {
  let syliumPool;

  beforeEach(async () => {
    const SyliumPool = await ethers.getContractFactory("SYLIUMPool");
    syliumPool = await SyliumPool.deploy(2);
    await syliumPool.deployed();
  });

  it("Should simulate a SYLIUM minting and and SYLIUM redeeming", async function () {
    const provider = await ethers.provider;
    const [governance, receiver] = await ethers.getSigners();

    console.log("========== INITIALIZING THE TOKENS ==========");

    const USDC = new ethers.Contract(usdcAddress, ERC20ABI, provider);
    const ETH = new ethers.Contract(ethAddress, ERC20ABI, provider);

    console.log("========== INITIALIZING THE USER BALANCE ==========");
    console.log(receiver.address);
    console.log(governance.address);

    let address = await ETH.address;
    console.log(address);
    //let receiverBalance = await ETH.balanceOf(receiver.getAddress());
    //console.log(receiverBalance);

    /*console.log("========== nETH, nUSDC & nSYLIX ==========");
    let nEth,
      nUsdc,
      nSylix = await syliumPool.getSyliumIncollateral();
    console.log(nEth, nUsdc, nSylix);

    console.log("========== SYLIUM Minting transaction ==========");
    await await syliumPool.connect(user).mintSylium(10, { value: 10 });*/
  });
});

//https://stackoverflow.com/questions/71190549/owner-account-start-with-a-non-zero-dai-balance-in-hardhat-test-suite
// https://stackoverflow.com/questions/71190549/owner-account-start-with-a-non-zero-dai-balance-in-hardhat-test-suite
// https://medium.com/coinmonks/yield-farming-tutorial-part-2-ea5b5254805d
// https://kndrck.co/posts/local_erc20_bal_mani_w_hh/
// https://www.quicknode.com/guides/web3-sdks/how-to-connect-to-ethereum-network-with-ethers-js
// https://www.quicknode.com/guides/web3-sdks/how-to-connect-to-ethereum-network-with-ethers-js
